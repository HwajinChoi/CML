#!/bin/bash

for s in "on" "off";do
 #for v in "ucomp" "olr";do
 for v in "temp" ;do
 dir1=/media/cmlws/Data2/hjc/MJO/data/${s}
 
 #if [ $v = "ucomp" ];then
 if [ $v = "temp" ];then
  A="${v}=f->${v}(:,0,:,:)"
  else
  A="${v}=f->${v}"
 fi

cat > imsi.ncl << EOF
begin
g=systemfunc("ls ${dir1}/${v}*20000101-20191231.nc")
f=addfile(g,"r")
${A}
grid_yt=f->grid_yt
grid_xt=f->grid_xt
time=f->time
TIME    = cd_calendar(time, 0)          ; type float 
year    = toint( TIME(:,0) )
month   = toint( TIME(:,1) )
day     = toint( TIME(:,2) ) 
ddd     = day_of_year(year, month, day) 
yyyyddd = year*1000 + ddd  
${v}ClmDay    = clmDayTLL(${v},yyyyddd) 
${v}Anom      = calcDayAnomTLL (${v}, yyyyddd, ${v}ClmDay) 

system("rm -f ${dir1}/${v}_ano_20000101-20191231.nc")
out=addfile( "${dir1}/${v}_ano_20000101-20191231.nc","c")
out->${v}Anom=${v}Anom
out->time=time
out->grid_yt=grid_yt
out->grid_xt=grid_xt

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl
 done
done
