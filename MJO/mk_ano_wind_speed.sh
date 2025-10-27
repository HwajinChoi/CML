#!/bin/bash

for s in "cobalt" "daily_chl" "clim_chl";do
 dir1=/media/cmlws/Data2/hjc/MJO/data/RE/${s}
 
cat > imsi.ncl << EOF
begin
f=addfile("${dir1}/ucomp.19900101-20091231.nc","r")
g=addfile("${dir1}/vcomp.19900101-20091231.nc","r")
grid_yt=f->grid_yt
grid_xt=f->grid_xt
time=f->time

ucomp=f->ucomp(:,0,:,:)
vcomp=g->vcomp(:,0,:,:)
wspd=wind_speed(ucomp,vcomp)

TIME    = cd_calendar(time, 0)          ; type float 
year    = toint( TIME(:,0) )
month   = toint( TIME(:,1) )
day     = toint( TIME(:,2) ) 
ddd     = day_of_year(year, month, day) 
yyyyddd = year*1000 + ddd  
wspdClmDay    = clmDayTLL(wspd,yyyyddd) 
wspdAnom      = calcDayAnomTLL (wspd, yyyyddd, wspdClmDay) 

system("rm -f ${dir1}/wspd.ano.19900101-20091231.nc")
out=addfile( "${dir1}/wspd.ano.19900101-20091231.nc","c")
out->wspdAnom=wspdAnom
out->time=time
out->grid_yt=grid_yt
out->grid_xt=grid_xt

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done
