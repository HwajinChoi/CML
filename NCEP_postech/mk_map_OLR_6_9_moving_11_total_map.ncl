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

dim1=dimsizes(OLR); year x time x lat x lon

;----- 11 days moving-------------------------------------------------------------
 p=11;chunck period
 tp=122-p+1;total period after moving averaged
 OLR_mv_11=new((/32,tp,dim1(2),dim1(3)/),"float"); Target
 imsi=new((/32,p,dim1(2),dim1(3)/),"float"); Chunck
  do k=0,tp-1
   imsi(:,:,:,:)=OLR(:,k:k+p-1,:,:)
   OLR_mv_11(:,k,:,:)=dim_avg_n_Wrap(imsi,1)
   imsi=imsi@_FillValue
  end do

OLR_mv_11!0="year"
OLR_mv_11!1="time"


system("rm -f "+dir1+"OLR_11moving_199106-202209.nc")
out=addfile(    dir1+"OLR_11moving_199106-202209.nc","c")
out->orl=OLR_mv_11

end
