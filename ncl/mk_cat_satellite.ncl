begin
dir1="/media/cmlws/Data2/hjc/satellite/seawifs_modis/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/cfgs/ORCA_test4/EXP03/mk_input/"
setfileoption("nc","Format","LargeFile")

files1=systemfunc("ls "+dir1+"S*"); Seawifs
files2=systemfunc("ls "+dir1+"A*"); Modis
gfile=systemfunc("ls "+dir1+"S* | head -1")

f=addfiles(files1,"r")
ListSetType(f,"join")
chl_sea=f[:]->chlor_a
chl_sea!0="time"

g=addfiles(files2,"r")
ListSetType(g,"join")
chl_modis=g[:]->chlor_a
chl_modis!0="time"

h=addfile(gfile,"r")
lon=h->lon
lat=h->lat
printVarSummary(chl_modis)
printVarSummary(lon)
printVarSummary(lat)
exit

k=addfile(dir2+"fcst_phy2m125_srweq_196001-202112.nc","r")
time=k->time(453:743)

dim_sea=dimsizes(chl_sea)
dim_modis=dimsizes(chl_modis)

chl=new((/dim_sea(0)+dim_modis(0),dim_sea(1),dim_sea(2)/),"float");time(291)*lat*lon 
chl(0:dim_sea(0)-1,:,:)=chl_sea
chl(dim_sea(0):dim_sea(0)+dim_modis(0)-1,:,:)=chl_modis
chl&time=time
chl@_FillValue=-32767

system("rm -rf "+dir1+"Chl_seawifs_modis_199710-202112.nc")
out=addfile(     dir1+"Chl_seawifs_modis_199710-202112.nc","c")
out->chl=chl
;out->time=time
out->lon=lon
out->lat=lat

end
