import os
import glob
#from datetime import date
#today = date.today().strftime("%Y%b%d")

topath = "/group/weimergrp/aavalos7/projects/all-lactococcus/sra-lactococcus.smk"
inpath = "/group/weimergrp2/genomes/lactococcus/20230915_final-lacto-genomes/analysis/sampleFiles"
#trimpath = "/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles" #where your successful trims are
outpath = "/group/weimergrp2/genomes/lactococcus/20230915_final-lacto-genomes/analysis" #where you want output files
        ## edit number of threads you wish to give shovill (usually 4)

filena = "/group/weimergrp/aavalos7/projects/all-lactococcus/20230925_final-genomes-llactis-lactis-plants.txt"

with open(filena) as file:
    sampleids = [line.rstrip() for line in file]


        ## edit number of threads you wish to give programs that can do multi-thread (usually 4 for programs processing individual genomes)

localrules: all

#####START#####
rule all:
    input:
        #outpath+"/population/sourmash_final-lacto-genomes/population_sig_compare_31_final-lacto-genomes.matrix",
        #outpath+"/population/sourmash_final-lacto-genomes/population_sig_compare_31_final-lacto-genomes.matrix.matrix.png"
        outpath+"/population/roary_final-lacto-genomes-llactis-lactis-plants/gene_presence_absence_final-lacto-genomes-llactis-lactis-plants.csv"
        #expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kreport2", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.kraken2", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/kraken/{smpl}.bracken", smpl=sampleids)
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_1_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/rawReads/{smpl}_2_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/batchReports/allFQC/rawReads/metrics.csv", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R1_trim.fastq.gz", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/trimedReads/{smpl}_R2_trim.fastq.gz", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R1_trim_px_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/fastqc/trimed/{smpl}_R2_trim_px_fastqc.zip", smpl=sampleids),
        #expand(outpath+"/batchReports/allFQC/trimed/metrics.csv", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/prokka/{smpl}.gff", smpl=sampleids),
        #expand(outpath+"/sampleFiles/{smpl}/shovill/contigs.fa", smpl=sampleids),
        ## note CheckM requires 40GB of RAM
        #expand(outpath+"/sampleFiles/{smpl}/checkm/storage/bin_stats_ext.tsv", smpl=sampleids),

        ## CheckM alternatives
        #outpath+"/sampleFiles/{smpl}/quastReports/report.pdf"
        #outpath+"/sampleFiles/{smpl}/busco/run_lineage_name/full_table.tsv"

rule sour_cmp_31:
    input:
        expand(outpath+"/sampleFiles/{smpl}/sourmash/{smpl}.sig", smpl=sampleids),
    output:
        o1 = outpath+"/population/sourmash_final-lacto-genomes/population_sig_compare_31_final-lacto-genomes.csv",
        o2 = outpath+"/population/sourmash_final-lacto-genomes/population_sig_compare_31_final-lacto-genomes.matrix"
    conda:
        "snakeprograms/ymlfiles/sourmash.yml"
    shell:
        '''
        sourmash compare -k 31 --csv {output.o1} -o {output.o2} {input}
        '''

rule sour_plt:
    input:
        outpath+"/population/sourmash_final-lacto-genomes/population_sig_compare_31_final-lacto-genomes.matrix"
    output:
        outpath+"/population/sourmash_final-lacto-genomes/population_sig_compare_31_final-lacto-genomes.matrix.matrix.png"
    params:
        outpath+"/population/sourmash_final-lacto-genomes/"
    conda:
        "snakeprograms/ymlfiles/sourmash.yml"
    shell:
        '''
        sourmash plot --labels --output-dir {params} {input}
        '''

rule roary:
    input:
        expand(outpath+"/sampleFiles/{smpl}/prokka/{smpl}.gff", smpl=sampleids),
    output:
        outpath+"/population/roary_final-lacto-genomes-llactis-lactis-plants/core_gene_alignment_final-lacto-genomes-llactis-lactis-plants.aln",
        outpath+"/population/roary_final-lacto-genomes-llactis-lactis-plants/gene_presence_absence_final-lacto-genomes-llactis-lactis-plants.csv"
    params:
        pt = outpath+"/population/roary_final-lacto-genomes-llactis-lactis-plants"
    conda:
        "snakeprograms/ymlfiles/roary.yml"
    threads: 8
    shell: 
        '''
        roary -p {threads} --group_limit 1000000 -r -e --mafft -v -f {params.pt} {input}
        '''
