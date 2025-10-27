 indir    = "/media/cmlws/Data1/hjc/JRA/data/grb/anl_surf125"
 oudir    = "/media/cmlws/Data1/hjc/JRA/data/nc"
 var      = "anl_surf125"
 yyyy     = 1960
 mo       = 1
 yymm     = 196001
 edy      = 31
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
 infil       = systemfunc("ls "+indir+"/"+var+".*"+yymm+"*")
 grib_in     = addfiles(infil,"r")
 ;imsi        = grib_in[0]->TMP_GDS0_HTGL(::-1,:)
imsi        = grib_in[0]->fifo(::-1,:)
printVarSummary(imsi)
exit
 nlat        = dimsizes(imsi(:,0))
 nlon        = dimsizes(imsi(0,:))
 lat         = fspan(-90,90,nlat)
 lon         = fspan(0,358.75,nlon)
 tmp2m_hr    = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 depr2m_hr   = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 potsfc_hr   = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 pressfc_hr  = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 prmsl_hr    = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 rh2m_hr     = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 spfh2m_hr   = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 ugrd10m_hr  = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 vgrd10m_hr  = new((/edy,nhr,nlat,nlon/),float,imsi@_FillValue)
 date        = new(edy,double)
 units       = "hours since 1-1-1 00:00:0.0"
 delete(imsi)

;***********************************************
; read
;***********************************************
 kk=0
 do dd = 0, edy-1
  do hh = 0, nhr-1
   tmp2m_hr(dd,hh,:,:)   = grib_in[kk]->TMP_GDS0_HTGL(::-1,:)
   depr2m_hr(dd,hh,:,:)  = grib_in[kk]->DEPR_GDS0_HTGL(::-1,:)
   potsfc_hr(dd,hh,:,:)  = grib_in[kk]->POT_GDS0_SFC(::-1,:)
   pressfc_hr(dd,hh,:,:) = grib_in[kk]->PRES_GDS0_SFC(::-1,:)
   prmsl_hr(dd,hh,:,:)   = grib_in[kk]->PRMSL_GDS0_MSL(::-1,:)
   rh2m_hr(dd,hh,:,:)    = grib_in[kk]->RH_GDS0_HTGL(::-1,:)
   spfh2m_hr(dd,hh,:,:)  = grib_in[kk]->SPFH_GDS0_HTGL(::-1,:)
   ugrd10m_hr(dd,hh,:,:) = grib_in[kk]->UGRD_GDS0_HTGL(::-1,:)
   vgrd10m_hr(dd,hh,:,:) = grib_in[kk]->VGRD_GDS0_HTGL(::-1,:)
   kk=kk+1
  end do
  date(dd) = ut_inv_calendar(yyyy,mo,dd+1,0,0,0,units,0)
 end do

;***********************************************
; make daily (average)
;***********************************************
 tmp2m_hr!1    = "hour"
 tmp2m_hr&hour = hr
 copy_VarCoords(tmp2m_hr(0,:,0,0),depr2m_hr(0,:,0,0))
 copy_VarCoords(tmp2m_hr(0,:,0,0),potsfc_hr(0,:,0,0))
 copy_VarCoords(tmp2m_hr(0,:,0,0),pressfc_hr(0,:,0,0))
 copy_VarCoords(tmp2m_hr(0,:,0,0),prmsl_hr(0,:,0,0))
 copy_VarCoords(tmp2m_hr(0,:,0,0),rh2m_hr(0,:,0,0))
 copy_VarCoords(tmp2m_hr(0,:,0,0),spfh2m_hr(0,:,0,0))
 copy_VarCoords(tmp2m_hr(0,:,0,0),ugrd10m_hr(0,:,0,0))
 copy_VarCoords(tmp2m_hr(0,:,0,0),vgrd10m_hr(0,:,0,0))

 tmp2m   = dim_avg_n_Wrap(tmp2m_hr,1)
 depr2m  = dim_avg_n_Wrap(depr2m_hr,1)
 potsfc  = dim_avg_n_Wrap(potsfc_hr,1)
 pressfc = dim_avg_n_Wrap(pressfc_hr,1)
 prmsl   = dim_avg_n_Wrap(prmsl_hr,1)
 rh2m    = dim_avg_n_Wrap(rh2m_hr,1)
 spfh2m  = dim_avg_n_Wrap(spfh2m_hr,1)
 ugrd10m = dim_avg_n_Wrap(ugrd10m_hr,1)
 vgrd10m = dim_avg_n_Wrap(vgrd10m_hr,1)

