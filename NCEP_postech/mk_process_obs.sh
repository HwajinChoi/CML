#!/bin/bash

dir1=/media/cmlws/Data2/hjc/NCEP/data/obs
dir2=/media/cmlws/Data2/hjc/NCEP/data/obs/pr
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific

A=${dir1}/info.dat

while IFS= read -r line ;do
  cp ${dir2}/st${line}dat199[1-9]_rn.dat ${dir3}/
  cp ${dir2}/st${line}dat20*_rn.dat ${dir3}/
done < $A
