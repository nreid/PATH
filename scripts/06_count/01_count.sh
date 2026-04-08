#!/bin/bash 
#SBATCH --job-name=htseqCount
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=50G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-578]

echo `hostname`
date

#################################################################
# Generate Counts 
#################################################################
module load htseq/2.0.5  
module load parallel/20240322

INDIR=../../results/alignments/
OUTDIR=../../results/counts
mkdir -p $OUTDIR

# manifest
MANIFEST=../../metadata/manifest_pathIDs.txt

# get sample ID from manifest
PATHID=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 6)

# gtf formatted annotation file
GTF=../../genome/Homo_sapiens.GRCh38.114.gtf

# run htseq-count on each sample, up to 5 in parallel

htseq-count \
   -r pos \
   -f bam ${INDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}.bam \
   -s reverse \
   ${GTF} \
   > ${OUTDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}.counts