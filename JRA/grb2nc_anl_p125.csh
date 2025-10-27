#!/bin/csh
set fname    = grb2nc_anl_p125.ncl
set vari     = anl_p125
set pwd      = `pwd`
set idir     = /home/hyku/JRA55/daily/$vari
#set oudir    = $pwd/NC
set oudir    = /disk3/hjchoi/JRA55/convert2nc 
set syr      = 2019
set eyr      = 2019
set smo      = 3
set emo      = 3
set edy      = ( 31 28 31 30 31 30 31 31 30 31 30 31 )

foreach var  ( relv rh strm vpot )
  set indir = $idir/$var
  set VAR   = ${vari}_$var
  if ( $var == tmp ) then
   set VNAME = TMP_GDS0_ISBL
   set LNAME = "air temperature"
  else if ( $var == hgt ) then
   set VNAME = HGT_GDS0_ISBL
   set LNAME = "geopotential height"
  else if ( $var == ugrd ) then
   set VNAME = UGRD_GDS0_ISBL
   set LNAME = "u-component of wind"
  else if ( $var == vgrd ) then
   set VNAME = VGRD_GDS0_ISBL
   set LNAME = "v-component of wind"
  else if ( $var == spfh ) then
   set VNAME = SPFH_GDS0_ISBL
   set LNAME = "specific humidity"
  else if ( $var == relv ) then
   set VNAME = RELV_GDS0_ISBL
   set LNAME = "relative vorticity"
  else if ( $var == rh ) then
   set VNAME = RH_GDS0_ISBL
   set LNAME = "relative humidity"
  else if ( $var == strm ) then
   set VNAME = STRM_GDS0_ISBL
   set LNAME = "stream function"
  else if ( $var == vpot ) then
   set VNAME = VPOT_GDS0_ISBL
   set LNAME = "velocity potential"
  endif

  @ yr = $syr
  while ( $yr <= $eyr )
    @ jul1 = $yr - ( $yr / 4 ) * 4
    @ jul2 = $yr - ( $yr / 100 ) * 100
    @ jul3 = $yr - ( $yr / 400 ) * 400
    if ( $jul1 == 0 && $jul2 != 0 || $jul3 == 0 ) then
      set edy[2] = 29
    else
      set edy[2] = 28
    endif

    @ mon = $smo
    while ( $mon <= $emo )
      set mo   = `echo $mon | awk '{printf "%02d\n", $1}'`
      set yymm = $yr$mo

cat > $fname << EOF
 indir    = "$indir"
 oudir    = "$oudir"
 var      = "$VAR"
 yyyy     = $yr
 mo       = $mon
 yymm     = $yymm
 edy      = $edy[$mon]
 hr       = (/0,6,12,18/)
 nhr      = dimsizes(hr)

;***********************************************
; create output netcdf file
;*********************************************** 
 oufil    = oudir+"/"+var+".day."+yymm+".nc"
 system("rm -rf "+oufil)                 ; remove any pre-existing file
 ncdf_out = addfile(oufil ,"c")          ; create output netCDF file

;***********************************************
; get variable names from grib file
;***********************************************
 infil    = systemfunc("ls "+indir+"/"+var+"."+yymm+"*")
 grib_in  = addfiles(infil,"r")
 imsi     = grib_in[0]->${VNAME}(:,::-1,:)
 nlev     = dimsizes(imsi(:,0,0))
 nlat     = dimsizes(imsi(0,:,0))
 nlon     = dimsizes(imsi(0,0,:))
 if ( nlev.eq.37 ) then
  lev     = (/1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10,7,5,3,2,1/)
 else
  lev     = (/1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,500,450,400,350,300,250,225,200,175,150,125,100/)
 end if
 lat      = fspan(-90,90,nlat)
 lon      = fspan(0,358.75,nlon)
 dat_hr   = new((/edy,nhr,nlev,nlat,nlon/),float,imsi@_FillValue)
 date     = new(edy,double)
 units    = "hours since 1-1-1 00:00:0.0"
 delete(imsi)

;***********************************************
; read
;***********************************************
 kk=0
 do dd = 0, edy-1
  do hh = 0, nhr-1
   dat_hr(dd,hh,:,:,:) = grib_in[kk]->${VNAME}(::-1,::-1,:)
   kk=kk+1
  end do
  date(dd) = ut_inv_calendar(yyyy,mo,dd+1,0,0,0,units,0)
 end do

;***********************************************
; make daily (average)
;***********************************************
 dat_hr!1    = "hour"
 dat_hr&hour = hr
 dat         = dim_avg_n_Wrap(dat_hr,1)

;***********************************************
; attributes
;***********************************************
 dat@long_name = "Daily mean ${LNAME}"
 delete(dat@initial_time)

 dat!0                       = "time"
 dat!1                       = "lev"
 dat!2                       = "lat"
 dat!3                       = "lon"
 dat&time                    = date
 dat&lev                     = lev
 dat&lat                     = lat
 dat&lon                     = lon

 dat&time@axis               = "T"
 dat&time@standard_name      = "time"
 dat&time@long_name          = "Time coordinate"
 delete(dat&time@_FillValue)

;dat&lev@units               = "hPa"
 dat&lev@units               = "millibar"
 dat&lev@axis                = "Z"
 dat&lev@standard_name       = "level"
 dat&lev@long_name           = "Level"

 dat&lat@units               = "degrees_north"
 dat&lat@axis                = "Y"
 dat&lat@standard_name       = "latitude"
 dat&lat@long_name           = "Latitude coordinate"
 delete([/dat&lat@La1,dat&lat@Lo1,dat&lat@La2,dat&lat@Lo2,dat&lat@Di,dat&lat@Dj,dat&lat@GridType/])

 dat&lon@units               = "degrees_east"
 dat&lon@axis                = "X"
 dat&lon@standard_name       = "longitude"
 dat&lon@long_name           = "Longitude coordinate"
 delete([/dat&lon@La1,dat&lon@Lo1,dat&lon@La2,dat&lon@Lo2,dat&lon@Di,dat&lon@Dj,dat&lon@GridType/])

;***********************************************
; loop through variables and output each to netcdf
;***********************************************
 filedimdef(ncdf_out,"time",-1,True)
 ncdf_out->${var} = dat

EOF

      echo '*********************************************'
      echo $var $yymm
      ncl $fname
#     ncl $fname >& /dev/null
      rm -rf $fname
    @ mon ++
    end
  @ yr ++
  end
end ## var
