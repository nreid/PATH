#!/bin/bash 
#SBATCH --job-name=qualimap
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=20G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-578]%50

hostname
date

##################################
# calculate stats on alignments
##################################
# this time we'll use qualimap

# load software--------------------------------------------------------------------------
module load qualimap/2.3
module load parallel/20240322

# input, output directories--------------------------------------------------------------

INDIR=../../results/alignments
OUTDIR=../../results/alignQC/qualimapReports
mkdir -p $OUTDIR

# gtf annotation is required here
GTF=../../genome/Homo_sapiens.GRCh38.114.gtf

# manifest
MANIFEST=../../metadata/manifest_pathIDs.txt

# get sample ID from manifest
PATHID=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${MANIFEST} | cut -f 6)

# temporary directory
export TMPDIR=tmpfiles
mkdir -p ${TMPDIR}

# set a temporary directory, tell it not to try to plot using X11
export JAVA_TOOL_OPTIONS="-Djava.io.tmpdir=${TMPDIR} -Djava.awt.headless=true"

# run qualimap in parallel
qualimap \
    rnaseq \
    --paired \
    -p strand-specific-reverse \
    -bam ${INDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID}.bam \
    -gtf ${GTF} \
    -outdir ${OUTDIR}/${PATHID}-CBC${SLURM_ARRAY_TASK_ID} \
    --java-mem-size=18G  