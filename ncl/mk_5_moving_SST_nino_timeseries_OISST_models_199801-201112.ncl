begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir3="/media/cmlws/Data2/hjc/image/"
dir4="/media/cmlws/Data2/hjc/NEMO/r4.0.6/output_pro/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3 (5N-5S, 150W-90W)-----------------------------------------------------------------------
nino3_lon_min=-150
nino3_lon_max=-90
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;-----------------NINO4 (5N-5S, 160E-150W); It is neended to lonflip--------------------------------------------
nino4_lon_min=160
nino4_lon_max=210
;-------------------------------------------OISST-------------------------------------------
f=addfile(dir1+"oisst-avhrr-v02r01.r180x90.199801-201112.nc","r")
sst=f->sst(:,0,{lat_min:lat_max},:)
oisst = short2flt(sst)
oisst_lonflip = lonFlip(oisst)
lat_oisst=f->lat({lat_min:lat_max})
lon_oisst=f->lon
rad    = 4.0*atan(1.0)/180.0
clat1   = cos(lat_oisst*rad)
;--------------------------------------------------------------------------------------------
oisst_nino3=oisst(:,:,{nino3_lon_min:nino3_lon_max})
oisst_nino34=oisst(:,:,{nino34_lon_min:nino34_lon_max})
oisst_nino4=oisst_lonflip(:,:,{nino4_lon_min:nino4_lon_max})

oisst_nino3_wgt = wgt_areaave_Wrap(oisst_nino3,clat1,1.0,1)
oisst_nino34_wgt = wgt_areaave_Wrap(oisst_nino34,clat1,1.0,1)
oisst_nino4_wgt = wgt_areaave_Wrap(oisst_nino4,clat1,1.0,1)
oisst_nino3_wgt!0="time_counter"
oisst_nino34_wgt!0="time_counter"
oisst_nino4_wgt!0="time_counter"
;---------------------------------------------------------------------------------------------
g2=addfile(dir2+"tos_regrid_clim_199710-201112.nc","r")
tos_clim=g2->tos(3:170,{lat_min:lat_max},:)
lon_nemo=g2->lon
lat_nemo=g2->lat({lat_min:lat_max})
tos_clim_lonflip = lonFlip(tos_clim)
clat2   = cos(lat_nemo*rad)
time=g2->time_counter(3:170)
time!0="time"
tos_clim_nino3=tos_clim(:,:,{nino3_lon_min:nino3_lon_max})
tos_clim_nino34=tos_clim(:,:,{nino34_lon_min:nino34_lon_max})
tos_clim_nino4=tos_clim_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
tos_clim_nino3_wgt = wgt_areaave_Wrap(tos_clim_nino3,clat2,1.0,1)
tos_clim_nino34_wgt = wgt_areaave_Wrap(tos_clim_nino34,clat2,1.0,1)
tos_clim_nino4_wgt = wgt_areaave_Wrap(tos_clim_nino4,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h1=addfile(dir2+"tos_regrid_const_199710-201112.nc","r")
tos_const=h1->tos(3:170,{lat_min:lat_max},:)
tos_const_lonflip = lonFlip(tos_const)
tos_const_nino3=tos_const(:,:,{nino3_lon_min:nino3_lon_max})
tos_const_nino34=tos_const(:,:,{nino34_lon_min:nino34_lon_max})
tos_const_nino4=tos_const_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
tos_const_nino3_wgt = wgt_areaave_Wrap(tos_const_nino3,clat2,1.0,1)
tos_const_nino34_wgt = wgt_areaave_Wrap(tos_const_nino34,clat2,1.0,1)
tos_const_nino4_wgt = wgt_areaave_Wrap(tos_const_nino4,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h2=addfile(dir2+"tos_regrid_inter_199710-201112.nc","r")
tos_inter=h2->tos(3:170,{lat_min:lat_max},:)
tos_inter_lonflip = lonFlip(tos_inter)
tos_inter_nino3=tos_inter(:,:,{nino3_lon_min:nino3_lon_max})
tos_inter_nino34=tos_inter(:,:,{nino34_lon_min:nino34_lon_max})
tos_inter_nino4=tos_inter_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
tos_inter_nino3_wgt = wgt_areaave_Wrap(tos_inter_nino3,clat2,1.0,1)
tos_inter_nino34_wgt = wgt_areaave_Wrap(tos_inter_nino34,clat2,1.0,1)
tos_inter_nino4_wgt = wgt_areaave_Wrap(tos_inter_nino4,clat2,1.0,1)

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
dim=dimsizes(tos_const)
;----------- For moving average ------------------------------------
y=5 ; moving year
p=y*12;chunck period
tp=dim(0)-p+1;total period after moving averaged 
;----------------------------------area average------------------------------------------------
SST_nino3_wgt=new((/4,dim(0)/),"float")
SST_nino3_wgt(0,:)=oisst_nino3_wgt
SST_nino3_wgt(1,:)=tos_clim_nino3_wgt
SST_nino3_wgt(2,:)=tos_const_nino3_wgt
SST_nino3_wgt(3,:)=tos_inter_nino3_wgt
SST_nino3_wgt!0="data"
;-----------------------------------------------
sst_nino3_mv=new((/4,tp/),"float"); Target
imsi=new((/4,p/),"float"); Chunck 
 do k=0,tp-1
  imsi(:,:)=SST_nino3_wgt(:,k:k+p-1)
  sst_nino3_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino3_mv!1="time"
sst_nino3_mv&time=time(0:tp-1)
;----------------------------------area average------------------------------------------------
SST_nino34_wgt=new((/4,dim(0)/),"float")
SST_nino34_wgt(0,:)=oisst_nino34_wgt
SST_nino34_wgt(1,:)=tos_clim_nino34_wgt
SST_nino34_wgt(2,:)=tos_const_nino34_wgt
SST_nino34_wgt(3,:)=tos_inter_nino34_wgt
SST_nino34_wgt!0="data"
;-----------------------------------------------
sst_nino34_mv=new((/4,tp/),"float"); Target
 do k=0,tp-1
  imsi(:,:)=SST_nino34_wgt(:,k:k+p-1)
  sst_nino34_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino34_mv!1="time"
sst_nino34_mv&time=time(0:tp-1)
;----------------------------------area average------------------------------------------------
SST_nino4_wgt=new((/4,dim(0)/),"float")
SST_nino4_wgt(0,:)=oisst_nino4_wgt
SST_nino4_wgt(1,:)=tos_clim_nino4_wgt
SST_nino4_wgt(2,:)=tos_const_nino4_wgt
SST_nino4_wgt(3,:)=tos_inter_nino4_wgt
SST_nino4_wgt!0="data"
;-----------------------------------------------
sst_nino4_mv=new((/4,tp/),"float"); Target
 do k=0,tp-1
  imsi(:,:)=SST_nino4_wgt(:,k:k+p-1)
  sst_nino4_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino4_mv!1="time"
sst_nino4_mv&time=time(0:tp-1)


system("rm -f "+dir4+"SST_nino_region_oisst_chl_5_moving_199801-201112.nc")
out=addfile(    dir4+"SST_nino_region_oisst_chl_5_moving_199801-201112.nc","c")
out->sst_nino3_mv=sst_nino3_mv
out->sst_nino34_mv=sst_nino34_mv
out->sst_nino4_mv=sst_nino4_mv
out->time=time(0:tp-1)

end
