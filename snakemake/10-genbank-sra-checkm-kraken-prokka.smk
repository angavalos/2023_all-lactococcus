import os
import glob
#from datetime import date
#today = date.today().strftime("%Y%b%d")

topath = "/group/weimergrp/aavalos7/projects/all-lactococcus/sra-lactococcus.smk"
inpath = "/group/weimergrp2/genomes/lactococcus/genomes-unzipped" #where your genome sequences are
#trimpath = "/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles" #where your successful trims are
outpath = "/group/weimergrp2/genomes/lactococcus/genbank-sra-10/analysis" #where you want output files
        ## edit number of threads you wish to give shovill (usually 4)

filename = "/group/weimergrp/aavalos7/projects/all-lactococcus/10-select-art-simulations.txt"
genomefiles = "/group/weimergrp2/genomes/lactococcus/genomes-unzipped/"

with open(filename) as file:
    genomes = [line.rstrip() for line in file]

sampleids = []
for i in os.listdir(genomefiles):
    for j in genomes:
        if j in i:
            sampleids.append(i)

print(sampleids)
print("length: ",len(sampleids))

        ## edit number of threads you wish to give programs that can do multi-thread (usually 4 for programs processing individual genomes)

localrules: all

#####START#####
rule all:
    input:
        expand(outpath+"/sampleFiles/{smpl}/checkm/storage/bin_stats_ext.tsv", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kreport2", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kraken2", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.bracken", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/prokka/{smpl}.gff", smpl=sampleids)
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_1_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_2_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/batchReports/allFQC/rawReads/metrics.csv", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_trim.fastq.gz", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_trim.fastq.gz", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R1_trim_px_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R2_trim_px_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/batchReports/allFQC/trimed/metrics.csv", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/shovill/contigs.fa", smpl=sampleids),

            ## note CheckM requires 40GB of RAM

        ## CheckM alternatives
        #outpath+"/sampleFiles/{smpl}/quastReports/report.pdf"
        #outpath+"/sampleFiles/{smpl}/busco/run_lineage_name/full_table.tsv"
        #outpath+"/population/sourmash-293lacto/population_sig_compare_31-100k-293lacto.matrix",
        #outpath+"/population/sourmash-293lacto/population_sig_compare_31-100k-293lacto.matrix.matrix.png",
        #outpath+"/population/roary-293lacto/gene_presence_absence-293lacto.csv"

rule rawFastqc:
    input:
        i1 = inpath+"/{smpl}.fna_1.fq",
        i2 = inpath+"/{smpl}.fna_2.fq"
    output:
        outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_1_fastqc.zip",
        outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_1_fastqc.html",
        outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_2_fastqc.zip",
        outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_2_fastqc.html"
    params:
        outpath+"/sampleFiles/{smpl}/fastqc/rawReads/"
    conda:
        "snakeprograms/ymlfiles/fastqc.yml"
    shell:
        "fastqc -o {params} {input}"

rule all_rawFastqc:
    input:
        expand(inpath+"/{smpl}.fna_1.fq", smpl=sampleids),
        expand(inpath+"/{smpl}.fna_2.fq", smpl=sampleids)
    output:
        outpath+"/batchReports/allFQC/rawReads/metrics.csv",
        outpath+"/batchReports/allFQC/rawReads/summary.csv",
        outpath+"/batchReports/allFQC/rawReads/stats.csv",
        outpath+"/batchReports/allFQC/rawReads/warn.csv",
        outpath+"/batchReports/allFQC/rawReads/fail.csv"
    params:
        p1 = outpath+"/sampleFiles/*/fastqc/rawReads/*_fastqc.zip",
        ot = outpath+"/batchReports/allFQC/rawReads"
    conda:
        "snakeprograms/ymlfiles/fastqcr.yml"
    shell:
        '''
        mkdir -p {params.ot}/qcfiles/
        ln -f {params.p1} {params.ot}/qcfiles/
        Rscript --vanilla snakeprograms/scripts/fastqcr.R {params.ot}
        '''

