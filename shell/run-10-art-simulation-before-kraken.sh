#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -D /group/weimergrp/aavalos7/projects/all-lactococcus/snakemake/
#SBATCH -J 10-art-simulation-before-kraken                         # JOB ID
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/10-art-simulation-before-kraken.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/10-art-simulation-before-kraken.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 4                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=4Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=03-00:00:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh

conda activate snakemake
snakemake -s 10-art-simulation-before-kraken.smk --use-conda --cores 4 --latency-wait 30 -k

# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}