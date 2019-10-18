#!/bin/bash

SCRIPT=$1 # WHAT SCRIPT DO YOU WANT TO RUN...CURRENTLY bwa.sh or samtools.sh. Full path
QUEUE=$2 # WHAT QUEUE DO YOU WANT TO SUBMIT TO...you can submit an array, i.e. prod.q,rnd.q,bigdata.q
THREADS=$3 # the number of threads to use for bwa or samtools. production level is 4 for bwa.
TEST_TYPE=$4 # FLOOD OR SINGLE (do you want to submit just one job or flood the entire sge cluster)
QUEUE_SLOTS=$5 # 4,3,2 OR 1 (this is for the pe slot environment. under the current set-up 1 slot would equal 4 threads...this is in here to be able to change that if slot count changed)

# create this directory if this does not already exist

	mkdir -p /mnt/research/active/QUMULO_TESTING/LOGS

# grab the total slot number from the queues selected as argument 2. exlude all.q and programmers.q

	TOTAL_SLOTS=`qstat -g c -q $QUEUE | awk 'NR>2' | sed -r 's/[[:space:]]+/\t/g' | egrep -v "all.q|programmers.q" | awk '{t+=$6} END {print t}'`

# the number of jobs that gets submitted would be the number of total slots online divided by the number slots you want to ask for unless you select SINGLE which means it is one

	if [ $TEST_TYPE == 'SINGLE' ]
		then
			JOB_COUNT=1
		else
			JOB_COUNT=`expr $TOTAL_SLOTS / $QUEUE_SLOTS`
	fi

# basic qsub cmd line to submit job

TEST_CONDITION ()
	{
		echo \
			qsub \
			-q $QUEUE \
			-o /mnt/research/active/QUMULO_TESTING/LOGS \
			-pe slots $QUEUE_SLOTS \
			$SCRIPT \
			$THREADS \
			$INSTANCE \
			$TEST_TYPE \
			$JOB_COUNT \
			$QUEUE_SLOTS \
			$TOTAL_SLOTS
	}

# the number of jobs to be be submitted is either one if you selected SINGLE for TEST_TYPE or the total number of slots divided by the slots you asked for each job

	if [ $TEST_TYPE == 'SINGLE' ]
		then
			for INSTANCE in $(eval echo {1..1})
				do
				TEST_CONDITION
				echo sleep 0.1s
			done
	else
		for INSTANCE in $(eval echo {1..$JOB_COUNT})
			do
			TEST_CONDITION
			echo sleep 0.1s
		done
	fi
