#! /bin/bash

# Step 4: MarkDuplicates
# Adapted from Best Practices for GATK3
# See GATK Tutorial #6747: http://gatkforums.broadinstitute.org/gatk/discussion/6747

# USAGE: ./04_MarkDuplicates.sh [input bam file]
# Assumes input bam file has suffix "_03_AlignCleanBam.bam"

PICARD=/utils/programs/picard-2.6.0/picard.jar
TEMPDIR=/temp
WORKDIR=/work

FILENAME=${1%_03_AlignCleanBam.bam}

MAX_RECORDS=150000
OPT_DIST=2500

java -Xmx42G -Djava.io.tmpdir=${TEMPDIR} -jar ${PICARD} MarkDuplicates \
INPUT=${WORKDIR}/${FILENAME}_03_AlignCleanBam.bam \
OUTPUT=${WORKDIR}/${FILENAME}_04_MarkDuplicates.bam \
METRICS_FILE=${WORKDIR}/${FILENAME}_04_MarkDuplicates.bam_metrics.txt \
MAX_RECORDS_IN_RAM=${MAX_RECORDS} \
OPTICAL_DUPLICATE_PIXEL_DISTANCE=${OPT_DIST} \
CREATE_INDEX=true \
TMP_DIR=${TEMPDIR}