rule trimmomatic:
    input:
        a = "snakeprograms/adapters/all_illumina_trimmomatic_2022Aug01.fa",
        i1 = inpath+"/{smpl}.fna_1.fq",
        i2 = inpath+"/{smpl}.fna_1.fq"
    output:
        o1 = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_trim.fastq.gz",
        o2 = temp(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_se.fastq.gz"),
        o3 = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_trim.fastq.gz",
        o4 = temp(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_se.fastq.gz")
    conda:
        "snakeprograms/ymlfiles/trimmomatic.yml"
    shell:
        '''
        trimmomatic PE -quiet {input.i1} {input.i2} {output.o1} {output.o2} {output.o3} {output.o4}\
        ILLUMINACLIP:{input.a}:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:15 MINLEN:50
        '''
        #params ref: https://doi.org/10.1371/journal.pone.0239677

rule phix_bowtie2:
    input:
        in1 = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_trim.fastq.gz",
        in2 = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_trim.fastq.gz"
    output:
        outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_trim_px.fastq.gz",
        outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_trim_px.fastq.gz",
        outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_phix.sam",
        temp(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_phix.out")
    params:
        fq = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R%_trim_px.fastq.gz",
        db = "snakeprograms/databases/phix/Bowtie2Index/genome",
	    sm = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_phix.sam",
        ot = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_phix.out"
    conda:
        "snakeprograms/ymlfiles/bowtie2.yml"
    threads: 4
    shell:
        '''
        bowtie2 -p {threads} --un-conc-gz {params.fq} -x {params.db} -1 {input.in1} -2 {input.in2} -S {params.sm} &> {params.ot}
        '''

rule trimFastqc:
    input:
        i1 = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_trim_px.fastq.gz",
        i2 = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_trim_px.fastq.gz"
    output:
        outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R1_trim_px_fastqc.zip",
        outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R1_trim_px_fastqc.html",
        outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R2_trim_px_fastqc.zip",
        outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R2_trim_px_fastqc.html"
    params:
        outpath+"/sampleFiles/{smpl}/fastqc/trimed/"
    conda:
        "snakeprograms/ymlfiles/fastqc.yml"
    shell:
        "fastqc -o {params} {input}"

rule all_trimFastqc:
    input:
        expand(outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R1_trim_px_fastqc.zip", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R2_trim_px_fastqc.zip", smpl=sampleids)
    output:
        outpath+"/batchReports/allFQC/trimed/metrics.csv",
        outpath+"/batchReports/allFQC/trimed/summary.csv",
        outpath+"/batchReports/allFQC/trimed/stats.csv",
        outpath+"/batchReports/allFQC/trimed/warn.csv",
        outpath+"/batchReports/allFQC/trimed/fail.csv"
    params:
        p1 = outpath+"/sampleFiles/*/fastqc/trimed/*trim_px_fastqc.zip",
        ot = outpath+"/batchReports/allFQC/trimed"
    conda:
        "snakeprograms/ymlfiles/fastqcr.yml"
    shell:
        '''
        mkdir -p {params.ot}/qcfiles/
        ln -f {params.p1} {params.ot}/qcfiles/
        Rscript --vanilla snakeprograms/scripts/fastqcr.R {params.ot}
        '''

rule shovill:
    input:
        i1 = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_trim_px.fastq.gz",
        i2 = outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_trim_px.fastq.gz"
    output:
        outpath+"/sampleFiles/{smpl}/shovill/contigs.fa"
    params:
        outpath+"/sampleFiles/{smpl}/shovill"
    conda:
        "snakeprograms/ymlfiles/shovill.yml"
    threads: 4
    shell:
        '''
        shovill --cpus {threads} --force --outdir {params} --R1 {input.i1} --R2 {input.i2}
        '''

rule checkm:
    input:
        inpath+"/{smpl}"
    output:
        outpath+"/sampleFiles/{smpl}/checkm/storage/bin_stats_ext.tsv"
    params:
        p1 = inpath+"/{smpl}",
        p2 = outpath+"/sampleFiles/{smpl}/checkm"
    conda:
        "snakeprograms/ymlfiles/checkm.yml"
    threads: 8
    shell:
        '''
        checkm lineage_wf -t {threads} {params.p1} {params.p2}
        '''

#low memory usage alternatives for checkM Busco & Quast
rule busco:
    input:
        outpath+"/sampleFiles/{smpl}/shovill/contigs.fa"
    output:
        outpath+"/sampleFiles/{smpl}/busco/run_lineage_name/full_table.tsv"
    params:
        pt = outpath+"/sampleFiles/{smpl}/",
        id = "{smpl}"
    conda:
        "snakeprograms/ymlfiles/busco.yml"
    threads: 4
    shell:
        '''
        busco -f -q -c {threads} -m genome -i {input} -o "busco" --out_path {params.pt} --auto-lineage-prok
        '''

rule quast:
    input:
        outpath+"/sampleFiles/{smpl}/shovill/contigs.fa"
    output:
        outpath+"/sampleFiles/{smpl}/quastReports/report.pdf"
    params:
        outpath+"/sampleFiles/{smpl}/quastReports"
    conda:
        "snakeprograms/ymlfiles/quast.yml"
    shell:
        '''
        quast -o {params} {input}
        '''

rule sour_sig_100k:
    input:
        inpath+"/{smpl}"
    output:
        outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig"
    conda: 
        "snakeprograms/ymlfiles/sourmash.yml"
    shell:
        '''
        sourmash compute --scaled 100000 -k 21,31,51 -o {output} {input}
        '''

rule kraken2:
    input:
        inpath+"/{smpl}"
    output:
        o1 = outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kraken2",
        o2 = outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kreport2"
    params:
        "/group/weimergrp2/krakenDB/databases/standard_2023Jul06"
    threads: 8
    shell:
        '''
        cd /group/weimergrp2/krakenDB/kraken2
        ./kraken2 --db={params} --threads {threads} --report {output.o2} {input} > {output.o1}
        '''

rule bracken:
    input:
        outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kreport2"
    output:
        outpath+"/sampleFiles/{smpl}/kraken/{smpl}.bracken"
    params:
        p1 = "/group/weimergrp2/krakenDB/databases/standard_2023Jul06",
        p2 = "150",
        p3 = "S",
        p4 = "10"
    shell:
        '''
        cd /group/weimergrp2/krakenDB/bracken
        ./bracken -d {params.p1} -i {input} -o {output} -r {params.p2} -l {params.p3} -t {params.p4}
        '''

rule sour_cmp_31:
    input:
        expand(outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig", smpl=sampleids),
    output:
        o1 = outpath+"/population/sourmash-293lacto/population_sig_compare_31-100k-293lacto.csv",
        o2 = outpath+"/population/sourmash-293lacto/population_sig_compare_31-100k-293lacto.matrix"
    conda:
        "snakeprograms/ymlfiles/sourmash.yml"
    shell:
        '''
        sourmash compare -k 31 --csv {output.o1} -o {output.o2} {input}
        '''

rule sour_plt:
    input:
        outpath+"/population/sourmash-293lacto/population_sig_compare_31-100k-293lacto.matrix"
    output:
        outpath+"/population/sourmash-293lacto/population_sig_compare_31-100k-293lacto.matrix.matrix.png"
    params:
        outpath+"/population/sourmash-293lacto/"
    conda:
        "snakeprograms/ymlfiles/sourmash.yml"
    shell:
        '''
        sourmash plot --labels --output-dir {params} {input}
        '''

rule prokka:
    input:
        inpath+"/{smpl}"
    output:
        outpath+"/sampleFiles/{smpl}/prokka/{smpl}.gff"
    params:
        pt = outpath+"/sampleFiles/{smpl}/prokka",
        id = "{smpl}"
    conda:
        "snakeprograms/ymlfiles/prokka.yml"
    threads: 4
    shell:
        '''
        prokka --cpus {threads} --force --outdir {params.pt} --prefix {params.id} {input}
        '''

rule roary:
    input:
        expand(outpath+"/sampleFiles/{smpl}/prokka/{smpl}.gff", smpl=sampleids),
    output:
        outpath+"/population/roary-293lacto/core_gene_alignment-293lacto.aln",
        outpath+"/population/roary-293lacto/gene_presence_absence-293lacto.csv"
    params:
        pt = outpath+"/population/roary-293lacto"
    conda:
        "snakeprograms/ymlfiles/roary.yml"
    threads: 8
    shell: 
        '''
        roary -p {threads} --group_limit 1000000 -r -e --mafft -v -f {params.pt} {input}
        '''
