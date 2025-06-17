#!/bin/bash
#SBATCH --job-name=align
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=25G
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
# Align reads to genome
#################################################################
module load hisat2/2.2.1
module load samtools/1.19.2

INDIR=../../results/trimmedFastq/
OUTDIR=../../results/alignments/
mkdir -p ${OUTDIR}


INDEX=../../genome/hisat2Index/GRCh38

ACCLIST=../../metadata/accessionlist.txt

SAMPLE=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${ACCLIST})

# run hisat2
hisat2 \
	-p 4 \
	-x ${INDEX} \
	-1 ${INDIR}/PATH_${SAMPLE}_trim_1.fastq.gz \
	-2 ${INDIR}/PATH_${SAMPLE}_trim_2.fastq.gz | \
samtools sort -@ 1 -T ${OUTDIR}/PATH_${SAMPLE} - >${OUTDIR}/PATH_${SAMPLE}.bam

# index bam files
samtools index ${OUTDIR}/PATH_${SAMPLE}.bam