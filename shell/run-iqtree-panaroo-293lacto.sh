#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -D /group/weimergrp2/genomes/lactococcus/analysis/population/iqtree-panaroo-sensitive-293lacto
#SBATCH -J iqtree-panaroo-293lacto                         # JOB ID
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/iqtree-panaroo-293lacto.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/iqtree-panaroo-293lacto.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 8                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=8Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=00-24:00:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh

INFILE=/group/weimergrp2/genomes/lactococcus/analysis/population/panaroo-sensitive-293lacto/core_gene_alignment_filtered.aln

conda activate iqtree
iqtree -s $INFILE -pre core_tree -nt 8 -fast -m GTR

# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}