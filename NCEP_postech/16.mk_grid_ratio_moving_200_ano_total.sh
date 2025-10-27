#!/bin/bash

for h in "200";do

dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc")
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat
lon=g->lon
time=g->time

ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,:,:); year x time x level x lat x lon (117-137°E, 31-43°N)
dim=dimsizes(hgt)

;--------------------------------------------------------
;--------------------------------------------------------
;hgt_mask=where(hgt .ge. 5850, 1,0) ; for 500 hpa
;hgt_mask=where(hgt .ge. 12480, 1,0) ; for 200hpa
;--------------------------------------------------------
;--------------------------------------------------------
y=ispan(1,153,1)
;----- 11 days moving-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/dim(0),tp,dim(2),dim(3)/),"float"); Target
imsi=new((/dim(0),p,dim(2),dim(3)/),"float"); Chunck

do k=0,tp-1
  imsi(:,:,:,:)=hgt(:,k:k+p-1,:,:)
  hgt_mv_11(:,k,:,:)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!0="year"
hgt_mv_11!1="time"

hgt_mv_11 := hgt_mv_11(:,31:142,:,:)

hgt_ano=dim_avg_n_Wrap(hgt_mv_11,0)

HGT_ANO=new((/dim(0),112,dim(2),dim(3)/),"float")

do i=0,dim(0)-1
 HGT_ANO(i,:,:,:)=hgt_mv_11(i,:,:,:)-hgt_ano
end do

copy_VarCoords(hgt_mv_11,HGT_ANO)
system("rm -f ${dir1}/hgt_ano_mv_11_1991-2022.nc")
out6=addfile("${dir1}/hgt_ano_mv_11_1991-2022.nc","c")
out6->HGT_ANO=HGT_ANO
exit

;--------------------------------------------------------------------------
hgt_mv_11_S=flt2string(hgt_mv_11)
HGT_11=new((/32,224/),"string")
com=new(32,"string")
com=","
com!0="year"

fname="hgt_200_intensity_Jun_Sep_1991-2022.csv"

do j=0,111
 HGT_11(:,2*j)=hgt_mv_11_S(:,j)
 HGT_11(:,2*j+1)=com
end do

dim2=dimsizes(HGT_11)

lines=new(dim2(0),"string")
do i=0,dim2(0)-1
 lines(i)=str_concat(HGT_11(i,:))
end do
asciiwrite(fname,lines)
exit

;YEAR=ispan(1991,2022,1)
;hlist=[/YEAR/]
;alist=[/hgt_mv_11(:,0),hgt_mv_11(:,1),hgt_mv_11(:,2),hgt_mv_11(:,3)/]
;write_table(fname,"a",hlist,"%s")
;write_table(fname,"w",alist,"%1.3f,%1.3f,%1.3f,%1.3f")
;exit


;--------------------------------------------------------------------------

system("rm -f ${dir1}/hgt_AVG_count_mv_11_1991-2020.nc")
out6=addfile("${dir1}/hgt_AVG_count_mv_11_1991-2020.nc","c")
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
