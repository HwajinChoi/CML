#!/bin/sh

#loc1=/disk3/hjchoi/JRA55/nc_window
loc1=/disk3/provisional_data/hjchoi/JRA-55/NC
loc2=/disk3/hjchoi/JRA55/nc_window/daily
loc3=/disk3/hjchoi/JRA55/convert2nc

for year in {2013..2019} ; do
#for year in "2012" ; do
 for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ; do
  cdo -s -daymean -settime,00:00:00 ${loc1}/anl_p125.051_spfh.${year}${mon}*.nc ${loc2}/anl_p125_spfh.day.${year}${mon}.nc
#echo "Accomplished anl_p125_spfh.day.${year}${mon}.nc"
  #cdo -s -daymean -settime,00:00:00 ${loc1}/anl_p125.033_ugrd.${year}${mon}*.nc ${loc2}/anl_p125_ugrd.day.${year}${mon}.nc
#echo "Accomplished anl_p125_ugrd.day.${year}${mon}.nc"
  #cdo -s -daymean -settime,00:00:00 ${loc1}/anl_p125.034_vgrd.${year}${mon}*.nc ${loc2}/anl_p125_vgrd.day.${year}${mon}.nc
#echo "Accomplished anl_p125_vgrd.day.${year}${mon}.nc"
  #cdo -s -daymean -settime,00:00:00 ${loc1}/pressfc.day.${year}${mon}.nc ${loc2}/pressfc.day.${year}${mon}.nc
echo "Accomplished pressfc.day.${year}${mon}.nc"
 done
done
