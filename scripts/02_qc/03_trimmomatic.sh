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
#SBATCH --array=[1-110]

hostname
date

#################################################################
# Trimmomatic
#################################################################

module load Trimmomatic/0.39
module load parallel/20240322 

# set input/output directory variables
INDIR=../../data/
TRIMDIR=../../results/trimmedFastq
mkdir -p $TRIMDIR

# adapters to trim out
ADAPTERS=/isg/shared/apps/Trimmomatic/0.39/adapters/TruSeq3-PE-2.fa

# accession list
ACCLIST=../../metadata/accessionlist.txt

# run trimmomatic

SAMPLE=$( sed -n ${SLURM_ARRAY_TASK_ID}p ${ACCLIST} )
FQ1=$(ls ../../data | grep "PATH_${SAMPLE}.*R1")
FQ2=$(ls ../../data | grep "PATH_${SAMPLE}.*R2")

java -jar $Trimmomatic PE -threads 4 \
        ${INDIR}/${FQ1} \
        ${INDIR}/${FQ2} \
        ${TRIMDIR}/PATH_${SAMPLE}_trim_1.fastq.gz ${TRIMDIR}/PATH_${SAMPLE}_trim_orphans_1.fastq.gz \
        ${TRIMDIR}/PATH_${SAMPLE}_trim_2.fastq.gz ${TRIMDIR}/PATH_${SAMPLE}_trim_orphans_2.fastq.gz \
        ILLUMINACLIP:"${ADAPTERS}":2:30:10 \
        SLIDINGWINDOW:4:15 MINLEN:45 \
        HEADCROP:3