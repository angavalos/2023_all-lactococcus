#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -D /group/weimergrp/aavalos7/projects/all-lactococcus/python/
#SBATCH -J biosample                         # JOB ID
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/biosample.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/biosample.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 1                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=50Mb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=00-5:00:00                      # REQUESTED WALL TIME
#SBATCH -p med                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh

conda activate biopython
ORIGINAL=$(cat ../genbank-biosample-ids.txt)
INPUT=../genbank-biosample-ids-iterate.txt
#OUTPUT=/group/weimergrp2/genomes/lactococcus/analysis/batchReports/sra-biosample-meta2.csv
OUTPUT=/group/weimergrp2/genomes/lactococcus/genbank-genomes-analysis/batchReports/genbank-biosample-meta2.csv

for line in $ORIGINAL
do echo "$line">>$INPUT
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo did one
done

# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}