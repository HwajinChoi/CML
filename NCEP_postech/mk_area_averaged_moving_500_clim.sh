#!/bin/bash

for h in "500" "300" "200";do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc")
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat({43:31})
lon=g->lon({117:137})
time=g->time

ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)

;-----Raw data---------------------------------------------------------------
hgt_Ave = wgt_areaave_Wrap(hgt, clat, 1.0, 1) ; 30(year) x 153(time) 
hgt_Ave_clim=dim_avg_n_Wrap(hgt_Ave,0)
;-----5 days averaged--------------------------------------------------------
hgt_5days=new((/30,31/),"float")
imsi=new((/30,5/),"float")
A=new((/30,3/),"float")

 do i =0,29
  imsi(:,:)=hgt_Ave(:,5*i:5*i+4)
  hgt_5days(:,i)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

 A=hgt_Ave(:,150:152)
 hgt_5days(:,30)=dim_avg_n_Wrap(A,1)
 hgt_5days!1="time"
 y12=ispan(3,148,5)
 y1=new(31,"integer")
 y1(0:29)=y12
 y1(30)=152
 hgt_5days_avg=dim_avg_n_Wrap(hgt_5days,0)
 delete(imsi)
;----------- For moving average ------------------------------------
p=5;chunck period
tp=153-p+1;total period after moving averaged
;----- 5 days moving-------------------------------------------------------------
hgt_mv_5=new((/30,tp/),"float"); Target
imsi=new((/30,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:)=hgt_Ave(:,k:k+p-1)
  hgt_mv_5(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_5!1="time"
hgt_mv_5_avg=dim_avg_n_Wrap(hgt_mv_5,0)

y2=ispan(3,151,1)
delete([/imsi,k,p,tp/])
;----- 7 days moving-------------------------------------------------------------
p=7;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_7=new((/30,tp/),"float"); Target
imsi=new((/30,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_Ave(:,k:k+p-1)
  hgt_mv_7(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_7!1="time"
hgt_mv_7_avg=dim_avg_n_Wrap(hgt_mv_7,0)

y3=ispan(4,150,1)
delete([/imsi,k,p,tp/])
;----- 9 days moving-------------------------------------------------------------
p=9;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_9=new((/30,tp/),"float"); Target
imsi=new((/30,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_Ave(:,k:k+p-1)
  hgt_mv_9(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_9!1="time"
hgt_mv_9_avg=dim_avg_n_Wrap(hgt_mv_9,0)

y4=ispan(5,149,1)
delete([/imsi,k,p,tp/])
;----- 11 days moving-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/30,tp/),"float"); Target
imsi=new((/30,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_Ave(:,k:k+p-1)
  hgt_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!1="time"
hgt_mv_11_avg=dim_avg_n_Wrap(hgt_mv_11,0)

y5=ispan(6,148,1)
delete([/imsi,k,p,tp/])

system("rm -f ${dir1}/hgt_Ave_clim.nc")
out1=addfile("${dir1}/hgt_Ave_clim.nc","c")
out1->hgt_Ave_clim=hgt_Ave_clim

system("rm -f ${dir1}/hgt_5days_avg.nc")
out2=addfile("${dir1}/hgt_5days_avg.nc","c")
out2->hgt_5days_avg=hgt_5days_avg

system("rm -f ${dir1}/hgt_mv_5_avg.nc")
out3=addfile("${dir1}/hgt_mv_5_avg.nc","c")
out3->hgt_mv_5_avg=hgt_mv_5_avg

system("rm -f ${dir1}/hgt_mv_7_avg.nc")
out4=addfile("${dir1}/hgt_mv_7_avg.nc","c")
out4->hgt_mv_7_avg=hgt_mv_7_avg

system("rm -f ${dir1}/hgt_mv_9_avg.nc")
out5=addfile("${dir1}/hgt_mv_9_avg.nc","c")
out5->hgt_mv_9_avg=hgt_mv_9_avg

system("rm -f ${dir1}/hgt_mv_11_avg.nc")
out6=addfile("${dir1}/hgt_mv_11_avg.nc","c")
out6->hgt_mv_11_avg=hgt_mv_11_avg

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done
