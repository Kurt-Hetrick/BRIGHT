#!/bin/bash

module load sge

REFRESH=$1

if [[ ! $REFRESH ]]
	then
	REFRESH=3600
fi

# need while statement to put this in a loop
# need if/else statement to say whether to email or not

while true; 
do
	qhost \
	| egrep -v "^-|global|node" \
	| sed -r 's/[[:space:]]+/\t/g' \
	| awk '{gsub(/G/,"",$5); print $0}' \
	| awk '$1~"c6100-"&&$5<94 {print $1 "\n" "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN"} \
	$1~"c6220-"&&$5<126 {print $1 "\n" "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN"} \
	$1~"c6320-"&&$5<126 {print $1 "\n" "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN"} \
	$1~"binabox"&&$5<126 {print $1 "\n" "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN"} \
	$1~"DellR730-"&&$5<126 {print $1 "\n" "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN"} \
	$1=="sunrhel3"&&$5<378 {print $1 "\n" "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN"} \
	$1=="sunrhel4"&&$5<503 {print $1 "\n" "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN"} \
	$1=="Bright-VM"&&$5<7 {print $1 "\n" "HAS" , $5 , "Gb RAM, WHICH IS LESS THAN IT SHOULD HAVE. PLEASE DRAIN, REBOOT AND UNDRAIN"}' \
	| mail -s \
	DROPPED_MEMORY_DETECTED \
	jhg-informatics@lists.johnshopkins.edu

	sleep $REFRESH

done
