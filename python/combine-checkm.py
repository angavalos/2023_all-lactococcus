# Run this in the pandas conda environment.
import os
import pandas as pd
import ast

path="/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles/"
ckmpath="/checkm/storage/bin_stats_ext.tsv"
top = pd.DataFrame()
for i in os.listdir(path):
    if os.path.isfile(path+i+ckmpath)==False:
        print("These don't have checkm:", i)
    elif os.path.isfile(path+i+ckmpath)==True:
        ckm = open(path+i+ckmpath, "r").read()
        clnckm = ckm.replace("contigs\t","").replace("\n","")
        ckmdic = ast.literal_eval(clnckm)
        smlckmdic = {k: ckmdic[k] for k in ('marker lineage', '# genomes', '# markers', '# marker sets', '0', '1', '2', '3', '4', '5+', 'Completeness', 'Contamination', 'GC', 'GC std', 'Genome size', '# ambiguous bases', '# scaffolds', '# contigs', 'Longest scaffold', 'Longest contig', 'N50 (scaffolds)', 'N50 (contigs)', 'Mean scaffold length', 'Mean contig length', 'Coding density', 'Translation table', '# predicted genes')}
        data = pd.DataFrame.from_dict(smlckmdic, orient="index",columns=[i])
        top = pd.concat([top,data],axis=1)
top.to_csv("/group/weimergrp2/genomes/lactococcus/analysis/batchReports/allCheckM/all-checkM.csv")