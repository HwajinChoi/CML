#!/bin/sh
############################################################################
# This is for converting variable names of data which are
# downloaded on NCAR.You have to use monthly data.
# You can change variable, year, mon.
###########################################################################

loc1=/media/cmlws/Data2/hjc/NEMO/r4.0.6/cfgs/ORCA_test4/EXP03

for var in "dlwrf" "dswrf" "srweq" "tprat" ;do

 if [ $var = "tprat"  ] ; then
  VNAME=TPRAT_GDS0_SFC_ave3h
  LNAME="Total precipitation"
 elif [ $var = "dlwrf"  ] ; then
  VNAME=DLWRF_GDS0_SFC_ave3h
  LNAME="Downward long wave radiation flux"
 elif [ $var = "dswrf"  ] ; then
  VNAME=DSWRF_GDS0_SFC_ave3h
  LNAME="Downward solar radiation flux"
 else
  VNAME=SRWEQ_GDS0_SFC_ave3h
  LNAME="Snowfall rate water equivalent"
 fi

   cat > imsi.ncl << EOF
   files=systemfunc("ls ${loc1}/fcst_phy2m125_${var}_*.nc")
   f=addfile(files,"r")
   setfileoption("nc","Format","LargeFile")
   lat=f->g0_lat_2
   lon=f->g0_lon_3
   time=f->initial_time0_hours
   $var=f->$VNAME(:,0,:,:)
   lon!0="lon"
   lat!0="lat"
   time!0="time"

   dim=dimsizes($var)
   variable=new((/dim(0),dim(1),dim(2)/),"float")
   variable=$var
   variable!0="time"
   variable!1="lat"
   variable!2="lon"
   variable&time=time
   variable&lat=lat
   variable&lon=lon

   system("rm -rf ${loc1}/fcst_phy2m125_${var}.nc")
   outf=addfile( "${loc1}/fcst_phy2m125_${var}.nc","c")
   outf->$var=variable
   outf->lon=lon
   outf->lat=lat
   outf->time=time
   print("Accomplished fcst_phy2m125_${var}.nc")
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl   
done
