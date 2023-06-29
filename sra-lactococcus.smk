import os
import glob
#from datetime import date
#today = date.today().strftime("%Y%b%d")

topath = "/group/weimergrp/aavalos7/projects/all-lactococcus/sra-lactococcus.smk"
inpath = "/group/weimergrp2/genomes/lactococcus/raw_reads" #where your genome sequences are
outpath = "/group/weimergrp2/genomes/lactococcus/analysis" #where you want output files
        ## edit number of threads you wish to give shovill (usually 4)

#fastq files common path and base name
sampleids=[]
for name in glob.glob(inpath+"/*.fastq.gz"):
    ID = os.path.basename(name).split("_1")[0]
    if ID not in sampleids and os.path.isfile(inpath+"/"+ID+"_1.fastq.gz") == True and os.path.isfile(inpath+"/"+ID+"_2.fastq.gz") == True:
        sampleids.append(ID)

#print(sampleids)
print("length: ",len(sampleids))


        ## edit number of threads you wish to give programs that can do multi-thread (usually 4 for programs processing individual genomes)

localrules: all

#####START#####
rule all:
    input:
        expand(outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_1_fastqc.zip", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_2_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/batchReports/allFQC/rawReads/metrics.csv", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_trim.fastq.gz", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_trim.fastq.gz", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R1_trim_px_fastqc.zip", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R2_trim_px_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/batchReports/allFQC/trimed/metrics.csv", smpl=sampleids),

        #expand(outpath+"/sampleFiles/{smpl}/shovill/contigs.fa", smpl=sampleids),
        ## note CheckM requires 40GB of RAM
        #expand(outpath+"/sampleFiles/{smpl}/checkm/storage/bin_stats_ext.tsv", smpl=sampleids),

        ## CheckM alternatives
        #outpath+"/sampleFiles/{smpl}/quastReports/report.pdf"
        #outpath+"/sampleFiles/{smpl}/busco/run_lineage_name/full_table.tsv"

        #expand(outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig", smpl=sampleids),
        #outpath+"/population/sourmash/population_sig_compare_31-100k.matrix",
        #outpath+"/population/sourmash/population_sig_compare_31-100k.matrix.matrix.png",
 
        #expand(outpath+"/sampleFiles/{smpl}/prokka/{smpl}.gff", smpl=sampleids),
        #outpath+"/population/roary/genus/gene_presence_absence.csv"


rule rawFastqc:
    input:
        i1 = inpath+"/{smpl}_1.fastq.gz",
        i2 = inpath+"/{smpl}_2.fastq.gz"
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
        expand(inpath+"/{smpl}_1.fastq.gz", smpl=sampleids),
        expand(inpath+"/{smpl}_2.fastq.gz", smpl=sampleids)
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
        i1 = inpath+"/{smpl}_1.fastq.gz",
        i2 = inpath+"/{smpl}_2.fastq.gz"
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
        outpath+"/sampleFiles/{smpl}/shovill/contigs.fa"
    output:
        outpath+"/sampleFiles/{smpl}/checkm/storage/bin_stats_ext.tsv"
    params:
        p1 = outpath+"/sampleFiles/{smpl}/shovill",
        p2 = outpath+"/sampleFiles/{smpl}/checkm"
    conda:
        "snakeprograms/ymlfiles/checkm.yml"
    threads: 8
    shell:
        '''
        checkm lineage_wf -t {threads} -x .fa {params.p1} {params.p2}
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
        outpath+"/sampleFiles/{smpl}/shovill/contigs.fa"
    output:
        outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig"
    conda: 
        "snakeprograms/ymlfiles/sourmash.yml"
    shell:
        '''
        sourmash compute --scaled 100000 -k 21,31,51 -o {output} {input}
        '''

rule sour_cmp_31:
    input:
        expand(outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig", smpl=sampleids),
    output:
        o1 = outpath+"/population/sourmash/population_sig_compare_31-100k.csv",
        o2 = outpath+"/population/sourmash/population_sig_compare_31-100k.matrix"
    conda:
        "snakeprograms/ymlfiles/sourmash.yml"
    shell:
        '''
        sourmash compare -k 31 --csv {output.o1} -o {output.o2} {input}
        '''

rule sour_plt:
    input:
        outpath+"/population/sourmash/population_sig_compare_31-100k.matrix"
    output:
        outpath+"/population/sourmash/population_sig_compare_31-100k.matrix.matrix.png"
    params:
        outpath+"/population/sourmash/"
    conda:
        "snakeprograms/ymlfiles/sourmash.yml"
    shell:
        '''
        sourmash plot --labels --output-dir {params} {input}
        '''

rule prokka:
    input:
        outpath+"/sampleFiles/{smpl}/shovill/contigs.fa"
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
        outpath+"/population/roary/core_gene_alignment.aln",
        outpath+"/population/roary/gene_presence_absence.csv"
    params:
        pt = outpath+"/population/roary"
    conda:
        "snakeprograms/ymlfiles/roary.yml"
    threads: 8
    shell: 
        '''
        roary -p {threads} --group_limit 1000000 -r -e --mafft -v -f {params.pt} {input}
        '''
