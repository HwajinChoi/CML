#!/bin/bash

dir1=/media/cmlws/Data3/hjc/1pctCO2/chl/ACCESS-ESM1-5
dir2=/media/cmlws/Data1/hjc/CDR/data/1pctCO2/chl

for i in $(seq 10 1 23 );do
 j=`expr $i + 1`
 A=`ls ${dir1}/chl_Omon_ACCESS-ESM1-5_1pctCO2_r1i1p1f1_gn_0${i}101-0??012.nc`
 B=${dir2}/chl_Omon_ACCESS-ESM1-5_1pctCO2_r1i1p1f1_gn_0${i}1-0${j}0.nc
 cdo -s -yearmean $A $B
 echo "$B"
done

cdo -s -mergetime ${dir2}/chl_Omon_ACCESS-ESM1-5_1pctCO2_r1i1p1f1_gn_0???-0???.nc ${dir2}/chl_Omon_ACCESS-ESM1-5_1pctCO2_r1i1p1f1_gn_0101-0240.nc
