#!/bin/bash
#SBATCH --job-name=featureCounts
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

module load subread/2.1.1

INDIR=../../results/alignments

OUTDIR=../../results/featureCounts
    mkdir -p ${OUTDIR}

GTF=../../genome/Homo_sapiens.GRCh38.114.gtf

featureCounts \
    -a ${GTF} \
    -o ${OUTDIR}/counts.txt \
    -s 2 \
    -p \
    -B \
    --countReadPairs \
    -T 16 \
    ${INDIR}/*bam