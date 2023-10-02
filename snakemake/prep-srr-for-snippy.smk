import os
import glob
#from datetime import date
#today = date.today().strftime("%Y%b%d")

topath = "/group/weimergrp/aavalos7/projects/all-lactococcus/sra-lactococcus.smk"
inpath = "/group/weimergrp2/genomes/lactococcus/raw-reads2" #where your genome sequences are
trimpath = "/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles" #where your successful trims are
filename = "/group/weimergrp/aavalos7/projects/all-lactococcus/20231001_final-srr-list.txt"

with open(filename) as file:
    sampleids = [line.rstrip() for line in file]
#sampleids=["ERR440994"]
#sampleids=[]
#for name in os.listdir(trimpath):
#    if "SRR" in name and name not in sampleids and (os.path.isfile(trimpath+"/"+name+"/trimedReads/"+name+"_R1_trim_px.fastq.gz")) == True \
#    and (os.path.isfile(trimpath+"/"+name+"/trimedReads/"+name+"_R2_trim_px.fastq.gz")) == True:
#        sampleids.append(name)
print("SRR SRA Samples: ",len(sampleids))
print(sampleids)


        ## edit number of threads you wish to give programs that can do multi-thread (usually 4 for programs processing individual genomes)

localrules: all

#####START#####
rule all:
    input:
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_1_fastqc.zip", smpl=sampleids),
        expand(trimpath+"/{smpl}/trimedReads/{smpl}_R1_trim_px.fixed.fastq", smpl=sampleids),
        expand(trimpath+"/{smpl}/trimedReads/{smpl}_R2_trim_px.fixed.fastq", smpl=sampleids)

rule gunzip:
    input:
        i1 = trimpath+"/{smpl}/trimedReads/{smpl}_R1_trim_px.fastq.gz",
        i2 = trimpath+"/{smpl}/trimedReads/{smpl}_R2_trim_px.fastq.gz"
    output:
        o1 = trimpath+"/{smpl}/trimedReads/{smpl}_R1_trim_px.fastq",
        o2 = trimpath+"/{smpl}/trimedReads/{smpl}_R2_trim_px.fastq"
    shell:
        '''
        gunzip {input.i1}
        gunzip {input.i2}
        '''

rule fixed:
    input:
        i1 = trimpath+"/{smpl}/trimedReads/{smpl}_R1_trim_px.fastq",
        i2 = trimpath+"/{smpl}/trimedReads/{smpl}_R2_trim_px.fastq"
    output:
        o1 = trimpath+"/{smpl}/trimedReads/{smpl}_R1_trim_px.fixed.fastq",
        o2 = trimpath+"/{smpl}/trimedReads/{smpl}_R2_trim_px.fixed.fastq"
    shell:
        r'''
        sed -E "s/^((@|\+)SRR[^.]+\.[^.]+)\.(1|2)/\1/" {input.i1} > {output.o1}
        sed -E "s/^((@|\+)SRR[^.]+\.[^.]+)\.(1|2)/\1/" {input.i2} > {output.o2}
        '''
