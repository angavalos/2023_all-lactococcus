import os

topath = "/group/weimergrp/aavalos7/projects/all-lactococcus/roary.smk"
outpath = "/group/weimergrp2/genomes/lactococcus/genbank-sra-art-simulation/" #where you want output files

filename = "/group/weimergrp/aavalos7/projects/all-lactococcus/10-select-art-simulations.txt"
genomefiles = "/group/weimergrp2/genomes/lactococcus/genomes-unzipped/"

with open(filename) as file:
    genomes = [line.rstrip() for line in file]

sampleids = []
for i in os.listdir(genomefiles):
    for j in genomes:
        if j in i:
            sampleids.append(i)

##### START #####
rule all:
    input:    
        expand(outpath+"{smpl}/{smpl}_1.fq",smpl=sampleids),
        expand(outpath+"{smpl}/{smpl}_2.fq",smpl=sampleids),
        expand(outpath+"{smpl}/{smpl}_1.aln",smpl=sampleids),
        expand(outpath+"{smpl}/{smpl}_2.aln",smpl=sampleids)

rule art:
    input:
        in1 = genomefiles+"{smpl}"
    output:
        outpath+"{smpl}/{smpl}_1.fq",
        outpath+"{smpl}/{smpl}_2.fq",
        outpath+"{smpl}/{smpl}_1.aln",
        outpath+"{smpl}/{smpl}_2.aln"
    params:
        p1 = "HS25",
        p2 = 150,
        p3 = 50,
        p4 = 450,
        p5 = 45,
        p6 = outpath+"{smpl}/{smpl}_"
    conda:
        "snakeprograms/ymlfiles/art.yml"
    shell:
        '''
        art_illumina -ss {params.p1} -sam -i {input.in1} -p -l {params.p2} -f {params.p3} -m {params.p4} -s {params.p5} -o {params.p6}
        '''