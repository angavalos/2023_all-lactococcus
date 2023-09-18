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
ORIGINAL=../sra-biosample-ids.txt
INPUT=../sra-biosample-ids-iterate.txt
OUTPUT=/group/weimergrp2/genomes/lactococcus/analysis/batchReports/sra-biosample-meta2.csv

sed -n '1,25p' $ORIGINAL >> $INPUT
echo added 1-25
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 1-25
sed -n '26,50p' $ORIGINAL >> $INPUT
echo added 26-50
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 26-50
sed -n '51,75p' $ORIGINAL >> $INPUT
echo added 51-75
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 51-75
sed -n '76,100p' $ORIGINAL >> $INPUT
echo added 76-100
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 76-100
sed -n '101,125p' $ORIGINAL >> $INPUT
echo added 101-125
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 101-125
sed -n '126,150p' $ORIGINAL >> $INPUT
echo added 126-150
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 126-150
sed -n '151,175p' $ORIGINAL >> $INPUT
echo added 151-175
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 151-175
sed -n '176,200p' $ORIGINAL >> $INPUT
echo added 176-200
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 176-200
sed -n '201,225p' $ORIGINAL >> $INPUT
echo added 201-225
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 201-225
sed -n '226,250p' $ORIGINAL >> $INPUT
echo added 226-250
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 226-250
sed -n '251,275p' $ORIGINAL >> $INPUT
echo added 251-275
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 251-275
sed -n '276,300p' $ORIGINAL >> $INPUT
echo added 276-300
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 276-300
sed -n '301,325p' $ORIGINAL >> $INPUT
echo added 301-325
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 301-325
sed -n '326,350p' $ORIGINAL >> $INPUT
echo added 326-350
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 326-350
sed -n '351,375p' $ORIGINAL >> $INPUT
echo added 351-376
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 351-376
sed -n '376,400p' $ORIGINAL >> $INPUT
echo added 376-400
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 376-400
sed -n '401,425p' $ORIGINAL >> $INPUT
echo added 401-425
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 401-425
sed -n '426,450p' $ORIGINAL >> $INPUT
echo added 426-450
python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
echo finished 426-450
#sed -n '451,475p' $ORIGINAL >> $INPUT
#python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
#sed -n '476,500p' $ORIGINAL >> $INPUT
#python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu
#sed -n '501,514p' $ORIGINAL >> $INPUT
#python biosample2table.py -i $INPUT -o $OUTPUT -e angavalos@ucdavis.edu


# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -j ${SLURM_JOB_ID}