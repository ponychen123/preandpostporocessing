#!/usr/bin/python3
#this script resort the distance and atomic positions outputed by Calatom, distance 
#has been transfered to nm 
#ponychen
#20191206

import sys

filename = sys.argv[1]

with open(filename, "r") as f:
    lines = f.readlines()

row = []
for i in range(len(lines)):
    row.append(list(map(float,lines[i].split())))

for i in range(len(row)):
    if row[i][1] > row[i][3]:
        tmp1 = row[i][1]
        tmp2 = row[i][2]
        row[i][1] = row[i][3]
        row[i][2] = row[i][4]
        row[i][3] = tmp1
        row[i][4] = tmp2

with open("sorted.txt","w+") as f:
    for i in range(len(row)):
        f.write("%12.7f  %12.7f  %12.7f \n" % (\
                row[i][3],row[i][4],row[i][0]/10.0))

