#! /bin/bash

# Step 11: Apply mask and hard filters to VCF file
# Total depth filter in step A is the 99th percentile of total DP (pre-determined)

# Usage: ./11_FilterVCFfile.sh [chromosome]

GATK=/utils/programs/GenomeAnalysisTK-3.7-0-gcfedb67/GenomeAnalysisTK.jar
BGZIP=/utils/programs/htslib-1.3.1/bgzip
TABIX=/utils/programs/htslib-1.3.1/tabix
WORKDIR=/work

CHR=${1}


### A. Apply mask and hard filters with VariantFiltration

MASK=/utils/beds/CpG_and_repeat_filter_cf31.bed

INFILE=${WORKDIR}/JointCalls_10_VEP_${CHR}.vcf.gz
OUTFILE=${WORKDIR}/JointCalls_11_Filter_A_${CHR}.vcf.gz

java -jar ${GATK} \
-T VariantFiltration \
-R ${REFERENCE} \
--logging_level ERROR \
--mask ${MASK} --maskName "FAIL_CpGRep" \
-filter "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || SOR > 3.0" \
--filterName "FAIL_6f" \
-filter "QUAL < 30.0" --filterName "FAIL_qual" \
-filter "DP > 1373" --filterName "FAIL_DP" \
-L ${CHR} \
-V ${INFILE} \
-o ${OUTFILE}


### B. Apply custom site- and genotype-level filters

FILTER_SCRIPT=/utils/scripts/customVCFfilter.py

INFILE2=${WORKDIR}/JointCalls_11_Filter_A_${CHR}.vcf.gz
OUTFILE2=${WORKDIR}/JointCalls_11_Filter_B_${CHR}.vcf.gz

set -o pipefail

python ${FILTER_SCRIPT} ${INFILE2} | ${BGZIP} > ${OUTFILE2}

${TABIX} -p vcf ${OUTFILE2}
