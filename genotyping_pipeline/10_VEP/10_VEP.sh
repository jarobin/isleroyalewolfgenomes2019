#! /bin/bash

# Step 10: Annotate variants with Variant Effect Predictor from Ensembl

# Usage: ./10_VEP.sh [chromosome]

VEP=/utils/programs/ensembl-tools-release-87/scripts/variant_effect_predictor
BGZIP=/utils/programs/htslib-1.3.1/bgzip
TABIX=/utils/programs/htslib-1.3.1/tabix
WORKDIR=/work

CHR=${1}

INFILE=${WORKDIR}/JointCalls_09_B_VariantAnnotator_${CHR}.vcf.gz
OUTFILE=${WORKDIR}/JointCalls_10_VEP_${CHR}.vcf.gz

perl ${VEPDIR}/variant_effect_predictor.pl \
--dir ${VEPDIR} --cache --vcf --offline --sift b --species canis_familiaris \
--canonical --allow_non_variant --symbol --force_overwrite 
-i ${INFILE} \
-o STDOUT \
--stats_file ${OUTFILE}_stats.html | \
sed 's/ /_/g' | ${BGZIP} > ${OUTFILE}

$TABIX -p vcf ${OUTFILE}
