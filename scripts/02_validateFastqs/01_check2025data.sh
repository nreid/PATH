#!/bin/bash
#SBATCH --job-name=validateFastqs
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=4G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH --array=[1-369]
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

hostname
date

module load bbmap/39.34

# this script runs bbmap to validate fastq file pairings to look for more possible issues like those noted in /metadata/notes.md
# parse .err/.out files to look for failures. 

# input dir
INDIR=../../data/October2025

# pick out a sample ID to run in this array task
    # the sort | uniq ... skips the 6 fastq files that already have known weird issues. 
SAM=$(ls ../../data/October2025/ | sed 's/_L.*//' | sort | uniq -c | sort -g | tail -n +7 | sed 's/.* //' | sed -n ${SLURM_ARRAY_TASK_ID}p)

# get R1 and R2 files. 
FQ1=$(ls ${INDIR}/${SAM}_*R1*)
FQ2=$(ls ${INDIR}/${SAM}_*R2*)

# run bbmap
reformat.sh in=${FQ1} in2=${FQ2} vpair threads=8

# check the logs with:
# grep "Names appear" * | sort -V | wc -l
# if the result is 369 (the length of the array) then all the fastqs seem to be properly paired. 