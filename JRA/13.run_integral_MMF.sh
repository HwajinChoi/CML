#!/bin/bash
#########################################################################
## PS(time, lat, lon) -> monthly , MMF(time, plev, lat, lon) -> monthly
#########################################################################

loc1=/disk3/hjchoi/JRA55/transport/no_integral # location of MMF
loc2=/disk3/hjchoi/JRA55/NC/pressfc

 for i in {1960..2019}; do
  Q=`ls ${loc1}/map.MMF_JRA55_${i}.nc`
  PS=`ls ${loc2}/pressfc.${i}.nc`
  echo ${Q}
  echo ${PS}
  cdo -s -selname,TE -setzaxis,myzaxis.txt -setcalendar,standard ${Q} tmp_te.nc
  cdo -s -selname,SE -setzaxis,myzaxis.txt -setcalendar,standard ${Q} tmp_se.nc
  cdo -s -selname,MMF -setzaxis,myzaxis.txt  -setcalendar,standard ${Q} tmp_mmf.nc
  cdo -s -selname,pressfc ${PS} tmp_ps2.nc
  cdo -s -setcalendar,standard tmp_ps2.nc tmp_ps.nc
  13.vertical_integ_transport_2.sh JRA55_${i}.nc tmp_mmf.nc tmp_se.nc tmp_te.nc 500 tmp_ps.nc
  done 
