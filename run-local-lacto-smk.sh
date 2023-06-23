#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -J local-lacto-qc-trim                         # JOB ID
#SBATCH -e local-lacto-qc-trim.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o local-lacto-qc-trim.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 1                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=4Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=02-00:00:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh

conda activate snakemake
snakemake -s local-lactococcus.smk --use-conda --cores 1 --latency-wait 30 -k

# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}