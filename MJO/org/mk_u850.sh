#!/bin/bash

for O in "on" "off";do
 for n in "5y" "10y" "15y" "20y";do

dir1=/media/cmlws/Data3/hjc/cobalt_${O}_ocean/${n}
dir2=/media/cmlws/Data2/hjc/MJO/data/${O}

 D=`ls ${dir1}/2???0101.ucomp.daily.nc`
 cdo -s -sellevel,849.397132 ${D} ${dir2}/ucomp.850hpa.${n}.nc
 echo "ucomp.850hpa.${n}.nc"

 done
done
