#!/bin/bash
#SBATCH --job-name=namecheck
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem=15G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# indir/outdir

INDIR=../../data/June2023

OUTDIR=../../metadata/

# extract sample name from fastq file names, get barcode sequences from header
for file in ${INDIR}/PATH*R1*fastq.gz
    do 
    paste <(echo ${file}) <(zcat ${file} | head -n 1) |
        sed 's/.*PATH_/PATH/ ; s/_.*fastq.gz//'|
        sed 's/@.*:// ; s/+/\t/'
    done \
    >${OUTDIR}/samplefilenameVSheaderbarcodes.txt

# extract the same data from the illumina metadata csv
# cut -d "," -f 2,8,10 ../../metadata/Starkweather_PATH_Delany_13June2023.csv | grep PATH | sed 's/_// ; s/,/\t/g' | sort | uniq
