#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -J llactis-cremoris-scoary                        # JOB ID
#SBATCH -D /group/weimergrp2/genomes/lactococcus/20230915_final-lacto-genomes/analysis/population/
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/llactis-cremoris-scoary.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/llactis-cremoris-scaory.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 8                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=16Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=00-01:00:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh
conda activate scoary

TRAITS=20230922_llactis-cremoris-traits-for-scoary.csv
PREABS=roary_final-lacto-genomes-llactis_1695142188/gene_presence_absence.csv
OUTPU=20230922_llactis-cremoris-scoary/

# Run Scoary on IGR Pan-Genome from Piggy
scoary \
    -t $TRAITS \
	-g $PREABS \
    -o $OUTPU \
    -p 5E-6 \
    -c BH \
    --upgma_tree \
    --threads 8 \
    --delimiter ,

# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}