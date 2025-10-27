begin
dir1="/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/spec_2_6_9/"
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

OLR_indo=OLR(:,:,{20:30},{70:80})
OLR_china=OLR(:,:,{15:25},{105:130})

OLR_indo1=dim_avg_n_Wrap(OLR_indo,2)
OLR_indo2=dim_avg_n_Wrap(OLR_indo1,2)

OLR_china1=dim_avg_n_Wrap(OLR_china,2)
OLR_china2=dim_avg_n_Wrap(OLR_china1,2)

;----- 11 days moving-------------------------------------------------------------
 p=11;chunck period
 tp=122-p+1;total period after moving averaged
 OLR_indo_mv_11=new((/4,tp/),"float"); Target
 OLR_china_mv_11=new((/4,tp/),"float"); Target
 imsi=new((/4,p/),"float"); Chunck
 imsi2=new((/4,p/),"float"); Chunck
  do k=0,tp-1
   imsi(:,:)=OLR_indo2(:,k:k+p-1)
   OLR_indo_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
   imsi=imsi@_FillValue

   imsi2(:,:)=OLR_china2(:,k:k+p-1)
   OLR_china_mv_11(:,k)=dim_avg_n_Wrap(imsi2,1)
   imsi2=imsi2@_FillValue
  end do

OLR_indo_mv_11!0="case"
OLR_indo_mv_11!1="time"

OLR_china_mv_11!0="case"
OLR_china_mv_11!1="time"

system("rm -f "+dir1+"OLR_indo_11moving_1995_2006_2010_2012_June_Sep.nc")
out=addfile(    dir1+"OLR_indo_11moving_1995_2006_2010_2012_June_Sep.nc","c")
out->orl=OLR_indo_mv_11

system("rm -f "+dir1+"OLR_china_11moving_1995_2006_2010_2012_June_Sep.nc")
out2=addfile(   dir1+"OLR_china_11moving_1995_2006_2010_2012_June_Sep.nc","c")
out2->orl=OLR_china_mv_11

end
