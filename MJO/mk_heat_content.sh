#!/bin/bash

for s in "cobalt" "daily_chl";do
dir1=/media/cmlws/Data2/hjc/MJO/data/RE/${s}/for_HC

cat > imsi.ncl << EOF
begin
f=addfile(dir1+"temp.0-300m.daily.1990.nc","r")
z=f->pfull

; HeatContent = (rho*Cp)*SUM[ T(k)*dz(k) ]
Cp = 3850.0;         % unit: Jkg-1K-1
den=1026 ; kg m-3


system("rm -f ${dir1}/Heat_Content.ano.19900101-20091231.nc")
out=addfile( "${dir1}/Heat_Content.ano.19900101-20091231.nc","c")
out->${v}Anom=${v}Anom
out->time=time

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done
