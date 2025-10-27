#!/bin/bash

dir1=/media/cmlws/Data3/hjc/1pctCO2_cdr/chl/NorESM2-LM
dir2=/media/cmlws/Data1/hjc/CDR/data/1pctCO2_cdr/chl

for i in $(seq 14 1 28 );do
 j=`expr $i + 1`
 A=`ls ${dir1}/chl_Omon_NorESM2-LM_1pctCO2-cdr_r1i1p1f1_gr_0${i}?01-0???12.nc`
 B=${dir2}/chl_Omon_NorESM2-LM_1pctCO2-cdr_r1i1p1f1_gr_0${i}0-0${j}9.nc
 cdo -s -yearmean $A $B
 echo "$B"
done

cdo mergetime ${dir2}/chl_Omon_NorESM2-LM_1pctCO2-cdr_r1i1p1f1_gr_0??0-0??9.nc ${dir2}/chl_Omon_NorESM2-LM_1pctCO2-cdr_r1i1p1f1_gr_0141-0289.nc

cdo selyear,141/280 ${dir2}/chl_Omon_NorESM2-LM_1pctCO2-cdr_r1i1p1f1_gr_0141-0289.nc ${dir2}/chl_Omon_NorESM2-LM_1pctCO2-cdr_r1i1p1f1_gr_0141-0280.nc
