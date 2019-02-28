#! /bin/bash

# Step 8: GenotypeGVCFs
# Adapted from Best Practices for GATK3
# Generates a multi-sample joint VCF file with genotypes at ALL sites

# Usage: ./08_GenotypeGVCFs.sh [chromosome]

GATK=/utils/programs/GenomeAnalysisTK-3.6-0-g89b7209/GenomeAnalysisTK.jar
REFERENCE=/utils/canfam31/canfam31.fa
TEMPDIR=/temp
WORKDIR=/work

CHR=${1}

java -jar -Xmx26g -Djava.io.tmpdir=${TEMPDIR} ${GATK} \
-T GenotypeGVCFs \
-R ${REFERENCE} \
-allSites \
-stand_call_conf 0 \
-L ${CHR} \
$(for f in ${WORKDIR}/*_07_HaplotypeCaller_${CHR}.g.vcf.gz; do echo "-V ${f} "; done) \
-o ${WORKDIR}/JointCalls_08_GenotypeGVCFs_${CHR}.vcf.gz 
