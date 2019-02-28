#! /bin/bash

# Step 1: FastqToSam
# Adapted from Best Practices for GATK3
# See GATK Tutorial #6484: https://gatkforums.broadinstitute.org/gatk/discussion/6484

# USAGE: ./01_FastqToSam.sh [read 1 fastq] [read 2 fastq] [output prefix] [sample name] [read group] [library] [flowcell barcode] [sequencing center] 

PICARD=/utils/programs/picard-2.6.0/picard.jar
TEMPDIR=/temp
WORKDIR=/work

java -Xmx16G -jar -Djava.io.tmpdir=${TEMPDIR} ${PICARD} FastqToSam \
FASTQ=${WORKDIR}/${1} \
FASTQ2=${WORKDIR}/${2} \
OUTPUT=${WORKDIR}/${3}_01_FastqToSam.bam \
SAMPLE_NAME=${4} \
READ_GROUP_NAME=${5} \
LIBRARY_NAME=${6} \
PLATFORM_UNIT=${7} \
PLATFORM=ILLUMINA \
SEQUENCING_CENTER=${8} \
TMP_DIR=${TEMPDIR}