;***********************************************
; attributes
;***********************************************
 tmp2m@long_name   = "Daily mean 2 m above ground temperature"
 depr2m@long_name  = "Daily mean 2 m above ground dew-point depression"
 potsfc@long_name  = "Daily mean surface potential temperature"
 pressfc@long_name = "Daily mean surface pressure"
 prmsl@long_name   = "Daily mean mean-sea level Pressure reduced to MSL"
 rh2m@long_name    = "Daily mean 2 m above ground relative humidity"
 spfh2m@long_name  = "Daily mean 2 m above ground specific humidity"
 ugrd10m@long_name = "Daily mean 10 m above ground u-component of wind"
 vgrd10m@long_name = "Daily mean 10 m above ground v-component of wind"
 delete(tmp2m@initial_time)
 delete(depr2m@initial_time)
 delete(potsfc@initial_time)
 delete(pressfc@initial_time)
 delete(prmsl@initial_time)
 delete(rh2m@initial_time)
 delete(spfh2m@initial_time)
 delete(ugrd10m@initial_time)
 delete(vgrd10m@initial_time)

 tmp2m!0                       = "time"
 tmp2m!1                       = "lat"
 tmp2m!2                       = "lon"
 tmp2m&time                    = date
 tmp2m&lat                     = lat
 tmp2m&lon                     = lon

 tmp2m&time@axis               = "T"
 tmp2m&time@standard_name      = "time"
 tmp2m&time@long_name          = "Time coordinate"
 delete(tmp2m&time@_FillValue)

 tmp2m&lat@units               = "degrees_north"
 tmp2m&lat@axis                = "Y"
 tmp2m&lat@standard_name       = "latitude"
 tmp2m&lat@long_name           = "Latitude coordinate"
 delete([/tmp2m&lat@La1,tmp2m&lat@Lo1,tmp2m&lat@La2,tmp2m&lat@Lo2,tmp2m&lat@Di,tmp2m&lat@Dj,tmp2m&lat@GridType/])

 tmp2m&lon@units               = "degrees_east"
 tmp2m&lon@axis                = "X"
 tmp2m&lon@standard_name       = "longitude"
 tmp2m&lon@long_name           = "Longitude coordinate"
 delete([/tmp2m&lon@La1,tmp2m&lon@Lo1,tmp2m&lon@La2,tmp2m&lon@Lo2,tmp2m&lon@Di,tmp2m&lon@Dj,tmp2m&lon@GridType/])

 copy_VarCoords(tmp2m,depr2m)
 copy_VarCoords(tmp2m,potsfc)
 copy_VarCoords(tmp2m,pressfc)
 copy_VarCoords(tmp2m,prmsl)
 copy_VarCoords(tmp2m,rh2m)
 copy_VarCoords(tmp2m,spfh2m)
 copy_VarCoords(tmp2m,ugrd10m)
 copy_VarCoords(tmp2m,vgrd10m)

;***********************************************
; loop through variables and output each to netcdf
;***********************************************
 filedimdef(ncdf_out,"time",-1,True)
 ncdf_out->tmp2m   = tmp2m
 ncdf_out->prmsl   = prmsl
 ncdf_out->rh2m    = rh2m
 ncdf_out->spfh2m  = spfh2m
 ncdf_out->ugrd10m = ugrd10m
 ncdf_out->vgrd10m = vgrd10m
 ncdf_out->depr2m  = depr2m
 ncdf_out->potsfc  = potsfc
 ncdf_out->pressfc = pressfc

