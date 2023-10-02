#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -D /group/weimergrp2/genomes/lactococcus/20230929_llactis-snippy/analysis/cremoris
#SBATCH -J ERR440995-snippy                         # JOB ID
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/ERR440995-snippy.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/ERR440995-snippy.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 16                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=32Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=00-01:00:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh

conda activate snippy

# This is just a test on the one assembly.
snippy --outdir 'ERR440995'  --force --R1 '/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles/ERR440995/trimedReads/ERR440995_R1_trim_px.fixed.fastq' --R2 '/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles/ERR440995/trimedReads/ERR440995_R2_trim_px.fixed.fastq' --ref /group/weimergrp2/genomes/lactococcus/20230929_llactis-snippy/20230928_genbank-references/GCF_000468955.1_ASM46895v1_genomic.fna_genbank.gb --cpus 16 --cleanup --ram 32