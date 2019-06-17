#!/bin/env bash

INPUT_DIRECTORY=$1 # path to directory that you want to check file sizes on.

ROW_COUNT=$2 # LIST THE TOP X NUMBER OF FILE EXTENSIONS ORDERED BY SIZE. DEFAULT IS 10

		if [[ ! $ROW_COUNT ]]
			then
			ROW_COUNT=15
		fi

module load datamash

find $INPUT_DIRECTORY -type f -exec du -a {} + \
| awk 'BEGIN {FS="."} {print $1,$NF}' \
| sed -r 's/[[:space:]]+/\t/g' \
| sort -k 2,2 \
| datamash -g 2 sum 1 \
| sort -k 2,2nr 
| awk 'BEGIN {print "EXTENSION" "\t" "SIZE_Gb"} {print $1 "\t" ($2/1024/1024)}' \
| head $ROW_COUNT
