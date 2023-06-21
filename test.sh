#! /bin/bash
#
#SBATCH -c 1                                    # NUMBER OF PROCESSORS PER TASK
#SBATCH --mem=1Gb                               # MEMORY POOL TO ALL CORES
#SBATCH --time=00-00:05:00                      # REQUESTED WALL TIME
#SBATCH -p high                                # PARTITION TO SUBMIT TO

echo Hello World
sleep 15
date