#!/bin/sh

loc1=/disk3/hjchoi/JRA55/NC
loc2=/disk3/hjchoi/JRA55/NC/for_conv

#for var in "spfh" "ugrd" "vgrd"; do
for var in "ugrd" "vgrd"; do
#for var in "spfh"; do
 for i in {2012..2019};do # 1960-2012-> level:integer, 2013~ ->level:double
  for m in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12";do
  cat > imsi.ncl << EOF
begin
;---------------------------------------------------------------------
; This is selecting specific levels to compare CMIP6 models.
;---------------------------------------------------------------------
dir0="$loc1"+"/"+"$var"
dir1="$loc2"+"/"+"$var"

f=addfile(dir0+"/anl_p125_$var.day.${i}${m}.nc","r")
var2=f->$var;
level2=f->lev
lat=f->lat
lon=f->lon
time=f->time
level=new(4,"double")
level(0)=level2({1000})
level(1)=level2({850})
level(2)=level2({700})
level(3)=level2({500})

n=dimsizes(var2)
$var=new((/n(0),4,n(2),n(3)/),"float")
$var(:,0,:,:)=var2(:,{1000},:,:)
$var(:,1,:,:)=var2(:,{850},:,:)
$var(:,2,:,:)=var2(:,{700},:,:)
$var(:,3,:,:)=var2(:,{500},:,:)

system("rm -rf "+dir1+"/$var.day.${i}${m}.nc" )
out=addfile(     dir1+"/$var.day.${i}${m}.nc","c")
out->lon=lon
out->lat=lat
out->$var=$var
out->lev=level
out->time=time
print("Accomplished  $var.day.${i}${m}.nc")
end
EOF
echo '*********************************************'
 ncl imsi.ncl
 rm -rf imsi.ncl
  done
 done
done
