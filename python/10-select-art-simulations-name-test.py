import os
import glob

filename = "/group/weimergrp/aavalos7/projects/all-lactococcus/10-select-art-simulations.txt"
genomefiles = "/group/weimergrp2/genomes/lactococcus/genomes/"

with open(filename) as file:
    genomes = [line.rstrip() for line in file]

samples = []
for i in os.listdir(genomefiles):
    for j in genomes:
        if j in i:
            samples.append(i)

print(len(samples))
print(samples)