#!/bin/env bash

INPUT_DIRECTORY=$1 # path to directory that you want to check file sizes on.

ROW_COUNT=$2 # LIST THE TOP X NUMBER OF FILE EXTENSIONS ORDERED BY SIZE. DEFAULT IS 15

		if [[ ! $ROW_COUNT ]]
			then
			ROW_COUNT=15
		fi

module load datamash

find $INPUT_DIRECTORY -type f -exec du -a {} + \
| awk 'BEGIN {FS="."} {print $1 "\t" $NF}' \
| sort -k 3,3 \
| datamash -g 3 sum 1 \
| sort -k 2,2nr \
| awk 'BEGIN {print "EXTENSION" "\t" "SIZE_Gb"} {print $1 "\t" ($2/1024/1024)}' \
| head -n $ROW_COUNT
