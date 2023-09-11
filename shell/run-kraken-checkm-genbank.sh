#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -D /group/weimergrp/aavalos7/projects/all-lactococcus/snakemake/
#SBATCH -J 10-art-checkm                         # JOB ID
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/kraken-checkm-genbank.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/kraken-checkm-genbank.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 8                                  # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=200Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=07-00:00:00                      # REQUESTED WALL TIME
#SBATCH -p bmh                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh

conda activate snakemake
snakemake -s kraken-checkm-genbank.smk --use-conda --cores 8 --latency-wait 30 -k

# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}