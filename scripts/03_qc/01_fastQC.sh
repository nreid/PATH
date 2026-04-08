#!/bin/bash
#SBATCH --job-name=fastqcRaw
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --mem=4G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --array=[1-578]
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

##########################
# run fastqc 
##########################

# load software
module load fastqc/0.12.1 

#input/output directories, supplementary files

OUTDIR=../../results/sequenceQC/fastqcRaw
mkdir -p ${OUTDIR}

MANIFEST=../../metadata/manifest_pathIDs.txt

# get sample info from manifest
INDIR=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 2)
FQ1=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 3)
FQ2=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 4)

# run fastqc
fastqc -t 2 -o ${OUTDIR} ${INDIR}/${FQ1} ${INDIR}/${FQ2}