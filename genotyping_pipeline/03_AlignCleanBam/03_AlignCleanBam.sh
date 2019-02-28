#! /bin/bash

# Step 3: AlignCleanBam
# Adapted from Best Practices for GATK3
# See GATK Tutorial #6483: https://gatkforums.broadinstitute.org/gatk/discussion/6483

# USAGE: ./03_AlignCleanBam.sh [input bam file] 
# Assumes input bam file has suffix "_02_MarkIlluminaAdapters.bam"

PICARD=/utils/programs/picard-2.6.0/picard.jar
BWA=/utils/programs/bwa-0.7.12/bwa
REFERENCE=/utils/canfam31/canfam31
TEMPDIR=/temp
WORKDIR=/work

FILENAME=${1%_02_MarkIlluminaAdapters.bam}
LOG1=${WORKDIR}/${FILENAME}"_03_AlignCleanBam_A_SamToFastq_log.txt"
LOG2=${WORKDIR}/${FILENAME}"_03_AlignCleanBam_B_BwaMem_log.txt"
LOG3=${WORKDIR}/${FILENAME}"_03_AlignCleanBam_C_MergeBam_log.txt"

set -o pipefail

java -Xmx8G -jar -Djava.io.tmpdir=${TEMPDIR} ${PICARD} SamToFastq \
I=${WORKDIR}/${FILENAME}_02_MarkIlluminaAdapters.bam \
FASTQ=/dev/stdout \
CLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true \
TMP_DIR=${TEMPDIR} 2>>${LOG1} | \
${BWA} mem -M -t 4 -p ${REFERENCE} /dev/stdin 2>>${LOG2} | \
java -Xmx8G -jar -Djava.io.tmpdir=${TEMPDIR} ${PICARD} MergeBamAlignment \
ALIGNED_BAM=/dev/stdin \
UNMAPPED_BAM=${WORKDIR}/${FILENAME}_01_FastqToSam.bam \
OUTPUT=${WORKDIR}/${FILENAME}_03_AlignCleanBam.bam \
R=${REFERENCE}.fa CREATE_INDEX=true \
ADD_MATE_CIGAR=true CLIP_ADAPTERS=false CLIP_OVERLAPPING_READS=true \
INCLUDE_SECONDARY_ALIGNMENTS=true MAX_INSERTIONS_OR_DELETIONS=-1 \
PRIMARY_ALIGNMENT_STRATEGY=MostDistant ATTRIBUTES_TO_RETAIN=XS \
TMP_DIR=${TEMPDIR} 2>>${LOG3}
