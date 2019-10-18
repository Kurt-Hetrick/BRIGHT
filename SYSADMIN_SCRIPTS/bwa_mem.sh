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

	THREADS=$1 # number of threads for bwa
	INSTANCE=$2 # what subfolder under the hostname subfolder where the output goes to
	TEST_TYPE=$3 # (SINGLE, a single job submission, OR FLOOD, entire queue or cluster of queues)
	JOB_COUNT=$4 # the number of jobs submitted along with this one
	QUEUE_SLOTS=$5 # how many jobs slots were requested for this job
	TOTAL_SLOTS=$6 # how many total job slots were available in the queue(s) for the submission that this job was part of.

# STATIC VARIRABLES

	FASTQ_1="/mnt/research/active/QUMULO_TESTING/FASTQ/HJCNMDMXX_2_GTCGAAGA_CAATGTGG_1.fastq.gz"
	FASTQ_2="/mnt/research/active/QUMULO_TESTING/FASTQ/HJCNMDMXX_2_GTCGAAGA_CAATGTGG_2.fastq.gz"
	REF_GENOME="/mnt/shared_resources/public_resources/GRCh38DH/GRCh38_full_analysis_set_plus_decoy_hla.fa"
	TEMP="/mnt/research/active/QUMULO_TESTING/TEMP"

	module load java/1.8.0_112

	BWA_DIR="/mnt/linuxtools/BWA/bwa-0.7.15"
	SAMBLASTER_DIR="/mnt/linuxtools/SAMBLASTER/samblaster-v.0.1.24"
	PICARD_DIR="/mnt/linuxtools/PICARD/picard-2.17.0"

	export PATH=".:$PATH:/bin"

# make directories for the temporary output

	mkdir -p $TEMP/$HOSTNAME/$INSTANCE

START_BWA_MEM=`date '+%s'`

	$BWA_DIR/bwa mem \
		-K 100000000 \
		-Y \
		-t 4 \
		$REF_GENOME \
		$FASTQ_1 \
		$FASTQ_2 \
	| $SAMBLASTER_DIR/samblaster \
		--addMateTags \
		-a \
	| java -jar \
	$PICARD_DIR/picard.jar \
	AddOrReplaceReadGroups \
	INPUT=/dev/stdin \
	CREATE_INDEX=true \
	SORT_ORDER=queryname \
	RGID=FOO \
	RGLB=FOO \
	RGPL=ILLUMINA \
	RGSM=FOO \
	RGPU=BAR \
	OUTPUT=$TEMP/$HOSTNAME/$INSTANCE/foo.bam

END_BWA_MEM=`date '+%s'`

echo BWA_MEM","$HOSTNAME","$INSTANCE","$THREADS","$TEST_TYPE","$JOB_COUNT","$QUEUE_SLOTS","$TOTAL_SLOTS","$START_BWA_MEM","$END_BWA_MEM \
| awk 'BEGIN {FS=",";OFS=","} {print $0,$10-$9,($10-$9)/60,($10-$9)/3600}' \
>> $TEMP/../BWA_MEM.WALL_CLOCK_TIMES.csv
