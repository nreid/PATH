#!/bin/bash
#SBATCH --job-name=symlinkData
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

module load parallel/20240322

# this script symlinks data into the work directory

INDIR=/seqdata/CGI/Fastq_Files/Starkweather_PATH_June2023
DATADIR=../../data
mkdir -p ${DATADIR}

find ${INDIR} -name "*fastq.gz" | 
    grep -v "FAIL" |
    parallel "ln -s {} ${DATADIR}/"

