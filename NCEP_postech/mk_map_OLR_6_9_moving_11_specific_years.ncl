begin
dir1="/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/spec_6_9/"
;----------------------------------------------------------
; India => 70-80E, 20-30N
; South China Sea => 105-130E, 15-25N
;----------------------------------------------------------

files=systemfunc("ls "+dir1+"olr.daily.????.nc")
gfile=systemfunc("ls "+dir1+"olr.daily.????.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfile,"r")
lon=g->lon
lat=g->lat
ListSetType(f,"join")
OLR=f[:]->olr ; case x time x lat x lon 
OLR!0="case" ; 2016, 2018, 2020

dim=dimsizes(OLR)

;----- 11 days moving-------------------------------------------------------------
 p=11;chunck period
 tp=122-p+1;total period after moving averaged
 OLR_mv_11=new((/dim(0),tp,dim(2),dim(3)/),"float"); Target
 imsi=new((/dim(0),p,dim(2),dim(3)/),"float"); Chunck
  do k=0,tp-1
   imsi(:,:,:,:)=OLR(:,k:k+p-1,:,:)
   OLR_mv_11(:,k,:,:)=dim_avg_n_Wrap(imsi,1)
   imsi=imsi@_FillValue
  end do
OLR_mv_11!1="time"

system("rm -f "+dir1+"OLR_MAP_11moving_2016_2018_2020_June_Sep.nc")
out=addfile(    dir1+"OLR_MAP_11moving_2016_2018_2020_June_Sep.nc","c")
out->orl=OLR_mv_11

end
