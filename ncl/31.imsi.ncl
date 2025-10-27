begin
dir1="/media/cmlws/Data2/hjc/OISST/"
f=addfile(dir1+"oisst-avhrr-v02r01.r180x90.199601-201112.nc","r")
sst=f->sst(:,0,:,:)
lat=f->lat
lon=f->lon
oisst = short2flt(sst)
oisst_mon=clmMonTLL(oisst)
oisst_ano=calcMonAnomTLL(oisst,oisst_mon)

out=addfile(dir1+"oisst.monthly_ano.r180x90.199601-201112.nc","c")
out->oisst=oisst_ano
out->lat=lat
out->lon=lon

end
