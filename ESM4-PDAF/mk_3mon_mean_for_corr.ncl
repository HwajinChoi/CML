begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/EN4/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

f1=addfile(dir1+"EN.4.2.2.r360x180.temperature_201001-202112.nc","r")
en4_temp_surf=f1->temperature(:,0,:,:)
en4_temp_sub0=f1->temperature(:,{0:300},:,:)
en4_temp_sub=dim_avg_n_Wrap(en4_temp_sub0,1)
lon_en4=f1->lon
lat_en4=f1->lat

en4_temp_surf_clim=clmMonTLL(en4_temp_surf)
en4_temp_sub_clim=clmMonTLL(en4_temp_sub)
temp_surf_en4_ano=calcMonAnomTLL(en4_temp_surf,en4_temp_surf_clim)
temp_sub_en4_ano=calcMonAnomTLL(en4_temp_sub,en4_temp_sub_clim)

f2=addfile(dir1+"EN.4.2.2.r360x180.salinity_201001-202112.nc","r")
en4_sal_surf=f2->salinity(:,0,:,:)
en4_sal_sub0=f2->salinity(:,{0:300},:,:)
en4_sal_sub=dim_avg_n_Wrap(en4_sal_sub0,1)

en4_sal_surf_clim=clmMonTLL(en4_sal_surf)
en4_sal_sub_clim=clmMonTLL(en4_sal_sub)
sal_surf_en4_ano=calcMonAnomTLL(en4_sal_surf,en4_sal_surf_clim)
sal_sub_en4_ano=calcMonAnomTLL(en4_sal_sub,en4_sal_sub_clim)

g2=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
so_oda_surf=g2->so(:,0,:,:)
so_oda_sub0=g2->so(:,{0:300},:,:)
so_oda_sub=dim_avg_n_Wrap(so_oda_sub0,1)
lon_oda=g2->lon
lat_oda=g2->lat

oda_so_surf_clim=clmMonTLL(so_oda_surf)
oda_so_sub_clim=clmMonTLL(so_oda_sub)
so_surf_oda_ano=calcMonAnomTLL(so_oda_surf,oda_so_surf_clim)
so_sub_oda_ano=calcMonAnomTLL(so_oda_sub,oda_so_sub_clim)

