#!/bin/sh
############################################################################
# This is for converting variable names of anl_p125_${var} data which are
# downloaded on NCAR.You have to use monthly data.
#  You can change variable, year, mon.
###########################################################################

loc1=/disk3/hjchoi/JRA55/nc_window/daily/
loc2=/disk3/hjchoi/JRA55/NC/

#for var in "ugrd" "vgrd" "spfh" ;do
for var in "ugrd" "vgrd" ;do
#for var in "spfh" ;do
 for year in {2012..2019} ; do
 #for year in "2012" ; do
  for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"; do

 if [ $var == "ugrd" ] ; then
 VNAME=UGRD_GDS0_ISBL
 LNAME="u-component of wind"
 elif [ $var == "vgrd" ] ; then
 VNAME=VGRD_GDS0_ISBL
 LNAME="v-component of wind"
 else
 VNAME=SPFH_GDS0_ISBL
 LNAME="specific humidity"
 fi

   vari=anl_p125
   VAR=${vari}_${var}

   cat > imsi.ncl << EOF
   dir0="$loc1"
   dir1="$loc2"+"$var"
   var="$VAR"
   f=addfile(dir0+var+".day."+"$year"+"$mon"+".nc","r")
   lat=f->g0_lat_2
   lon=f->g0_lon_3
   time=f->initial_time0_hours
   level=f->lv_ISBL1
   $var=f->$VNAME
   lon!0="lon"
   lat!0="lat"
   time!0="time"
   nlev=dimsizes(level)
   if ( nlev.eq.37 ) then
   lev2     = (/1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10,7,5,3,2,1/)
   else
   lev2     = (/1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,500,450,400,350,300,250,225,200,175,150,125,100/)
   end if
   lev=tointeger(lev2)
   lev@units               = "millibar"
   lev@axis                = "Z"
   lev@standard_name       = "level"
   lev@long_name           = "Level"
   lev!0="lev"
   lev&lev=lev2

   dim=dimsizes($var)
   variable=new((/dim(0),dim(1),dim(2),dim(3)/),"float")
   variable=$var
   variable!0="time"
   variable!1="lev"
   variable!2="lat"
   variable!3="lon"
   variable&lev=lev
   variable&time=time
   variable&lat=lat
   variable&lon=lon
   variable=variable(:,::-1,:,:)

   system("rm -rf "+dir1+"/"+var+".day."+"$year"+"$mon"+".nc")
   outf=addfile(    dir1+"/"+var+".day."+"$year"+"$mon"+".nc","c")
   outf->$var=variable
   outf->lev=lev
   outf->lon=lon
   outf->lat=lat
   outf->time=time
   print("Changed  "+var+".day."+"$year"+"$mon"+".nc")
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl   
  done
 done
done
