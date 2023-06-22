import os

topath = "/group/weimergrp/aavalos7/projects/all-lactococcus/roary.smk"
outpath = "/group/weimergrp2/genomes/lactococcus/raw-reads2/" #where you want output files

sampleids = [
    "BCW_200051",
    "BCW_200077",
    "BCW_200121",
    "BCW_200128",
    "BCW_200138",
    "BCW_200150",
    "BCW_200158",
    "BCW_200159",
    "BCW_200160",
    "BCW_200163",
    "BCW_200174",
    "BCW_200175",
    "BCW_200180",
    "BCW_200188",
    "BCW_200192",
    "BCW_200196",
    "BCW_200198",
    "BCW_200229",
    "BCW_200232",
    "BCW_200238",
    "BCW_200241"
]

##### START #####
rule all:
    input:
        expand(outpath+"{smpl}_1.fastq.gz",smpl=sampleids),
        expand(outpath+"{smpl}_2.fastq.gz",smpl=sampleids)

rule rclone:
 #   input:
 #       in1 = "box:Corn Project/Corn_Isolate_Genomes_WeimerLab/{smpl}/{smpl}_1.fastq.gz",
 #       in2 = "box:Corn Project/Corn_Isolate_Genomes_WeimerLab/{smpl}/{smpl}_2.fastq.gz"
    output:
        ou1 = outpath+"{smpl}_1.fastq.gz",
        ou2 = outpath+"{smpl}_2.fastq.gz"
    params:
        p1 = outpath
    conda:
        "snakeprograms/ymlfiles/rclone.yml"
    shell:
        '''
        rclone copy "box:Corn Project/Corn_Isolate_Genomes_WeimerLab/{wildcards.smpl}/{wildcards.smpl}_1.fastq.gz" {params.p1}
        rclone copy "box:Corn Project/Corn_Isolate_Genomes_WeimerLab/{wildcards.smpl}/{wildcards.smpl}_2.fastq.gz" {params.p1}
        '''