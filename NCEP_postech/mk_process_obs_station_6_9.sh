#!/bin/bash

dir1=/media/cmlws/Data2/hjc/NCEP/data/obs
dir2=/media/cmlws/Data2/hjc/NCEP/data/obs/pr
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific/no_leap
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific/6_9

A=${dir1}/info.dat

while IFS= read -r line ;do
 for i in $(seq 1991 1 2022) ;do
  sed -n '152,273p' ${dir3}/st${line}dat${i}_rn.dat > ${dir4}/st${line}dat${i}_rn.dat
 done
done < $A
