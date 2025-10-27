#!/bin/bash

dir1=/media/cmlws/Data1/hjc/CDR/data/historical/chl
dir2=/media/cmlws/Data1/hjc/CDR/data/historical/chl/first

for n in "ACCESS-ESM1-5" "CanESM5" "CESM2" "CNRM-ESM2-1" "GFDL-ESM4" "MIROC-ES2L" "NorESM2-LM" "UKESM1-0-LL";do 

 A=`ls ${dir2}/chl_Omon_${n}*`
 B=`echo chl_Omon_${n}_historical_199801-201412.nc`

# cdo selyear,1998/2014 $A ${dir2}/$B
 cdo remapbil,mygrid ${dir2}/$B ${dir1}/$B

done
