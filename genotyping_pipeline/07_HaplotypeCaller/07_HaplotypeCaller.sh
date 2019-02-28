#! /bin/bash

# Step 7: HaplotypeCaller
# Adapted from Best Practices for GATK3
# Generates a single-sample gVCF file with genotypes at ALL sites

# Usage: ./07_HaplotypeCaller.sh [input bam file] [chromosome]
# Assumes input bam file has suffix "_06_BQSR1_E_recal.bam"

GATK=/utils/programs/GenomeAnalysisTK-3.6-0-g89b7209/GenomeAnalysisTK.jar
REFERENCE=/utils/canfam31/canfam31.fa
TEMPDIR=/temp
WORKDIR=/work

FILENAME=${1%_06_BQSR1_E_recal.bam}
CHR=${2}

java -jar -Xmx16g -Djava.io.tmpdir=${TEMPDIR} ${GATK} \
-T HaplotypeCaller \
-R ${REFERENCE} \
-ERC BP_RESOLUTION \
-mbq 20 \
-out_mode EMIT_ALL_SITES \
--dontUseSoftClippedBases \
-L ${CHR} \
-I ${WORKDIR}/${FILENAME}_06_BQSR1_E_recal.bam \
-o ${WORKDIR}/${FILENAME}_07_HaplotypeCaller_${CHR}.g.vcf.gz
