#!/bin/bash

dir1=/media/cmlws/Data3/hjc/1pctCO2/chl/NorESM2-LM
dir2=/media/cmlws/Data1/hjc/CDR/data/1pctCO2/chl

for i in $(seq 0 1 9 );do
 j=`expr $i + 1`
 A=`ls ${dir1}/chl_Omon_NorESM2-LM_1pctCO2_r1i1p1f1_gr_00${i}101-00?012.nc`
 B=${dir2}/chl_Omon_NorESM2-LM_1pctCO2_r1i1p1f1_gr_00${i}1-00${j}0.nc
 cdo -s -yearmean $A $B
 echo "$B"
done

for i in $(seq 10 1 14 );do
 j=`expr $i + 1`
 A=`ls ${dir1}/chl_Omon_NorESM2-LM_1pctCO2_r1i1p1f1_gr_0${i}101-0??012.nc`
 B=${dir2}/chl_Omon_NorESM2-LM_1pctCO2_r1i1p1f1_gr_0${i}1-0${j}0.nc
 cdo -s -yearmean $A $B
 echo "$B"
done

#cdo mergetime ${dir2}/chl_Omon_NorESM2-LM_1pctCO2_r1i1p1f1_gr_0??1-0??0.nc ${dir2}/chl_Omon_NorESM2-LM_1pctCO2_r1i1p1f1_gr_0001-0150.nc
