import os
import glob
#from datetime import date
#today = date.today().strftime("%Y%b%d")

topath = "/group/weimergrp/aavalos7/projects/all-lactococcus/sra-lactococcus.smk"
inpath = "/group/weimergrp2/genomes/lactococcus/genomes-unzipped" #where your genome sequences are
#trimpath = "/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles" #where your successful trims are
outpath = "/group/weimergrp2/genomes/lactococcus/genbank-genomes-analysis" #where you want output files
        ## edit number of threads you wish to give shovill (usually 4)

sampleids=[]
for name in os.listdir(inpath):
    if name.endswith(".fna"):
        sampleids.append(name)
print("Total samples: ",len(sampleids))


        ## edit number of threads you wish to give programs that can do multi-thread (usually 4 for programs processing individual genomes)

localrules: all

#####START#####
rule all:
    input:
        ## note CheckM requires 40GB of RAM
        expand(outpath+"/checkm/storage/bin_stats_ext.tsv", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kreport2", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kraken2", smpl=sampleids),
        expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.bracken", smpl=sampleids)

        ## CheckM alternatives
        #outpath+"/sampleFiles/{smpl}/quastReports/report.pdf"
        #outpath+"/sampleFiles/{smpl}/busco/run_lineage_name/full_table.tsv"

        #expand(outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig", smpl=sampleids),
        #outpath+"/population/sourmash/population_sig_compare_31-100k.matrix",
        #outpath+"/population/sourmash/population_sig_compare_31-100k.matrix.matrix.png",

        #expand(outpath+"/sampleFiles/{smpl}/prokka/{smpl}.gff", smpl=sampleids),
        #outpath+"/population/roary/genus/gene_presence_absence.csv"


rule checkm:
    input:
        inpath
    output:
        outpath+"/checkm/storage/bin_stats_ext.tsv"
    params:
        p1 = inpath,
        p2 = outpath+"/checkm"
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
        outpath+"/sampleFiles/{smpl}/shovill/contigs.fa"
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
