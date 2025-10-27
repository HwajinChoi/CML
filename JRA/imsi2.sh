#!/bin/sh

for var in "spfh" "vgrd" ; do
 for year in {1960..2019} ; do
 loc1=/disk3/hjchoi/JRA55/NC/for_conv/${var}
 a=${var}.day.${year}.nc
 cdo -s -delete,month=2,day=29 ${loc1}/${a} ${loc1}/imsi.nc
 rm -f ${loc1}/${a}
 mv ${loc1}/imsi.nc ${loc1}/${a}
 echo "Accomplished ${a}"
 done
done