h2=addfile(dir3+"so.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
so_aoda_surf=h2->so(:,0,:,:)
so_aoda_sub0=h2->so(:,{0:300},:,:)
so_aoda_sub=dim_avg_n_Wrap(so_aoda_sub0,1)
lon_aoda=h2->lon
lat_aoda=h2->lat
aoda_so_surf_clim=clmMonTLL(so_aoda_surf)
aoda_so_sub_clim=clmMonTLL(so_aoda_sub)
so_surf_aoda_ano=calcMonAnomTLL(so_aoda_surf,aoda_so_surf_clim)
so_sub_aoda_ano=calcMonAnomTLL(so_aoda_sub,aoda_so_sub_clim)

g1=addfile(dir2+"thetao.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
thetao_oda_sub0=g1->thetao(:,{0:300},:,:)
thetao_oda_sub=dim_avg_n_Wrap(thetao_oda_sub0,1)
oda_temp_sub_clim=clmMonTLL(thetao_oda_sub)
temp_sub_oda_ano=calcMonAnomTLL(thetao_oda_sub,oda_temp_sub_clim)

h1=addfile(dir3+"thetao.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
thetao_aoda_sub0=h1->thetao(:,{0:300},:,:)
thetao_aoda_sub=dim_avg_n_Wrap(thetao_aoda_sub0,1)
aoda_temp_sub_clim=clmMonTLL(thetao_aoda_sub)
temp_sub_aoda_ano=calcMonAnomTLL(thetao_aoda_sub,aoda_temp_sub_clim)

dim_oda=dimsizes(thetao_oda_sub)
dim_aoda=dimsizes(thetao_aoda_sub)
;----- 3 months moving-------------------------------------------------------------
 p=3;chunck period
 tp=dim_aoda(0)-p+1;total period after moving averaged
 temp_surf_en4_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 temp_sub_en4_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 so_surf_aoda_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 so_sub_aoda_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 temp_sub_aoda_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 sal_surf_en4_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 sal_sub_en4_mv3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target

 imsi1=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi2=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi3=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi4=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi5=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi6=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi7=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck

  do k=0,tp-1
   imsi1(:,:,:)=temp_surf_en4_ano(k:k+p-1,:,:)
   temp_surf_en4_mv3(k,:,:)=dim_avg_n_Wrap(imsi1,0)
   imsi1=imsi1@_FillValue

   imsi2(:,:,:)=temp_sub_en4_ano(k:k+p-1,:,:)
   temp_sub_en4_mv3(k,:,:)=dim_avg_n_Wrap(imsi2,0)
   imsi2=imsi2@_FillValue

   imsi3(:,:,:)=so_surf_aoda_ano(k:k+p-1,:,:)
   so_surf_aoda_mv3(k,:,:)=dim_avg_n_Wrap(imsi3,0)
   imsi3=imsi3@_FillValue

   imsi4(:,:,:)=so_sub_aoda_ano(k:k+p-1,:,:)
   so_sub_aoda_mv3(k,:,:)=dim_avg_n_Wrap(imsi4,0)
   imsi4=imsi4@_FillValue

   imsi5(:,:,:)=temp_sub_aoda_ano(k:k+p-1,:,:)
   temp_sub_aoda_mv3(k,:,:)=dim_avg_n_Wrap(imsi5,0)
   imsi5=imsi5@_FillValue

   imsi6(:,:,:)=sal_surf_en4_ano(k:k+p-1,:,:)
   sal_surf_en4_mv3(k,:,:)=dim_avg_n_Wrap(imsi6,0)
   imsi6=imsi6@_FillValue

   imsi7(:,:,:)=sal_sub_en4_ano(k:k+p-1,:,:)
   sal_sub_en4_mv3(k,:,:)=dim_avg_n_Wrap(imsi7,0)
   imsi7=imsi7@_FillValue
  end do

 temp_surf_en4_mv3!0="time"
 temp_sub_en4_mv3!0="time"
 so_surf_aoda_mv3!0="time"
 so_sub_aoda_mv3!0="time"
 temp_sub_aoda_mv3!0="time"
 sal_surf_en4_mv3!0="time"
 sal_sub_en4_mv3!0="time"

delete([/tp,imsi1,imsi2,imsi3,imsi4,imsi5/])
system("rm -f "+dir1+"temp_sal_EN4_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"temp_sal_EN4_3moving_ano_2010-2021.nc","c")
out->temp_surf_en4_mv3=temp_surf_en4_mv3
out->temp_sub_en4_mv3=temp_sub_en4_mv3
out->sal_surf_en4_mv3=sal_surf_en4_mv3
out->sal_sub_en4_mv3=sal_sub_en4_mv3
out->lat=lat_en4
out->lon=lon_en4
;-------------------------------------------------------------------------------------

tp=dim_oda(0)-p+1;total period after moving averaged
temp_sub_oda_mv3=new((/tp,dim_oda(1),dim_oda(2)/),"float"); Target
so_surf_oda_mv3=new((/tp,dim_oda(1),dim_oda(2)/),"float"); Target
so_sub_oda_mv3=new((/tp,dim_oda(1),dim_oda(2)/),"float"); Target

imsi1=new((/p,dim_oda(1),dim_oda(2)/),"float"); Chunck
imsi2=new((/p,dim_oda(1),dim_oda(2)/),"float"); Chunck
imsi3=new((/p,dim_oda(1),dim_oda(2)/),"float"); Chunck

 do k=0,tp-1
  imsi1(:,:,:)=temp_sub_oda_ano(k:k+p-1,:,:)
  temp_sub_oda_mv3(k,:,:)=dim_avg_n_Wrap(imsi1,0)
  imsi1=imsi1@_FillValue

  imsi2(:,:,:)=so_sub_oda_ano(k:k+p-1,:,:)
  so_sub_oda_mv3(k,:,:)=dim_avg_n_Wrap(imsi2,0)
  imsi2=imsi2@_FillValue

  imsi3(:,:,:)=so_surf_oda_ano(k:k+p-1,:,:)
  so_surf_oda_mv3(k,:,:)=dim_avg_n_Wrap(imsi3,0)
  imsi3=imsi3@_FillValue
 end do

temp_sub_oda_mv3!0="time"
so_sub_oda_mv3!0="time"
so_surf_oda_mv3!0="time"

system("rm -f "+dir1+"temp_so_AODA_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"temp_so_AODA_3moving_ano_2010-2021.nc","c")
out->temp_sub_aoda_mv3=temp_sub_aoda_mv3
out->so_surf_aoda_mv3=so_surf_aoda_mv3
out->so_sub_aoda_mv3=so_sub_aoda_mv3
out->lat=lat_aoda
out->lon=lon_aoda

system("rm -f "+dir1+"temp_so_ODA_3moving_ano_2015-2021.nc")
out=addfile(    dir1+"temp_so_ODA_3moving_ano_2015-2021.nc","c")
out->temp_sub_oda_mv3=temp_sub_oda_mv3
out->so_surf_oda_mv3=so_surf_oda_mv3
out->so_sub_oda_mv3=so_sub_oda_mv3
out->lat=lat_oda
out->lon=lon_oda

end 
