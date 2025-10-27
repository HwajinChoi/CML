#!/bin/bash

for h in "500" "200" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/total

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc")
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
;lat=g->lat({43:31})
;lon=g->lon({117:137})
lat=g->lat
lon=g->lon
time=g->time

ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,:,:); year x time x level x lat x lon ;(117-137°E, 31-43°N)

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)
dim=dimsizes(hgt)

;----- 11 days moving-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/43,tp,dim(2),dim(3)/),"float"); Target
imsi=new((/43,p,dim(2),dim(3)/),"float"); Chunck

do k=0,tp-1
  imsi(:,:,:,:)=hgt(:,k:k+p-1,:,:)
  hgt_mv_11(:,k,:,:)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!1="time"
hgt_mv_11!0="year"

system("rm -f ${dir1}/HGT_mv_11_1980-2022.nc")
out6=addfile("${dir1}/HGT_mv_11_1980-2022.nc","c")
out6->hgt_mv_11=hgt_mv_11

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done
