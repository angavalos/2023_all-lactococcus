#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -D /group/weimergrp/aavalos7/projects/all-lactococcus/
#SBATCH -J links                         # JOB ID
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/links.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/links.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 1                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=50Mb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=00-5:00:00                      # REQUESTED WALL TIME
#SBATCH -p med                                # PARTITION TO SUBMIT TO


SRA=$(cat ../20230915_final-sra-genomes-checkm-names-nor.txt)
SRAPRE=/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles/
GEN=$(cat ../20230915_final-genbank-genomes-checkm-names-nor.txt)
GENPRE=/group/weimergrp2/genomes/lactococcus/genbank-genomes-analysis/sampleFiles/
OUTDIR=/group/weimergrp2/genomes/lactococcus/20230915_final-lacto-genomes/analysis/sampleFiles/

for line in $SRA
do ln -s $SRAPRE$line $OUTDIR
done

for line in $GEN
do ln -s $GENPRE$line $OUTDIR
done
# Print out final statistics about resource use before job exits
#scontrol show job ${SLURM_JOB_ID}

#sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}