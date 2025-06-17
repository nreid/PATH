#!/bin/bash
#SBATCH --job-name=fastQCtrim
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --mem=4G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --array=[1-110]
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

##########################
# run fastqc 
##########################

# load software
module load fastqc/0.12.1 

#input/output directories, supplementary files
INDIR=../../results/trimmedFastq/

OUTDIR=../../results/sequenceQC/fastqcTrim
mkdir -p ${OUTDIR}

ACCLIST=../../metadata/accessionlist.txt

# get sample ID

PATHID=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${ACCLIST})

# run fastqc
fastqc -t 2 -o ${OUTDIR} ${INDIR}/PATH_${PATHID}*