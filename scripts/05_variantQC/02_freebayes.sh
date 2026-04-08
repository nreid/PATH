#!/bin/bash
#SBATCH --job-name=freebayes
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
module load freebayes/1.3.4
module load htslib/1.21-gcc-11.4.0-m4swynp

# indir/outdir
INDIR=../../results/alignments
OUTDIR=../../results/variants/
    mkdir -p ${OUTDIR}

# targets file
TARGETS=${OUTDIR}/targets.bed

# genome file
GENOME=../../genome/Homo_sapiens.GRCh38.dna_sm.toplevel.fa

# make a bam list
ls ${INDIR}/*bam >${OUTDIR}/bam.list

# run freebayes
freebayes -f ${GENOME} --bam-list ${OUTDIR}/bam.list -t ${TARGETS} | bgzip >${OUTDIR}/freebayes.vcf.gz

# index
tabix -p vcf ${OUTDIR}/freebayes.vcf.gz