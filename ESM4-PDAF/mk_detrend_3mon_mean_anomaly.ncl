begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

g1=addfile(dir2+"tos.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
tos_oda0=g1->tos
lon_oda=g1->lon
lat_oda=g1->lat
time_1521=g1->time
dim_oda=dimsizes(tos_oda0)
clim_oda=clmMonTLL(tos_oda0)
tos_oda=calcMonAnomTLL(tos_oda0,clim_oda)

g2=addfile(dir3+"tos.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
tos_aoda0=g2->tos
lon_aoda=g2->lon
lat_aoda=g2->lat
time_1021=g2->time
dim_aoda=dimsizes(tos_aoda0)
clim_aoda=clmMonTLL(tos_aoda0)
tos_aoda=calcMonAnomTLL(tos_aoda0,clim_aoda)

f1=addfile(dir1+"ECDA/sst_ATMassim_10NS_100err_WOA_0.1_2nd.201001-201712.nc","r")
tos_ecda0=f1->sst
lon_ecda=f1->xt_ocean
lat_ecda=f1->yt_ocean
time_1017=f1->time
dim_ecda=dimsizes(tos_ecda0)
clim_ecda=clmMonTLL(tos_ecda0)
tos_ecda=calcMonAnomTLL(tos_ecda0,clim_ecda)

f2=addfile(dir1+"GODAS/pottmp.2010-2021.nc","r")
tos_godas0=f2->pottmp(:,0,:,:)
lon_godas=f2->lon
lat_godas=f2->lat
dim_godas=dimsizes(tos_godas0)
clim_godas=clmMonTLL(tos_godas0)
tos_godas=calcMonAnomTLL(tos_godas0,clim_godas)

f3=addfile(dir1+"ECCO/THETA_ECCO_r360x180_201001-201712.nc","r")
tos_ecco0=f3->THETA(:,0,:,:)
lon_ecco=f3->lon
lat_ecco=f3->lat
dim_ecco=dimsizes(tos_ecco0)
clim_ecco=clmMonTLL(tos_ecco0)
tos_ecco=calcMonAnomTLL(tos_ecco0,clim_ecco)

f4=addfile(dir1+"SODA/temp.soda3.15.2_r360x180_2010-2021.nc","r")
tos_soda0=f4->temp(:,0,:,:)
lon_soda=f4->lon
lat_soda=f4->lat
dim_soda=dimsizes(tos_soda0)
clim_soda=clmMonTLL(tos_soda0)
tos_soda=calcMonAnomTLL(tos_soda0,clim_soda)

;----- 3 months moving-------------------------------------------------------------
 p=3;chunck period
 tp=dim_oda(0)-p+1;total period after moving averaged
 tos_oda_mv_3=new((/tp,dim_oda(1),dim_oda(2)/),"float"); Target
 imsi=new((/p,dim_oda(1),dim_oda(2)/),"float"); Chunck
  do k=0,tp-1
   imsi(:,:,:)=tos_oda(k:k+p-1,:,:)
   tos_oda_mv_3(k,:,:)=dim_avg_n_Wrap(imsi,0)
   imsi=imsi@_FillValue
  end do
 tos_oda_mv_3!0="time"

tos_oda_mv=dtrend_msg_n(time_1521(1:82),tos_oda_mv_3,False,False,0)
copy_VarMeta(tos_oda_mv_3,tos_oda_mv)

system("rm -f "+dir1+"tos_detrend_ODA_3moving_ano_2015-2021.nc")
out=addfile(    dir1+"tos_detrend_ODA_3moving_ano_2015-2021.nc","c")
out->tos=tos_oda_mv
out->lon=lon_oda
out->lat=lat_oda
;-------------------------------------------------------------------------------------
 tp=dim_aoda(0)-p+1;total period after moving averaged
 tos_aoda_mv_3=new((/tp,dim_aoda(1),dim_aoda(2)/),"float"); Target
 tos_godas_mv_3=new((/tp,dim_godas(1),dim_godas(2)/),"float"); Target
 tos_soda_mv_3=new((/tp,dim_soda(1),dim_soda(2)/),"float"); Target
 imsi1=new((/p,dim_aoda(1),dim_aoda(2)/),"float"); Chunck
 imsi2=new((/p,dim_godas(1),dim_godas(2)/),"float"); Chunck
 imsi3=new((/p,dim_soda(1),dim_soda(2)/),"float"); Chunck
  do k=0,tp-1
   imsi1(:,:,:)=tos_aoda(k:k+p-1,:,:)
   tos_aoda_mv_3(k,:,:)=dim_avg_n_Wrap(imsi1,0)
   imsi1=imsi1@_FillValue

   imsi2(:,:,:)=tos_godas(k:k+p-1,:,:)
   tos_godas_mv_3(k,:,:)=dim_avg_n_Wrap(imsi2,0)
   imsi2=imsi2@_FillValue

   imsi3(:,:,:)=tos_soda(k:k+p-1,:,:)
   tos_soda_mv_3(k,:,:)=dim_avg_n_Wrap(imsi3,0)
   imsi3=imsi3@_FillValue
  end do
 tos_aoda_mv_3!0="time"
 tos_godas_mv_3!0="time"
 tos_soda_mv_3!0="time"
delete(imsi1)

tos_aoda_mv=dtrend_msg_n(time_1021(1:142),tos_aoda_mv_3,False,False,0)
copy_VarMeta(tos_aoda_mv_3,tos_aoda_mv)

tos_godas_mv=dtrend_msg_n(time_1021(1:142),tos_godas_mv_3,False,False,0)
copy_VarMeta(tos_godas_mv_3,tos_godas_mv)

tos_soda_mv=dtrend_msg_n(time_1021(1:142),tos_soda_mv_3,False,False,0)
copy_VarMeta(tos_soda_mv_3,tos_soda_mv)

system("rm -f "+dir1+"tos_detrend_AODA_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"tos_detrend_AODA_3moving_ano_2010-2021.nc","c")
out->tos=tos_aoda_mv
out->lon=lon_aoda
out->lat=lat_aoda

system("rm -f "+dir1+"tos_detrend_GODAS_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"tos_detrend_GODAS_3moving_ano_2010-2021.nc","c")
out->tos=tos_godas_mv
out->lon=lon_godas
out->lat=lat_godas

system("rm -f "+dir1+"tos_detrend_SODA_3moving_ano_2010-2021.nc")
out=addfile(    dir1+"tos_detrend_SODA_3moving_ano_2010-2021.nc","c")
out->tos=tos_soda_mv
out->lon=lon_soda
out->lat=lat_soda
;-------------------------------------------------------------------------------------
 tp=dim_ecda(0)-p+1;total period after moving averaged
 tos_ecda_mv_3=new((/tp,dim_ecda(1),dim_ecda(2)/),"float"); Target
 tos_ecco_mv_3=new((/tp,dim_ecco(1),dim_ecco(2)/),"float"); Target
 imsi=new((/p,dim_ecda(1),dim_ecda(2)/),"float"); Chunck
 imsi1=new((/p,dim_ecco(1),dim_ecco(2)/),"float"); Chunck
  do k=0,tp-1
   imsi(:,:,:)=tos_ecda(k:k+p-1,:,:)
   tos_ecda_mv_3(k,:,:)=dim_avg_n_Wrap(imsi,0)
   imsi=imsi@_FillValue

   imsi1(:,:,:)=tos_ecco(k:k+p-1,:,:)
   tos_ecco_mv_3(k,:,:)=dim_avg_n_Wrap(imsi1,0)
   imsi1=imsi1@_FillValue
  end do
 tos_ecda_mv_3!0="time"
 tos_ecco_mv_3!0="time"
tos_ecda_mv=dtrend_msg_n(time_1017(1:94),tos_ecda_mv_3,False,False,0)
copy_VarMeta(tos_ecda_mv_3,tos_ecda_mv)
 
tos_ecco_mv=dtrend_msg_n(time_1017(1:94),tos_ecco_mv_3,False,False,0)
copy_VarMeta(tos_ecco_mv_3,tos_ecco_mv)

system("rm -f "+dir1+"tos_detrend_ECDA_3moving_ano_2010-2017.nc")
out=addfile(    dir1+"tos_detrend_ECDA_3moving_ano_2010-2017.nc","c")
out->tos=tos_ecda_mv
out->lon=lon_ecda
out->lat=lat_ecda

system("rm -f "+dir1+"tos_detrend_ECCO_3moving_ano_2010-2017.nc")
out=addfile(    dir1+"tos_detrend_ECCO_3moving_ano_2010-2017.nc","c")
out->tos=tos_ecco_mv
out->lon=lon_ecco
out->lat=lat_ecco

end
