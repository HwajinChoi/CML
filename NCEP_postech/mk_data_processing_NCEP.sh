#!/bin/bash

dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep # 500, 300, 200


for n in $(seq 1991 1 2022) ;do

 cdo -s -selmonth,5,6,7,8,9 -sellevel,850 ${dir1}/hgt.${n}.nc ${dir2}/850/last/hgt.850.${n}.nc
 echo "Accomplished hgt.850.${n}.nc"
# cdo -s -selmonth,5,6,7,8,9 -sellevel,300 ${dir1}/hgt.${n}.nc ${dir2}/300/hgt.300.${n}.nc
# echo "Accomplished hgt.300.${n}.nc"
# cdo -s -selmonth,5,6,7,8,9 -sellevel,200 ${dir1}/hgt.${n}.nc ${dir2}/200/hgt.200.${n}.nc
# echo "Accomplished hgt.200.${n}.nc"

done
