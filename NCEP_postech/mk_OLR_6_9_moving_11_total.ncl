begin
dir1="/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9/"
;----------------------------------------------------------
; India => 70-80E, 20-30N
; South China Sea => 105-130E, 15-25N
;----------------------------------------------------------

f=addfile(dir1+"olr.daily.1991-2022.nc","r")
lon=f->lon
lat=f->lat
olr=f->olr ; time x lat x lon 
dim=dimsizes(olr)

OLR=new((/32,122,dim(1),dim(2)/),"float")
do i =0,31
 OLR(i,:,:,:)=olr(122*i:122*i+121,:,:)
end do
 OLR!0="year"

OLR_indo=OLR(:,:,{20:30},{55:80})
OLR_china=OLR(:,:,{15:25},{105:130})

OLR_indo1=dim_avg_n_Wrap(OLR_indo,2)
OLR_indo2=dim_avg_n_Wrap(OLR_indo1,2)

OLR_china1=dim_avg_n_Wrap(OLR_china,2)
OLR_china2=dim_avg_n_Wrap(OLR_china1,2)

;----- 11 days moving-------------------------------------------------------------
 p=11;chunck period
 tp=122-p+1;total period after moving averaged
 OLR_indo_mv_11=new((/32,tp/),"float"); Target
 OLR_china_mv_11=new((/32,tp/),"float"); Target
 imsi=new((/32,p/),"float"); Chunck
 imsi2=new((/32,p/),"float"); Chunck
  do k=0,tp-1
   imsi(:,:)=OLR_indo2(:,k:k+p-1)
   OLR_indo_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
   imsi=imsi@_FillValue

   imsi2(:,:)=OLR_china2(:,k:k+p-1)
   OLR_china_mv_11(:,k)=dim_avg_n_Wrap(imsi2,1)
   imsi2=imsi2@_FillValue
  end do

OLR_indo_mv_11!0="year"
OLR_indo_mv_11!1="time"

OLR_china_mv_11!0="year"
OLR_china_mv_11!1="time"

olr_indo_clim=dim_avg_n_Wrap(OLR_indo_mv_11,0)
olr_china_clim=dim_avg_n_Wrap(OLR_china_mv_11,0)

olr_indo_ano=new((/32,112/),"float")
olr_china_ano=new((/32,112/),"float")
do m=0,31
 olr_indo_ano(m,:)=OLR_indo_mv_11(m,:)-olr_indo_clim
 olr_china_ano(m,:)=OLR_china_mv_11(m,:)-olr_china_clim
end do
copy_VarMeta(OLR_indo_mv_11,olr_indo_ano)
copy_VarMeta(OLR_china_mv_11,olr_china_ano)

system("rm -f "+dir1+"OLR_ANO_wide_indo_11moving_1991-2022_June_Sep.nc")
out=addfile(    dir1+"OLR_ANO_wide_indo_11moving_1991-2022_June_Sep.nc","c")
out->orl=olr_indo_ano

system("rm -f "+dir1+"OLR_ANO_china_11moving_1991-2022_June_Sep.nc")
out2=addfile(   dir1+"OLR_ANO_china_11moving_1991-2022_June_Sep.nc","c")
out2->orl=olr_china_ano

end
