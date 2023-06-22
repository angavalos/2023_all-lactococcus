import os
import glob
#from datetime import date
#today = date.today().strftime("%Y%b%d")

topath = "/group/weimergrp/"
inpath = "/group/weimergrp2/genomes/lactococcus/raw-reads2" #where your genome sequences are
outpath = "/group/weimergrp2/genomes/lactococcus/analysis" #where you want output files
        ## edit number of threads you wish to give shovill (usually 4)

#fastq files common path and base name
sampleids=[]
for name in glob.glob(inpath+"/*.fastq.gz"):
    if name.endswith("R1.fastq.gz") == True:
        ID = os.path.basename(name).split("_R1")[0]
        if ID not in sampleids and os.path.isfile(inpath+"/"+ID+"_R1.fastq.gz") == True and os.path.isfile(inpath+"/"+ID+"_R2.fastq.gz") == True:
            sampleids.append(ID)
    elif name.endswith("_1.fastq.gz") == True:
        ID = os.path.basename(name).split("_1")[0]
        if ID not in sampleids and os.path.isfile(inpath+"/"+ID+"_1.fastq.gz") == True and os.path.isfile(inpath+"/"+ID+"_2.fastq.gz") == True:
            sampleids.append(ID)
print(sampleids)
print(len(sampleids))