#!/bin/env bash

# INPUT VARIABLES

	NEW_DIRECTORY=$1 # path to directory that you want to check file sizes on.
		FOLDER_NAME=`basename $NEW_DIRECTORY`

	ROW_COUNT=$2 # LIST THE TOP X NUMBER OF FILE EXTENSIONS ORDERED BY SIZE. DEFAULT IS 15

			if [[ ! $ROW_COUNT ]]
				then
				ROW_COUNT=15
			fi

# load datamash

	module load datamash

# SUMMARIZE THE SIZE OF THE NEW FOLDER ADDED TO COMPLETED AND THE FIRST SUB-LEVEL FOLDERS

	echo $FOLDER_NAME >> test.message.txt
	echo HAS BEEN ADDED TO completed/04_MENDEL >> test.message.txt
	echo >> test.message.txt
	echo "############################################################" >> test.message.txt
	echo This is how much space it is taking up overall and broken down to the first level of subfolders >> test.message.txt
	echo >> test.message.txt

	du --max-depth=1 \
	$NEW_DIRECTORY \
		| sort -k 1,1nr \
		| awk 'BEGIN {OFS="\t"} \
		{if ($1>=1024&&$1<1048576) print $1/1024" Mb", $2; \
			else if ($1>=1048576&&1073741824) print $1/1048576 " Gb", $2 ; \
			else if ($1>=1073741824) print 1/1073741824 " Tb", $2 ; \
			else print $1 " Kb", $2}' \
	>> test.message.txt

# SUMMARIZE THE TOP 15 EXTENSIONS.

echo >> test.message.txt
echo "############################################################" >> test.message.txt
echo These are the 15 file extensions that are taking up the most space >> test.message.txt
echo >> test.message.txt

find $NEW_DIRECTORY -type f -exec du -a {} + \
	| awk 'BEGIN {FS="."} {print $1,$NF}' \
	| sed -r 's/[[:space:]]+/\t/g' \
	| sort -k 3,3 \
	| datamash -g 3 sum 1 \
	| sort -k 2,2nr \
	| awk 'BEGIN {print "EXTENSION" "\t" "SIZE_Gb"} {print $1 "\t" ($2/1024/1024)}' \
	| head -n $ROW_COUNT \
>> test.message.txt

# SEND AN EMAIL TO TEAMS and Kurt Hetrick

	# grab email addy

		SEND_TO=`cat /mnt/users/skel/EMAIL_ADDY_NEW_COMPLETED_PROJECTS.txt`

	# send email

		mail -s "$FOLDER_NAME has been added to completed/04_MENDEL" $SEND_TO \
		< test.message.txt

rm -rvf test.message.txt
