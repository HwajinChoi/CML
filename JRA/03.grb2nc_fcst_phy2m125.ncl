 var      = "fcst_phy2m125"
 indir    = "/Reanalysis/JRA55/grb/Hist/daily/"+var
 oudir    = "./NC"
 syr      = 2018
 eyr      = 2018
 smo      = 8
 emo      = 8
 edy      = (/31,28,31,30,31,30,31,31,30,31,30,31/)
 shr      = 0
 ehr      = 21
 ihr      = 3
 nhr      = (ehr- shr)/ihr + 1
 VAR      = (/"CPRATsfc","CSDLFsfc","CSDSFsfc","CSULFtoa","CSUSFsfc","CSUSFtoa","DLWRFsfc","DSWRFsfc","DSWRFtoa","EVPsfc","FGLUsfc","FGLVsfc","FGSUsfc","FGSVsfc","LHTFLsfc","LPRATsfc","PRESsfc","SHTFLsfc","SRWEQsfc","TPRATsfc","UFLXsfc","ULWRFsfc","ULWRFtoa","USWRFsfc","USWRFtoa","VFLXsfc"/)
 VAR2     = (/"PRESsfc","EVPsfc","TPRATsfc","LPRATsfc","CPRATsfc","SRWEQsfc","LHTFLsfc","SHTFLsfc","UFLXsfc","VFLXsfc","FGLUsfc","FGLVsfc","FGSVsfc","FGSUsfc","CSUSFsfc","CSUSFtoa","CSDSFsfc","CSULFtoa","CSDLFsfc","DSWRFsfc","DSWRFtoa","DLWRFsfc","USWRFsfc","USWRFtoa","ULWRFsfc","ULWRFtoa"/)
;iVAR     = (/4,18,16,17,14,15,21,19,20,1,10,11,13,12,6,3,0,7,5,2,8,24,25,22,23,9/)
 nvar     = dimsizes(VAR)
 nlat     = 145
 nlon     = 288
 lat      = fspan(-90,90,nlat)
 lon      = fspan(0,358.75,nlon)
 missing  = 1e+20
 dunits   = "hours since 1-1-1 00:00:0.0"

 do yr = syr, eyr
  yyyy = sprinti("%0.4i",yr)
  do mo = smo, emo
   mm    = sprinti("%0.2i",mo)
   yymm  = yyyy+mm

;***********************************************
; new data 1
;*********************************************** 
   if ( yr%4.eq.0 .and. yr%100.ne.0 .or. yr%400.eq.0 ) then
    edy(1) = 29
   else
    edy(1) = 28
   end if

   dat  = new((/nvar,edy(mo-1),nlat,nlon/),float,missing)
   date = new(edy(mo-1),double)
   k=0
   do dy = 1, edy(mo-1)
    dd = sprinti("%0.2i",dy)

;***********************************************
; new data 2
;*********************************************** 
    dat_hr = new((/nvar,nhr,nlat,nlon/),float,missing)

    kk=0    
    do hr = shr, ehr, ihr 
     hh       = sprinti("%0.2i",hr)
     yymmddhh = yyyy+mm+dd+hh
     fname    = var+"."+yymmddhh

;***********************************************
; get variable names from grib file
;***********************************************
     infil   = systemfunc("ls "+indir+"/"+fname)
     grib_in = addfile(infil,"r")
     names   = getfilevarnames(grib_in)

;***********************************************
; read
;***********************************************
     do i = 0, nvar-1  
      do ii = 0, nvar-1
       if ( VAR2(i) .eq. VAR(ii) ) then
        iv = ii
       end if
      end do

      dat_hr(iv,kk,:,:) = grib_in->$names(i)$(::-1,:)
     end do ; i

     kk=kk+1
    end do ; hr

;***********************************************
; make daily (average)
;***********************************************
    dat_hr!0     = "VAR"
    dat_hr!1     = "hour"
    dat_hr&VAR   = VAR
    dat_hr&hour  = ispan(shr,ehr,ihr)
    dat(:,k,:,:) = dim_avg_n_Wrap(dat_hr,1)
    date(k)      = ut_inv_calendar(yr,mo,dy,0,0,0,dunits,0)
    delete(dat_hr)

    k=k+1
   end do ; dy

