#! /bin/bash
#
#SBATCH --mail-user=angavalos@ucdavis.edu         # YOUR EMAIL ADDRESS
#SBATCH --mail-type=ALL                         # NOTIFICATIONS OF SLURM JOB STATUS - ALL, NONE, BEGIN, END, FAIL, REQUEUE
#SBATCH -D /group/weimergrp2/genomes/lactococcus/LLACTIS-LACTIS-SNIPPY-TEST2/
#SBATCH -J llactis-lactis-snippy-test                         # JOB ID
#SBATCH -e /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/llactis-lactis-snippy-test2.j%j.err                   # STANDARD ERROR FILE TO WRITE TO
#SBATCH -o /group/weimergrp/aavalos7/projects/all-lactococcus/err-out-files/llactis-lactis-snippy-test2.j%j.out                   # STANDARD OUTPUT FILE TO WRITE TO
#SBATCH -c 8                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=8Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=01-00:00:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

# initialize conda
. ~/miniconda3/etc/profile.d/conda.sh

conda activate snippy

snippy --outdir 'BCW_200241' --R1 '/group/weimergrp2/genomes/lactococcus/raw-reads2/BCW_200241_1.fastq.gz' --R2 '/group/weimergrp2/genomes/lactococcus/raw-reads2/BCW_200241_2.fastq.gz' --ref /group/weimergrp2/genomes/lactococcus//genbank-genomes-analysis/sampleFiles/GCF_000025045.1_ASM2504v1_genomic.fna/prokka/GCF_000025045.1_ASM2504v1_genomic.fna.gbk --cpus 8
snippy --outdir 'GCF_002895225.1_ASM289522v1' --ctgs '/group/weimergrp2/genomes/lactococcus/genomes-unzipped/GCF_002895225.1_ASM289522v1_genomic.fna' --ref /group/weimergrp2/genomes/lactococcus//genbank-genomes-analysis/sampleFiles/GCF_000025045.1_ASM2504v1_genomic.fna/prokka/GCF_000025045.1_ASM2504v1_genomic.fna.gbk --cpus 8
snippy-core --ref 'BCW_200241/ref.fa' BCW_200241 GCF_002895225.1_ASM289522v1
