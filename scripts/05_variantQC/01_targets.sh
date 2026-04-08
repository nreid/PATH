#!/bin/bash
#SBATCH --job-name=targets
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
module load samtools/1.21-gcc-11.4.0-mcohq7c
module load bedtools/2.31.1

# indir/outdir
INDIR=../../results/alignments
OUTDIR=../../results/variants/
    mkdir -p ${OUTDIR}

# get 3 million sites with decent but not extreme coverage
    # merge them into target intervals
samtools merge -b <(ls ${INDIR}/*bam | head -n 20) - | 
samtools depth /dev/stdin | 
awk '{print $0"\t"$3/20}' | 
awk '$4 > 30 && $4 < 100' | 
head -n 3000000 | 
awk '{start=$2-1}{print $1"\t"start"\t"$2}' |
bedtools merge -i stdin -d 5 >${OUTDIR}/targets.bed