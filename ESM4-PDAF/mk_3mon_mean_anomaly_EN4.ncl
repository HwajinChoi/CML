begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

g1=addfile(dir1+"EN4/EN.4.2.2.r360x180.temperature_201001-202112.nc","r")
tos_EN4=g1->temperature(60::,0,:,:)
lon_EN4=g1->lon
lat_EN4=g1->lat
dim_EN4=dimsizes(tos_EN4)
clim_EN4=clmMonTLL(tos_EN4)
tos_EN4=calcMonAnomTLL(tos_EN4,clim_EN4)

;----- 3 months moving-------------------------------------------------------------
 p=3;chunck period
 tp=dim_EN4(0)-p+1;total period after moving averaged
 tos_EN4_mv_3=new((/tp,dim_EN4(1),dim_EN4(2)/),"float"); Target
 imsi=new((/p,dim_EN4(1),dim_EN4(2)/),"float"); Chunck
  do k=0,tp-1
   imsi(:,:,:)=tos_EN4(k:k+p-1,:,:)
   tos_EN4_mv_3(k,:,:)=dim_avg_n_Wrap(imsi,0)
   imsi=imsi@_FillValue
  end do
 tos_EN4_mv_3!0="time"
 tos_EN4_mv_3@units="degC"
; tos_EN4_mv_3@_FillValue=-999
 ;tos_EN4_mv_3_2=where(tos_EN4_mv_3 .eq. -32768,-999,tos_EN4_mv_3)
 

system("rm -f "+dir1+"tos_EN4_3moving_ano_2015-2021.nc")
out=addfile(    dir1+"tos_EN4_3moving_ano_2015-2021.nc","c")
out->tos=tos_EN4_mv_3
out->lon=lon_EN4
out->lat=lat_EN4

end
