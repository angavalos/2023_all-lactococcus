import os
import glob

sampleids=[]
totalids=[]
trimpath = "/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles" #where your successful trims are
for name in os.listdir(trimpath):
    totalids.append(name)
    if name not in sampleids and (os.path.isfile(trimpath+"/"+name+"/trimedReads/"+name+"_R1_trim_px.fastq.gz")) == True \
    and (os.path.isfile(trimpath+"/"+name+"/trimedReads/"+name+"_R2_trim_px.fastq.gz")) == True:
        sampleids.append(name)
    else:
        print("Unsuccessful Trim: ",name)
print("Total: ",len(totalids))
print("Successful Trim: ",len(sampleids))
#print(sampleids)