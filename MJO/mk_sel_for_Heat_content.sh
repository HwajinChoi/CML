#!/bin/bash

#for s in "cobalt" "daily_chl";do
for s in "cobalt" ;do

dir1=/media/cmlws/Data2/hjc/MJO/data/RE/${s}/for_HC

a=temp.0-300m.daily.19900101.nc
b=temp.0-300m.daily.19970101.nc
c=temp.0-300m.daily.20040101.nc

 for i in  $(seq 1990 1 1996);do
  cdo selyear,${i} ${dir1}/${a} ${dir1}/temp.0-300m.daily.${i}.nc
  echo "temp.0-300m.daily.${i}.nc"
 done

 for i in  $(seq 1997 1 2003);do
  cdo selyear,${i} ${dir1}/${b} ${dir1}/temp.0-300m.daily.${i}.nc
  echo "temp.0-300m.daily.${i}.nc"
 done

 for i in  $(seq 2004 1 2009);do
  cdo selyear,${i} ${dir1}/${c} ${dir1}/temp.0-300m.daily.${i}.nc
  echo "temp.0-300m.daily.${i}.nc"
 done
done
