#! /bin/bash

# Step 6: BaseQualityScoreRecalibration (BQSR)
# Procedure for base quality score recalibration when there is no database of
# "known" variants. Repeat with multiple rounds as necessary to reach convergence
# between reported and empirical quality scores (in plots produced by AnalyzeCovariates).
# See detailed explanation at:
# https://gatkforums.broadinstitute.org/gatk/discussion/44/base-quality-score-recalibrator

# Usage: ./06_BQSR.sh [input bam file] [round of BQSR]
# Assumes input bam file has suffix "_05_RemoveBadReads.bam"

GATK=/utils/programs/GenomeAnalysisTK-3.6-0-g89b7209/GenomeAnalysisTK.jar
REFERENCE=/utils/canfam31/canfam31.fa
TEMPDIR=/temp
WORKDIR=/work

FILENAME=${1%_05_RemoveBadReads.bam}
ROUND=${2}


### A. Create variant database by genotyping with raw bam file

LOG=${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_A_UG.vcf.gz.log

date > ${LOG}

java -jar -Xmx42g -Djava.io.tmpdir=${TEMPDIR} ${GATK} \
-T UnifiedGenotyper \
-nt 6 \
-R ${REFERENCE} \
-glm BOTH \
--min_base_quality_score 20 \
-I ${WORKDIR}/${FILENAME}_05_RemoveBadReads.bam \
-o ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_A_UG.vcf.gz \
-metrics ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_A_UG.vcf.gz.metrics &>> ${LOG}

date >> ${LOG}


### B. Create recalibration table

LOG=${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_B_recal.table.log

date > ${LOG}

java -jar -Xmx42g -Djava.io.tmpdir=${TEMPDIR} ${GATK} \
-T BaseRecalibrator \
-nct 6 \
-R ${REFERENCE} \
-I ${WORKDIR}/${FILENAME}_05_RemoveBadReads.bam \
-o ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_B_recal.table \
-knownSites ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_A_UG.vcf.gz &>> ${LOG}

date >> ${LOG}


### C. Create post-recalibration table

LOG=${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_C_postrecal.table.log

date > ${LOG}

java -jar -Xmx42g -Djava.io.tmpdir=${TEMPDIR} ${GATK} \
-T BaseRecalibrator \
-nct 6 \
-R ${REFERENCE} \
-I ${WORKDIR}/${FILENAME}_05_RemoveBadReads.bam \
-o ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_C_postrecal.table \
-knownSites ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_A_UG.vcf.gz
-BQSR ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_B_recal.table &>> ${LOG}

date >> ${LOG}


### D. Make plots to compare before/after recalibration

LOG=${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_D_recalplots.log

date > ${LOG}

java -jar ${GATK} \
-T AnalyzeCovariates \
-R ${REFERENCE} \
-before ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_B_recal.table \
-after ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_C_postrecal.table \
-plots ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_D_recalplots.pdf &>> ${LOG4}

date >> ${LOG}


### E. Recalibrate bam file

LOG=${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_E_recal.bam.log

date > ${LOG}

java -jar -Xmx42g -Djava.io.tmpdir=${TEMPDIR} ${GATK} \
-T PrintReads \
-nct 6 \
-R ${REFERENCE} \
-I ${WORKDIR}/${FILENAME}_05_RemoveBadReads.bam \
-o ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_E_recal.bam \
-BQSR ${WORKDIR}/${FILENAME}_06_BQSR${ROUND}_B_recal.table &>> ${LOG}

date >> ${LOG}




