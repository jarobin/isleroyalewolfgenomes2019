# Genotyping pipeline for short read Illumina data generated from whole genome sequencing

Scripts for processing raw reads to generate a set of high quality genotypes, as in "Genomic signatures of extensive inbreeding in Isle Royale wolves, a population on the threshold of extinction" by Robinson et al. (2019). Pipeline adapted from the Best Practices for GATK3.

Required software:
- [Picard](https://broadinstitute.github.io/picard/)
- [BWA](http://bio-bwa.sourceforge.net/)
- [GATK3](https://software.broadinstitute.org/gatk/)
- [HTSlib and Samtools](http://www.htslib.org/)
- [VEP](https://uswest.ensembl.org/info/docs/tools/vep/index.html)

Other requirements:
- Java 1.8
- Perl
- Python2
- Reference genome assembly in fasta format and associated index files (see https://gatkforums.broadinstitute.org/gatk/discussion/2798/howto-prepare-a-reference-for-use-with-bwa-and-gatk)  


## Pipeline

### 1. FastqToSam  
Convert raw read data to an unmapped BAM file.  

### 2. MarkIlluminaAdapters  
Mark Illumina adapter sequences in the unmapped BAM file.  

### 3. AlignCleanBam  
Efficiently align reads to a reference genome.  

### 4. MarkDuplicates  
Mark (and optionally remove) duplicate reads.  

### 5. RemoveBadReads (optional)  
Remove reads with low mapping quality or that don't align in proper pair (as indicated by flags). Optional step, reduces the size of the BAM file by eliminating reads that are not desired in downstream processing.  

### 6. BaseQualityScoreRecalibration  
Recalibrate base quality scores to reach convergence between reported and empirical base quality scores.  

### 7. HaplotypeCaller  
Generate a gVCF file for each BAM file.  

### 8. GenotypeGVCFs  
Generate a VCF file from gVCF files.  

### 9. TrimAlternates and VariantAnnotator  
Remove alleles from the VCF file that don't appear in any genotypes, and add desired annotations to the INFO field.  

### 10. Variant Effect Predictor  
Add mutation impact to the INFO field.  

### 11. VariantFiltration and custom filtering  
Apply site- and genotype-level filters.  
