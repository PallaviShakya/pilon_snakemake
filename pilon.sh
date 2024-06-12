#! /bin/bash -l
#SBATCH -J UL_hifi_hic_pilon
#SBATCH -e out.erri
#SBATCH -o Test-Job-%j.output
#SBATCH --mail-type=ALL
#SBATCH --mail-user=pshakya@ucdavis.edu
#SBATCH --partition=bigmemht
#SBATCH --time=1-12:00:00
#SBATCH --cpus-per-task=40
#SBATCH --mem=300GB

#Make things fail on errors

set -o errexit
set -x

# set variables
#ref="rawreads/UL_hifi_Hic.p_ctg.fa"
reads1="rawreads/illumina/VW9_S2_L004_R1_001.fastq.gz"
reads2="rawreads/illumina/VW9_S2_L004_R2_001.fastq.gz"
THREADS=65

conda activate genome_polish

snakemake --unlock && snakemake --cores all