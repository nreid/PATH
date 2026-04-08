#!/bin/bash
#SBATCH --job-name=filterReformat
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --mem=30G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load software
module load bcftools/1.19

# parallel-called variants

# in/out dirs
INDIR=../../results/variants/parallel
OUTDIR=../../results/variants/parallel
    mkdir -p ${OUTDIR}

VCFIN=../../results/variants/parallel/parallel.vcf.gz
OUTFILE=../../results/variants/parallel/parallel.txt.gz

# filter/reformat
bcftools filter --exclude 'QUAL < 100' ${VCFIN} |
    bcftools query --print-header -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\t[%GT\t]\t[%AD\t]' - |
    gzip >${OUTFILE}


# non parallel-called variants

# in/out dirs
INDIR=../../results/variants/
OUTDIR=../../results/variants/
    mkdir -p ${OUTDIR}

VCFIN=../../results/variants/freebayes.vcf.gz
OUTFILE=../../results/variants/freebayes.txt.gz

# filter/reformat
bcftools filter --exclude 'QUAL < 100' ${VCFIN} |
    bcftools query --print-header -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\t[%GT\t]\t[%AD\t]' - |
    gzip >${OUTFILE}
