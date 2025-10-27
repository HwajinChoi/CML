#!/bin/sh

loc1=/disk3/hjchoi/JRA55
loc2=/disk3/hjchoi/JRA55/GRIB

#for year in "2012" ; do
for year in {1960..2011} ; do
 for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ;do
 #for mon in "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ;do
 #mv ${loc1}/${year}${mon}/anl_p125_ugrd.?????????? ${loc2}/ugrd/
 #mv ${loc1}/${year}${mon}/anl_p125_vgrd.?????????? ${loc2}/vgrd/
 #mv ${loc1}/${year}${mon}/anl_p125_spfh.?????????? ${loc2}
 mv ${loc1}/${year}${mon}/anl_surf125.?????????? ${loc2}
 echo "Moved ${year}${mon}"
 done
done
