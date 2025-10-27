#!/bin/bash

for s in "cobalt"  "daily_chl";do
#for s in "cobalt" ;do
# for v in "ucomp" "olr";do
 for v in "hfls" ;do
 dir1=/media/cmlws/Data2/hjc/MJO/data/RE/${s}
 
 if [ $v = "ucomp" ];then
 #if [ $v = "temp" ];then
  A="${v}=f->${v}(:,0,:,:)"
  else
  A="${v}=f->${v}"
 fi

 if [ $v = "chlos" ];then
   B="grid_xt=f->lon"
   C="grid_yt=f->lat"
   D="${v}.reg.19900101-20091231.nc"
  else
   B="grid_yt=f->grid_yt"
   C="grid_xt=f->grid_xt"
   D="${v}.19900101-20091231.nc"
 fi

cat > imsi.ncl << EOF
begin
g=systemfunc("ls ${dir1}/${D}")
f=addfile(g,"r")
${A}
${B}
${C}
time=f->time
TIME    = cd_calendar(time, 0)          ; type float 
year    = toint( TIME(:,0) )
month   = toint( TIME(:,1) )
day     = toint( TIME(:,2) ) 
ddd     = day_of_year(year, month, day) 
yyyyddd = year*1000 + ddd  
${v}ClmDay    = clmDayTLL(${v},yyyyddd) 
${v}Anom      = calcDayAnomTLL (${v}, yyyyddd, ${v}ClmDay) 
${v}Anom!1="grid_yt"
${v}Anom!2="grid_xt"
${v}Anom&grid_yt=grid_yt
${v}Anom&grid_xt=grid_xt

system("rm -f ${dir1}/${v}.ano.19900101-20091231.nc")
out=addfile( "${dir1}/${v}.ano.19900101-20091231.nc","c")
out->${v}Anom=${v}Anom
out->time=time

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl
 done
done
