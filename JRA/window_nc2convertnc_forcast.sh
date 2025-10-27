#!/bin/sh
############################################################################
# This is for converting variable names of anl_p125_${var} data which are
# downloaded on NCAR.You have to use monthly data.
#  You can change variable, year, mon.
###########################################################################

loc1=/disk3/hjchoi/JRA55/nc_window/daily/
loc2=/disk3/hjchoi/JRA55/convert2nc/

for var in "tprat" "evap" ;do
 for year in {1960..2019} ; do

if [ $var = "tprat"  ] ; then
 VNAME=TPRAT_GDS4_SFC_ave3h
 LNAME="Total precipitation"
else
 VNAME=EVP_GDS4_SFC_ave3h
 LNAME="Evaporation"
fi

   cat > imsi.ncl << EOF
   dir0="$loc1"
   dir1="$loc2"+"$var"
   f=addfile(dir0+"pressfc.day."+"$year"+"$mon"+".nc","r")
   lat=f->g0_lat_2
   lon=f->g0_lon_3
   time=f->initial_time0_hours
   $var=f->$VNAME
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

   system("rm -rf "+dir1+"/pressfc.day."+"$year"+"$mon"+".nc")
   outf=addfile(    dir1+"/pressfc.day."+"$year"+"$mon"+".nc","c")
   outf->$var=variable
   outf->lon=lon
   outf->lat=lat
   outf->time=time
   print("Changed  pressfc.day."+"$year"+"$mon"+".nc")
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl   
 done
done
