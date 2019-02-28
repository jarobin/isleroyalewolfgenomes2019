# Genotyping pipeline for short read Illumina data from whole genome sequencing

Scripts for processing raw reads to generate a set of high quality genotypes, as in "Genomic signatures of extensive inbreeding in Isle Royale wolves, a population on the threshold of extinction" by Robinson et al. (2019).

Required software:
[Picard](https://broadinstitute.github.io/picard/)
[BWA](http://bio-bwa.sourceforge.net/)
[GATK3](https://software.broadinstitute.org/gatk/)
[HTSlib and Samtools](http://www.htslib.org/)
[VEP](https://uswest.ensembl.org/info/docs/tools/vep/index.html)

Other requirements:
- Java 1.8
- Reference genome assembly (fasta format) and associated index files (see https://gatkforums.broadinstitute.org/gatk/discussion/2798/howto-prepare-a-reference-for-use-with-bwa-and-gatk)
