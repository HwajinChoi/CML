#!/bin/bash

# Period : 200001-201912

for n in "on" "off" ;do

 dir0=/media/cmlws/Data3/hjc/cobalt_${n}_ocean/5y
 dir1=/media/cmlws/Data3/hjc/cobalt_${n}_ocean/10y
 dir2=/media/cmlws/Data3/hjc/cobalt_${n}_ocean/15y
 dir3=/media/cmlws/Data3/hjc/cobalt_${n}_ocean/20y

 dir4=/media/cmlws/Data2/hjc/MJO/data/${n}

 cdo -s -selname,tos ${dir0}/20000101.ocean_month.nc ${dir4}/tos_200001-200412.nc
 echo "tos_200001-200412.nc"
 cdo -s -selname,tos ${dir1}/20050101.ocean_month.nc ${dir4}/tos_200501-200912.nc
 echo "tos_200501-200912.nc"
 cdo -s -selname,tos ${dir2}/20100101.ocean_month.nc ${dir4}/tos_201001-201412.nc
 echo "tos_201001-201412.nc"
 cdo -s -selname,tos ${dir3}/20150101.ocean_month.nc ${dir4}/tos_201501-201912.nc
 echo "tos_201501-201912.nc"

 cdo -s mergetime ${dir4}/tos_*.nc ${dir4}/tos_200001-201912.nc
 echo "tos_200001-201912.nc"

done
