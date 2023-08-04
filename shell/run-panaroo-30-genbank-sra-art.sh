#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -D /group/weimergrp/aavalos7/projects/all-lactococcus/shell
#SBATCH -J panaroo-30-genbank-sra-art                         # JOB ID
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/panaroo-30-genbank-sra-art.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/panaroo-30-genbank-sra-art.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 10                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=4Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=00-24:00:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh

INFILE=/group/weimergrp/aavalos7/projects/all-lactococcus/20230804_genbank-sra-art-labels-for-panaroo.txt
OUTDIR=/group/weimergrp2/genomes/lactococcus/20230803_compare-genbank-sra-art/population/panaroo-sensitive-30-genbank-sra-art

conda activate panaroo
panaroo -i $INFILE -o $OUTDIR --clean-mode sensitive --core_threshold 0.99 -t 10

# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}