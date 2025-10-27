begin
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

f=addfile(dir1+"pco2_SOCAT_2010-2021.nc","r")
p_co2=f->fco2_ave_weighted
lon_socat=f->xlon
lat_socat=f->ylat
p_co2_for_oda=f->fco2_ave_weighted(60:,:,:)
clim_co2=clmMonTLL(p_co2)
co2_socat=calcMonAnomTLL(p_co2,clim_co2)
dim_socat=dimsizes(co2_socat)

clim_co2_for_oda=clmMonTLL(p_co2_for_oda)
co2_socat_for_oda=calcMonAnomTLL(p_co2_for_oda,clim_co2_for_oda)

g1=addfile(dir3+"pco2surf.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
pco2_oda=g1->pco2surf
lon_oda=g1->lon
lat_oda=g1->lat
clim_co2_oda=clmMonTLL(pco2_oda)
co2_oda=calcMonAnomTLL(pco2_oda,clim_co2_oda)
dim_oda=dimsizes(co2_oda)

g2=addfile(dir4+"pco2surf.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
pco2_aoda=g2->pco2surf
lon_aoda=g2->lon
lat_aoda=g2->lat
clim_co2_aoda=clmMonTLL(pco2_aoda)
co2_aoda=calcMonAnomTLL(pco2_aoda,clim_co2_aoda)
dim_aoda=dimsizes(co2_aoda)

;----- 3 months moving-------------------------------------------------------------
 p=3;chunck period
 tp=dim_oda(0)-p+1;total period after moving averaged
 co2_oda_mv_3=new((/tp,dim_oda(1),dim_oda(2)/),"float"); Target
 co2_socat_for_oda_mv_3=new((/tp,dim_socat(1),dim_socat(2)/),"float")
 imsi=new((/p,dim_oda(1),dim_oda(2)/),"float"); Chunck
 imsi1=new((/p,dim_socat(1),dim_socat(2)/),"float"); Chunck
  do k=0,tp-1
   imsi(:,:,:)=co2_oda(k:k+p-1,:,:)
   imsi1(:,:,:)=co2_socat_for_oda(k:k+p-1,:,:)
   co2_oda_mv_3(k,:,:)=dim_avg_n_Wrap(imsi,0)
   co2_socat_for_oda_mv_3(k,:,:)=dim_avg_n_Wrap(imsi1,0)
   imsi=imsi@_FillValue
   imsi1=imsi1@_FillValue
  end do
 co2_oda_mv_3!0="time"
 co2_socat_for_oda_mv_3!0="time"
delete([/imsi,imsi1/])
system("rm -f "+dir1+"co2_ODA_3moving_ano_2015-2021.nc")
out=addfile(    dir1+"co2_ODA_3moving_ano_2015-2021.nc","c")
out->co2=co2_oda_mv_3
out->lon=lon_oda
out->lat=lat_oda
system("rm -f "+dir1+"co2_SOCAT_3moving_ano_2015-2021.nc")
out=addfile(    dir1+"co2_SOCAT_3moving_ano_2015-2021.nc","c")
out->co2=co2_socat_for_oda_mv_3
out->lon=lon_socat
out->lat=lat_socat
;-------------------------------------------------------------------------------------
 tp=dim_aoda(0)-p+1;total period after moving averaged
 co2_aoda_mv_3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 co2_socat_mv_3=new((/tp,dim_socat(1),dim_socat(2)/),"float"); Target
 imsi1=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi2=new((/p,dim_socat(1),dim_socat(2)/),"float"); Chunck
  do k=0,tp-1
   imsi1(:,:,:)=co2_aoda(k:k+p-1,:,:)
   co2_aoda_mv_3(k,:,:)=dim_avg_n_Wrap(imsi1,0)
   imsi1=imsi1@_FillValue

   imsi2(:,:,:)=co2_socat(k:k+p-1,:,:)
   co2_socat_mv_3(k,:,:)=dim_avg_n_Wrap(imsi2,0)
   imsi2=imsi2@_FillValue

  end do
 co2_aoda_mv_3!0="time"
 co2_socat_mv_3!0="time"

system("rm -f "+dir1+"co2_AODA_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"co2_AODA_3moving_ano_2010-2021.nc","c")
out->co2=co2_aoda_mv_3
out->lon=lon_aoda
out->lat=lat_aoda

system("rm -f "+dir1+"co2_SOCAT_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"co2_SOCAT_3moving_ano_2010-2021.nc","c")
out->co2=co2_socat_mv_3
out->lon=lon_socat
out->lat=lat_socat


end
