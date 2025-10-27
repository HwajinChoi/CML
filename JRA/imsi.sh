#!/bin/sh
loc1=/disk3/hjchoi/JRA55/NC/pressfc

cd ${loc1}

for year in {2011..2019};do
 cdo -s -invertlat ${loc1}/pressfc.${year}.nc ${loc1}/imsi.nc
 rm -f ${loc1}/pressfc.${year}.nc
 mv ${loc1}/imsi.nc ${loc1}/pressfc.${year}.nc
 echo "Accomplished pressfc.${year}.nc"
done
