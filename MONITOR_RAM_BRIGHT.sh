#!/bin/bash

module load sge

REFRESH=$1

if [[ ! $REFRESH ]]
	then
	REFRESH=3600
fi

# check the total memory using qhosts
# remove G from qhost output in column $5 so I can treat it as a number
# if mem total falls below preset output and store as MEM_CHECK variable.
# if null then do nothing (in bash semicolon : means do nothing)
# if variable is not null, send an email

while sleep $REFRESH ;
do
	MEM_CHECK=$(qhost \
	| egrep -v "^-|global|node" \
	| sed -r 's/[[:space:]]+/\t/g' \
	| awk '{gsub(/G/,"",$5); print $0}' \
	| awk '$1~"c6100-"&&$5<94 {print $1 , "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN" ";"} \
	$1~"c6220-"&&$5<126 {print $1 , "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN" ";"} \
	$1~"c6320-"&&$5<126 {print $1 , "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN" ";"} \
	$1~"binabox"&&$5<126 {print $1 , "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN" ";"} \
	$1~"DellR730-"&&$5<126 {print $1 , "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN" ";"} \
	$1=="sunrhel3"&&$5<378 {print $1 , "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN" ";"} \
	$1=="sunrhel4"&&$5<503 {print $1 , "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN" ";"} \
	$1=="Bright-VM"&&$5<7 {print $1 , "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN" ";"}') ;

	if [[ -z "$MEM_CHECK" ]]; then
		:
	else
		echo $MEM_CHECK | sed 's/;/\n\n/g' | mail -s DROPPED_MEMORY_DETECTED jhg-informatics@lists.johnshopkins.edu
	fi
done