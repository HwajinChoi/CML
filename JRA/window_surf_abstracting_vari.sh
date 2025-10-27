#!/bin/sh

loc1=/disk3/hjchoi/JRA55/convert2nc
loc2=/disk3/hjchoi/JRA55/convert2nc/pressfc
for year in {1960..2010};do
 for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ;do
 cdo -s -selname,pressfc ${loc1}/anl_surf125.day.${year}${mon}.nc ${loc2}/pressfc.day.${year}${mon}.nc
 echo "Accomplished pressfc.day.${year}${mon}.nc" 
 done
done
