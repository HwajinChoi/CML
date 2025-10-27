begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

f1=addfile(dir3+"chl.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
chl_aoda=f1->chl(:,0,:,:)
lon_aoda=f1->lon
lat_aoda=f1->lat

chl_aoda_clim=clmMonTLL(chl_aoda)
chl_aoda_ano=calcMonAnomTLL(chl_aoda,chl_aoda_clim)

f2=addfile(dir2+"chl.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
chl_oda=f2->chl(:,0,:,:)

chl_oda_clim=clmMonTLL(chl_oda)
chl_oda_ano=calcMonAnomTLL(chl_oda,chl_oda_clim)

g2=addfile(dir1+"CHL_201001-202112.nc","r")
chl_sa=g2->chlor_a
lon_sa=g2->lon
lat_sa=g2->lat

chl_sa_clim=clmMonTLL(chl_sa)
chl_sa_ano=calcMonAnomTLL(chl_sa,chl_sa_clim)

dim_oda=dimsizes(chl_oda_ano)
dim_aoda=dimsizes(chl_aoda_ano)
;----- 3 months moving-------------------------------------------------------------
 p=3;chunck period
 tp=dim_aoda(0)-p+1;total period after moving averaged
 chl_aoda_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 chl_sa_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target

 imsi1=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi2=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck

  do k=0,tp-1
   imsi1(:,:,:)=chl_aoda_ano(k:k+p-1,:,:)
   chl_aoda_mv3(k,:,:)=dim_avg_n_Wrap(imsi1,0)
   imsi1=imsi1@_FillValue

   imsi2(:,:,:)=chl_sa_ano(k:k+p-1,:,:)
   chl_sa_mv3(k,:,:)=dim_avg_n_Wrap(imsi2,0)
   imsi2=imsi2@_FillValue
  end do

 chl_aoda_mv3!0="time"
 chl_sa_mv3!0="time"

delete([/tp,imsi1,imsi2/])
system("rm -f "+dir1+"chl_AODA_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"chl_AODA_3moving_ano_2010-2021.nc","c")
out->chl_aoda_mv3=chl_aoda_mv3
out->lat=lat_aoda
out->lon=lon_aoda

system("rm -f "+dir1+"chl_satellite_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"chl_satellite_3moving_ano_2010-2021.nc","c")
out->chl_sa_mv3=chl_sa_mv3
out->lat=lat_sa
out->lon=lon_sa
;-------------------------------------------------------------------------------------
tp=dim_oda(0)-p+1;total period after moving averaged
chl_oda_mv3=new((/tp,dim_oda(1),dim_oda(2)/),"float"); Target

imsi1=new((/p,dim_oda(1),dim_oda(2)/),"float"); Chunck

 do k=0,tp-1
  imsi1(:,:,:)=chl_oda_ano(k:k+p-1,:,:)
  chl_oda_mv3(k,:,:)=dim_avg_n_Wrap(imsi1,0)
  imsi1=imsi1@_FillValue
 end do

chl_oda_mv3!0="time"

system("rm -f "+dir1+"chl_ODA_3moving_ano_2015-2021.nc")
out=addfile(    dir1+"chl_ODA_3moving_ano_2015-2021.nc","c")
out->chl_oda_mv3=chl_oda_mv3
out->lat=lat_aoda
out->lon=lon_aoda

end 
