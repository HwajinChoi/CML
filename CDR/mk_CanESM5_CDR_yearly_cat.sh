#!/bin/bash

dir1=/media/cmlws/Data3/hjc/1pctCO2_cdr/chl/CanESM5
dir2=/media/cmlws/Data1/hjc/CDR/data/1pctCO2_cdr/chl

for i in $(seq 199 1 212 );do
 j=`expr $i + 1`
 A=`ls ${dir1}/chl_Omon_CanESM5_1pctCO2-cdr_r1i1p2f1_gn_${i}?01-???012.nc`
 B=${dir2}/chl_Omon_CanESM5_1pctCO2-cdr_r1i1p2f1_gn_${i}0-${j}0.nc
 cdo -s -yearmean $A $B
 echo "$B"
done

cdo -s -mergetime ${dir2}/chl_Omon_CanESM5_1pctCO2-cdr_r1i1p2f1_gn_????-????.nc ${dir2}/chl_Omon_CanESM5_1pctCO2-cdr_r1i1p2f1_gn_1991-2130.nc
