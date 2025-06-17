#!/bin/bash
#SBATCH --job-name=multiqcRaw
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 2
#SBATCH --mem=10G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

#################################################################
# Aggregate reports using MultiQC
#################################################################

module load MultiQC/1.15

INDIR=../../results/sequenceQC/fastqcRaw
OUTDIR=../../results/sequenceQC/multiQCRaw

# run on fastqc output
multiqc -f -o ${OUTDIR} ${INDIR}