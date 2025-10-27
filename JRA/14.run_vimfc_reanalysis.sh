#!/bin/bash
#########################################################################
## PS(time, lat, lon) -> Daily , spfh,ugrd,vgrd(time, plev, lat, lon) -> daily
#########################################################################

loc1=/disk3/hjchoi/JRA55/NC/for_conv # location 
loc2=/disk3/hjchoi/JRA55/NC/pressfc

for year in {2012..2019} ;do
 for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ;do

  Q=`ls ${loc1}/spfh/spfh.day.${year}${mon}.nc`
  U=`ls ${loc1}/ugrd/ugrd.day.${year}${mon}.nc`
  V=`ls ${loc1}/vgrd/vgrd.day.${year}${mon}.nc`
  PS=`ls ${loc2}/pressfc.day.${year}${mon}.nc`
  echo ${Q}
  echo ${U}
  echo ${V}
  echo ${PS}
  cdo -s -b 64 -selname,spfh ${Q} tmp_q2.nc
  cdo -s -b 64 -setzaxis,myzaxis.txt tmp_q2.nc tmp_q.nc
  cdo -s -b 64 -selname,ugrd ${U} tmp_u2.nc
  cdo -s -b 64 -setzaxis,myzaxis.txt tmp_u2.nc tmp_u.nc
  cdo -s -b 64 -selname,vgrd ${V} tmp_v2.nc
  cdo -s -b 64 -setzaxis,myzaxis.txt tmp_v2.nc tmp_v.nc
  #cdo -s -b 64 -selname,slp -setcalendar,standard ${PS} tmp_slp.nc
  cdo -s -b 64 -selname,pressfc ${PS} tmp_slp2.nc
  cdo -s -b 64 -setcalendar,standard tmp_slp2.nc tmp_slp.nc
  rm -rf tmp_q2.nc tmp_u2.nc tmp_v2.nc tmp_slp2.nc 
  VIMFC3.sh .JRA55.${year}${mon}.nc tmp_q.nc tmp_u.nc tmp_v.nc 10 tmp_slp.nc
 done
done
