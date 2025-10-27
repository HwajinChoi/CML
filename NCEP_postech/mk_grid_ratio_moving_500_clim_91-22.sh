#!/bin/bash

#for h in "500" ;do
for h in "200";do

dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last

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

;hgt_mask=where(hgt .ge. 5850, 1,0) ; for 500 hpa
hgt_mask=where(hgt .ge. 12480, 1,0) ; for 200hpa
copy_VarMeta(hgt,hgt_mask)

test=dim_sum_n_Wrap(hgt_mask,2)
hgt_count=dim_sum_n_Wrap(test,2)
hgt_count2=int2flt(hgt_count)
hgt_count2 := hgt_count2/40.

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)
;----- 11 days moving-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/32,tp/),"float"); Target
imsi=new((/32,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
  hgt_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!0="year"
hgt_mv_11!1="time"

system("rm -f ${dir1}/hgt_count_mv_11_1991-2022.nc")
out6=addfile("${dir1}/hgt_count_mv_11_1991-2022.nc","c")
out6->hgt_mv_11=hgt_mv_11
exit

y5=ispan(6,148,1)
delete([/imsi,k,p,tp/])

system("rm -f ${dir1}/hgt_count_clim.nc")
out1=addfile("${dir1}/hgt_count_clim.nc","c")
out1->hgt_count_clim=hgt_count_clim

system("rm -f ${dir1}/hgt_count_5days_avg.nc")
out2=addfile("${dir1}/hgt_count_5days_avg.nc","c")
out2->hgt_5days_avg=hgt_5days_avg

system("rm -f ${dir1}/hgt_count_mv_5_avg.nc")
out3=addfile("${dir1}/hgt_count_mv_5_avg.nc","c")
out3->hgt_mv_5_avg=hgt_mv_5_avg

system("rm -f ${dir1}/hgt_count_mv_7_avg.nc")
out4=addfile("${dir1}/hgt_count_mv_7_avg.nc","c")
out4->hgt_mv_7_avg=hgt_mv_7_avg

system("rm -f ${dir1}/hgt_count_mv_9_avg.nc")
out5=addfile("${dir1}/hgt_count_mv_9_avg.nc","c")
out5->hgt_mv_9_avg=hgt_mv_9_avg

system("rm -f ${dir1}/hgt_count_mv_11_avg.nc")
out6=addfile("${dir1}/hgt_count_mv_11_avg.nc","c")
out6->hgt_mv_11_avg=hgt_mv_11_avg

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
