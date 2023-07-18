# Run this in the pandas conda environment.
import os
import pandas as pd

path="/group/weimergrp2/genomes/lactococcus/analysis/sampleFiles/"
top = pd.DataFrame()
toptop = pd.DataFrame()
bracken_fail = []
brack_pass = []
for i in os.listdir(path):
    if os.path.isfile(path+i+"/kraken/"+i+".bracken")==False:
        #print("These don't have bracken:", i)
        bracken_fail.append(i)
    elif os.path.isfile(path+i+"/kraken/"+i+".bracken")==True:
        brack_pass.append(i)
        data = pd.read_csv(path+i+"/kraken/"+i+".bracken", delimiter="\t")
        data["ID"] = i
        data["fraction_total_reads"] = pd.to_numeric(data["fraction_total_reads"])
        top = pd.concat([top,data],axis=0)
top.reset_index(drop=True,inplace=True)
#top.to_csv("/group/weimergrp2/genomes/lactococcus/analysis/batchReports/allBracken/all-Bracken.csv",index=False)
toptop = top.loc[top.groupby("ID")["fraction_total_reads"].idxmax()]
#toptop.to_csv("/group/weimergrp2/genomes/lactococcus/analysis/batchReports/allBracken/all-top-Bracken.csv",index=False)
toptoplacto = toptop[toptop["name"].str.contains("Lactococcus")]
#toptoplacto.to_csv("/group/weimergrp2/genomes/lactococcus/analysis/batchReports/allBracken/all-top-lacto-Bracken.csv",index=False)
print(len(bracken_fail), "failed to have Bracken report.")
print(len(brack_pass), "had Bracken.")
print(len(top), "total taxonomies assigned by Bracken.")
print(len(toptop), "total samples with assigned Bracken taxonomy.")
print(len(toptoplacto), "total samples with Lactococcus as highest proportion of reads.")