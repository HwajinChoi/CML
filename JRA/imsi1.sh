#!/bin/sh
loc1=/disk3/hjchoi/JRA55/nc_window

cd ${loc1}

for year in {1960..2013};do
 cdo -s -selyear,${year} -monmean ${loc1}/ice125.091_icec.${year}010100_${year}123121.nc ${loc1}/ices.JRA55.mon.${year}01-${year}12.nc
 echo "Accomplished monthly Evaporation (${year})"
done
