#!/bin/bash
#SBATCH --job-name=trimmomatic
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=15G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-578]

hostname
date

#################################################################
# Trimmomatic
#################################################################

module load Trimmomatic/0.39
module load parallel/20240322 

# set input/output directory variables
TRIMDIR=../../results/trimmedFastq
mkdir -p $TRIMDIR

# adapters to trim out
ADAPTERS=/isg/shared/apps/Trimmomatic/0.39/adapters/NexteraPE-PE.fa

# accession list
MANIFEST=../../metadata/manifest_pathIDs.txt

# get sample info from manifest
INDIR=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 2)
FQ1=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 3)
FQ2=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 4)
PATHID=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 6)

# run trimmomatic
java -jar $Trimmomatic PE -threads 4 \
        ${INDIR}/${FQ1} \
        ${INDIR}/${FQ2} \
        ${TRIMDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}_trim_1.fastq.gz ${TRIMDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}_trim_orphans_1.fastq.gz \
        ${TRIMDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}_trim_2.fastq.gz ${TRIMDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}_trim_orphans_2.fastq.gz \
        ILLUMINACLIP:"${ADAPTERS}":2:30:10:2:true \
        SLIDINGWINDOW:4:15 MINLEN:45 \
        HEADCROP:3