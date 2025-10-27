#!/bin/bash

dir1=/media/cmlws/Data2/hjc/NCEP/data/obs
dir2=/media/cmlws/Data2/hjc/NCEP/data/obs/pr
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific/no_leap

A=${dir1}/info.dat

while IFS= read -r line ;do
 for i in "1992" "1996" "2000" "2004" "2008" "2012" "2016" "2020" ; do
  sed '60d' ${dir3}/st${line}dat${i}_rn.dat > ${dir4}/st${line}dat${i}_rn.dat
 done
done < $A
