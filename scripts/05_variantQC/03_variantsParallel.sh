#!/bin/bash
#SBATCH --job-name=freebayesParallel
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 100
#SBATCH --mem=480G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

#Load software
module load freebayes/1.3.4
module load htslib/1.21-gcc-11.4.0-m4swynp
module load bcftools/1.19
module load parallel/20240322
module load vcflib/1.0.13 
module load bedtools/2.29.0

#Specify input/output directories
INDIR=../../results/alignments
OUTDIR=../../results/variants/parallel
	mkdir -p ${OUTDIR}

#Make a list of bam files
ls ${INDIR}/*.bam >${INDIR}/bam_list.txt

#Set reference genome location
GENOME=../../genome/Homo_sapiens.GRCh38.dna_sm.toplevel.fa

#regions file
TARGETS=../../results/variants/targets.bed

#Call variants in parallel
(cat "$TARGETS" | sed 's/\t/:/ ; s/\t/-/' | parallel -k -j 100 \
"freebayes -f ${GENOME} --bam-list ../../results/variants/bam.list -r {} --skip-coverage 35000"
) | 
vcffirstheader |
vcfstreamsort -w 1000 |
vcfuniq |
bgzip >${OUTDIR}/parallel.vcf.gz

#Index vcf
tabix -p vcf ${OUTDIR}/parallel.vcf.gz