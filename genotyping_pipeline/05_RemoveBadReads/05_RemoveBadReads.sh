#! /bin/bash

# Step 5: RemoveBadReads
# Optional step, not part of Best Practices for GATK3 

# USAGE: ./05_RemoveBadReads.sh [input bam file]
# Assumes input bam file has suffix "_04_MarkDuplicates.bam"

SAMTOOLS=/utils/programs/samtools-1.3.1/samtools
PICARD=/utils/programs/picard-2.6.0/picard.jar
TEMPDIR=/temp
WORKDIR=/work

FILENAME=${1%_04_MarkDuplicates.bam}

set -o pipefail

${SAMTOOLS} view -hb -f 2 -F 256 -q 30 ${WORKDIR}/${FILENAME}_04_MarkDuplicates.bam | \
${SAMTOOLS} view -hb -F 1024 > ${WORKDIR}/${FILENAME}_05_RemoveBadReads.bam

java -jar -Xmx16g -Djava.io.tmpdir=${TEMPDIR} ${PICARD} BuildBamIndex \
I=${WORKDIR}/${FILENAME}_05_RemoveBadReads.bam \
VALIDATION_STRINGENCY=LENIENT \
TMP_DIR=${TEMPDIR}
