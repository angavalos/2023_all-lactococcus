import os
import glob

filename = "/group/weimergrp/aavalos7/projects/all-lactococcus/final-lacto-gt90completion-lt5contamination-gt50percentlacto.txt"
outgroup = "/group/weimergrp/aavalos7/projects/all-lactococcus/lacto-outgroup-labels.txt"

with open(filename) as file:
    lines = [line.rstrip() for line in file]

with open(outgroup) as file:
    lines_out = [line.rstrip() for line in file]

print(len(lines))
print(len(lines_out))

final_lines = [i for i in lines if i not in lines_out]
print(len(final_lines))