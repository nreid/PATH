#!/bin/bash
#SBATCH --job-name=align
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=25G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uc`onn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-578]

hostname
date

#################################################################
# Align reads to genome
#################################################################
module load hisat2/2.2.1
module load samtools/1.19.2

INDIR=../../results/trimmedFastq/
OUTDIR=../../results/alignments/
mkdir -p ${OUTDIR}

INDEX=../../genome/hisat2Index/GRCh38

# manifest
MANIFEST=../../metadata/manifest_pathIDs.txt

# get sample ID from manifest
PATHID=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 6)

# run hisat2
hisat2 \
	--rg-id ${PATHID}-CBC${SLURM_ARRAY_TASK_ID} \
	--rg SM:${PATHID}-CBC${SLURM_ARRAY_TASK_ID} \
	-p 4 \
	-x ${INDEX} \
	-1 ${INDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}_trim_1.fastq.gz \
	-2 ${INDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}_trim_2.fastq.gz | \
samtools sort -@ 1 -T ${OUTDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID} - >${OUTDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}.bam

# index bam files
samtools index ${OUTDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}.bam