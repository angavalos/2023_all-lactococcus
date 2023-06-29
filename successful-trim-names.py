import os
import glob

inpath = "/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles/"

sampleids=[]
totalids=[]
for name in os.listdir(inpath):
    totalids.append(name)
    if name not in sampleids and (os.path.isfile(inpath+name+"/trimedReads/"+name+"_R1_trim.fastq.gz")) == True \
    and (os.path.isfile(inpath+name+"/trimedReads/"+name+"_R1_trim.fastq.gz")) == True:
        sampleids.append(name)
print("Total: ",len(totalids))
print("Successful Trim: ",len(sampleids))