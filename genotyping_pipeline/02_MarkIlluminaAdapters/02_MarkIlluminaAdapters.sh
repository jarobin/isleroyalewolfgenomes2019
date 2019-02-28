#! /bin/bash

# Step 2: MarkIlluminaAdapters
# Adapted from Best Practices for GATK3
# See GATK Tutorial #6483: https://gatkforums.broadinstitute.org/gatk/discussion/6483

# USAGE: ./02_MarkIlluminaAdapters.sh [input bam filename]
# Assumes input bam file has suffix "_01_FastqToSam.bam"

PICARD=/utils/programs/picard-2.6.0/picard.jar
TEMPDIR=/temp
WORKDIR=/work

FILENAME=${1%_01_FastqToSam.bam}

java -Xmx26G -jar -Djava.io.tmpdir=${TEMPDIR} ${PICARD} MarkIlluminaAdapters \
I=${WORKDIR}/${FILENAME}_01_FastqToSam.bam \
O=${WORKDIR}/${FILENAME}_02_MarkIlluminaAdapters.bam \
M=${WORKDIR}/${FILENAME}_02_MarkIlluminaAdapters.bam_metrics.txt \
TMP_DIR=${TEMPDIR}
