import os
import glob

filename = "/group/weimergrp/aavalos7/projects/all-lactococcus/final-lacto-gt90completion-lt5contamination-gt50percentlacto.txt"

with open(filename) as file:
    lines = [line.rstrip() for line in file]
print(lines)