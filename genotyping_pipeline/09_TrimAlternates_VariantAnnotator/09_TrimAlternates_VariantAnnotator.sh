#! /bin/bash

# Step 9: Trim unused alternate alleles and add VariantType and AlleleBalance annotations
# to INFO column

# Usage: ./09_TrimAlternates_VariantAnnotator.sh [chromosome]

GATK=/utils/programs/GenomeAnalysisTK-3.6-0-g89b7209/GenomeAnalysisTK.jar
REFERENCE=/utils/canfam31/canfam31.fa
TEMPDIR=/temp
WORKDIR=/work

CHR=${1}

LOG=${WORKDIR}/JointCalls_09_A_TrimAlternates_${CHR}.vcf.gz_log.txt

date > ${LOG}

java -jar -Xmx26g -Djava.io.tmpdir=${TEMPDIR} ${GATK} \
-T SelectVariants \
-R ${REFERENCE} \
-trimAlternates \
-L ${CHR} \
-V ${WORKDIR}/JointCalls_08_GenotypeGVCFs_${CHR}.vcf.gz \
-o ${WORKDIR}/JointCalls_09_A_TrimAlternates_${CHR}.vcf.gz &>> ${LOG}

date >> ${LOG}


LOG=${WORKDIR}/JointCalls_09_B_VariantAnnotator_${CHR}.vcf.gz_log.txt

date > ${LOG}

java -jar -Xmx26g -Djava.io.tmpdir=${TEMPDIR} ${GATK} \
-T VariantAnnotator \
-R ${REFERENCE} \
-G StandardAnnotation \
-A VariantType \
-A AlleleBalance \
-L ${CHR} \
-V ${WORKDIR}/JointCalls_09_A_TrimAlternates_${CHR}.vcf.gz \
-o ${WORKDIR}/JointCalls_09_B_VariantAnnotator_${CHR}.vcf.gz &>> ${LOG}

date >> ${LOG}