;***********************************************
; attributes
;***********************************************
   delete(dat@initial_time)
   dat!1                       = "time"
   dat!2                       = "lat"
   dat!3                       = "lon"
   dat&time                    = date
   dat&lat                     = lat
   dat&lon                     = lon

   dat&time@axis               = "T"
   dat&time@standard_name      = "time"
   dat&time@long_name          = "Time coordinate"
   delete(dat&time@_FillValue)

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
; create output netcdf file
;*********************************************** 
   oufil    = oudir+"/"+var+".day."+yymm+".nc"
   system("rm -rf "+oufil)                 ; remove any pre-existing file
   print(oufil)
   ncdf_out = addfile(oufil ,"c")          ; create output netCDF file

;***********************************************
; loop through variables and output each to netcdf
;***********************************************
   filedimdef(ncdf_out,"time",-1,True)
   do iv = 0, nvar-1
    if ( VAR(iv).eq."CPRATsfc" ) then
     longname = "surface Convective precipitation"
     units    = "mm/day"
    end if
    if ( VAR(iv).eq."CSDLFsfc" ) then
     longname = "surface Clear sky downward long wave radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."CSDSFsfc" ) then
     longname = "surface Clear sky downward solar radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."CSULFtoa" ) then
     longname = "top of atmos Clear sky upward long wave radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."CSUSFsfc" ) then
     longname = "surface Clear sky upward solar radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."CSUSFtoa" ) then
     longname = "top of atmos Clear sky upward solar radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."DLWRFsfc" ) then
     longname = "surface Downward long wave radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."DSWRFsfc" ) then
     longname = "surface Downward solar radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."DSWRFtoa" ) then
     longname = "top of atmos Downward solar radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."EVPsfc"   ) then
     longname = "surface Evaporation"
     units    = "mm/day"
    end if
    if ( VAR(iv).eq."FGLUsfc"  ) then
     longname = "surface Zonal momentum flux by long gravity wave"
     units    = "N/m^2"
    end if
    if ( VAR(iv).eq."FGLVsfc"  ) then
     longname = "surface Meridional momentum flux by long gravity wave"
     units    = "N/m^2"
    end if
    if ( VAR(iv).eq."FGSUsfc"  ) then
     longname = "surface Zonal momentum flux by short gravity wave"
     units    = "N/m^2"
    end if
    if ( VAR(iv).eq."FGSVsfc"  ) then
     longname = "surface Meridional momentum flux by short gravity wave"
     units    = "N/m^2"
    end if
    if ( VAR(iv).eq."LHTFLsfc" ) then
     longname = "surface Latent heat flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."LPRATsfc" ) then
     longname = "surface Large scale precipitation"
     units    = "mm/day"
    end if
    if ( VAR(iv).eq."PRESsfc"  ) then
     longname = "surface Pressure"
     units    = "Pa"
    end if
    if ( VAR(iv).eq."SHTFLsfc" ) then
     longname = "surface Sensible heat flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."SRWEQsfc" ) then
     longname = "surface Snowfall rate water equivalent"
     units    = "mm/day"
    end if
    if ( VAR(iv).eq."TPRATsfc" ) then
     longname = "surface Total precipitation"
     units    = "mm/day"
    end if
    if ( VAR(iv).eq."UFLXsfc"  ) then
     longname = "surface Momentum flux, u-component"
     units    = "N/m^2"
    end if
    if ( VAR(iv).eq."ULWRFsfc" ) then
     longname = "surface Upward long wave radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."ULWRFtoa" ) then
     longname = "top of atmos Upward long wave radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."USWRFsfc" ) then
     longname = "surface Upward solar radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."USWRFtoa" ) then
     longname = "top of atmos Upward solar radiation flux"
     units    = "W/m^2"
    end if
    if ( VAR(iv).eq."VFLXsfc"  ) then
     longname = "surface Momentum flux, v-component"
     units    = "N/m^2"
    end if

    dati               = dat(iv,:,:,:)
    dati@long_name     = longname
    dati@units         = units
    delete(dati@VAR)

;   printVarSummary(dati)
    ncdf_out->$VAR(iv)$ = dati
    delete(dati)
   end do ; iv

   delete([/dat,date/])
  end do ; mo
 end do ; yr
