import os

topath = "/group/weimergrp/aavalos7/projects/all-lactococcus/roary.smk"
outpath = "/group/weimergrp2/genomes/lactococcus/raw-reads2/" #where you want output files

sampleids = [
    "BCW_200051",
]

##### START #####
rule all:
    input:
        expand(outpath+"{smpl}_1.fastq.gz",smpl=sampleids),
        expand(outpath+"{smpl}_2.fastq.gz",smpl=sampleids)

rule rclone:
    input:
        in1 = "box:Corn Project/Corn_Isolate_Genomes_WeimerLab/{smpl}/{smpl}_1.fastq.gz",
        in2 = "box:Corn Project/Corn_Isolate_Genomes_WeimerLab/{smpl}/{smpl}_2.fastq.gz"
    output:
        outpath+"{smpl}_1.fastq.gz",
        outpath+"{smpl}_2.fastq.gz"
    params:
        p1 = outpath
    conda:
        "snakeprograms/ymlfiles/rclone.yml"
    shell:
        '''
        rclone copy {input.in1} p1
        rlcone copy {input.in2} p1
        '''