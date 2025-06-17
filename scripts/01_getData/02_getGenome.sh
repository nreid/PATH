#!/bin/bash
#SBATCH --job-name=getGenome
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=2G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load software
module load samtools/1.19.2

# output directory
GENOMEDIR=../../genome
mkdir -p $GENOMEDIR

# download the genome and annotation from ensembl
    # GRCh38

wget -P ${GENOMEDIR} https://ftp.ensembl.org/pub/release-114/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.toplevel.fa.gz

# decompress the genome
gunzip ${GENOMEDIR}/Homo_sapiens.GRCh38.dna_sm.toplevel.fa.gz

# download the GTF annotation file
wget -P ${GENOMEDIR} https://ftp.ensembl.org/pub/release-114/gtf/homo_sapiens/Homo_sapiens.GRCh38.114.gtf.gz

# create faidx index for genome
samtools faidx ${GENOMEDIR}/Homo_sapiens.GRCh38.dna_sm.toplevel.fa