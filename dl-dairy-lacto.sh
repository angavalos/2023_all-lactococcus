#! /bin/bash
#
#SBATCH -c 1                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=1Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=00-00:30:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

# To copy Weimer collection of non-maize Lactococcus from Box.
rclone copy -P box:Lactococcus_Shawn/*.fastq.gz /group/weimergrp2/genomes/lactococcus/raw-reads2/

# This was done to remove the "R" in certain filenames.
cd /group/weimergrp2/genomes/lactococcus/raw-reads2/
for file in *; do mv "${file}" "${file/R/}"; done