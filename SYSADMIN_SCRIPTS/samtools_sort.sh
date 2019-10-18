# ---qsub parameter settings---
# --these can be overrode at qsub invocation--

# tell sge to execute in bash
#$ -S /bin/bash 

# tell sge that you are in the users current working directory
#$ -cwd

# tell sge to export the users environment variables
#$ -V

# tell sge to output both stderr and stdout to the same file
#$ -j y

# export all variables, useful to find out what compute node the program was executed on
# redirecting stderr/stdout to file as a log.

	set

	echo

# INPUT ARGUMENTS

	THREADS=$1 # number of threads for samtools
	INSTANCE=$2 # what subfolder under the hostname subfolder where the output goes to
	TEST_TYPE=$3 # (SINGLE, a single job submission, OR FLOOD, entire queue or cluster of queues)
	JOB_COUNT=$4 # the number of jobs submitted along with this one
	QUEUE_SLOTS=$5 # how many jobs slots were requested for this job
	TOTAL_SLOTS=$6 # how many total job slots were available in the queue(s) for the submission that this job was part of.

# STATIC VARIABLES

	SAMTOOLS_DIR="/mnt/linuxtools/ANACONDA/anaconda2-5.0.0.1/bin"
	INPUT_FILE="/mnt/research/active/QUMULO_TESTING/CRAM/NA12891-0238064159.cram"
	TEMP="/mnt/research/active/QUMULO_TESTING/TEMP"

# make directories for the temporary output

	mkdir -p $TEMP/$HOSTNAME/$INSTANCE

START_SAMTOOLS_SORT=`date '+%s'`

$SAMTOOLS_DIR/samtools \
	sort -n \
	--threads $THREADS \
	$INPUT_FILE \
	-o $TEMP/$HOSTNAME/$INSTANCE/foo.sorted.cram

END_SAMTOOLS_SORT=`date '+%s'`

echo SAMTOOLS_SORT"," $HOSTNAME"," $INSTANCE"," $THREADS ","$TEST_TYPE","$JOB_COUNT","$QUEUE_SLOTS","$TOTAL_SLOTS","$START_SAMTOOLS_SORT","$END_SAMTOOLS_SORT \
| awk 'BEGIN {FS=",";OFS=","} {print $0,$10-$9,($10-$9)/60,($10-$9)/3600}' \
>> $TEMP/../BWA_MEM.WALL_CLOCK_TIMES.csv
