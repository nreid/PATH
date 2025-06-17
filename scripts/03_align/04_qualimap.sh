#!/bin/bash 
#SBATCH --job-name=qualimap
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=10G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-110]

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

# accession list
ACCLIST=../../metadata/accessionlist.txt
SAMPLE=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${ACCLIST})

# temporary directory
export TMPDIR=tmpfiles
mkdir -p ${TMPDIR}

export JAVA_TOOL_OPTIONS="-Djava.io.tmpdir=${TMPDIR}"

# run qualimap in parallel
qualimap \
    rnaseq \
    --paired \
    -p strand-specific-reverse \
    -bam ${INDIR}/PATH_${SAMPLE}.bam \
    -gtf ${GTF} \
    -outdir ${OUTDIR}/PATH_${SAMPLE} \
    --java-mem-size=10G  