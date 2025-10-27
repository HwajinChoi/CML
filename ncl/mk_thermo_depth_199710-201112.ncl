begin
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/output_pro/"
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
dir4="/media/cmlws/Data2/hjc/image/"
;--------------------------------------------------------------------------------------------
;---------CHL_clim----------------------------------------------------------------------------
g2=addfile(dir2+"diff_thetao_clim_199710-201112.nc","r")
thetao_clim=g2->thetao;time*depth*lat*lon
lat=g2->lat
lon=g2->lon
depth=g2->deptht
time_counter=g2->time_counter
dim=dimsizes(thetao_clim)

thermo_clim_depth=new((/dim(0),dim(2),dim(3)/),"float")
num_clim=dim_maxind(thetao_clim(deptht|:,time_counter|:,lat|:,lon|:),0)
clim_A=ndtooned(num_clim)
clim_B=depth(clim_A)
thermo_clim_depth=onedtond(clim_B,(/dim(0),dim(2),dim(3)/))
copy_VarMeta(num_clim,thermo_clim_depth)

system("rm -f "+dir2+"thermo_depth_clim_199710-201112.nc")
out=addfile(    dir2+"thermo_depth_clim_199710-201112.nc","c")
out->lon=lon
out->lat=lat
out->thermo=thermo_clim_depth
out->time_counter=time_counter
print("Accomplished thermo_depth_clim_199710-201112.nc")
;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir2+"diff_thetao_const_199710-201112.nc","r")
thetao_const=h1->thetao

thermo_const_depth=new((/dim(0),dim(2),dim(3)/),"float")
num_const=dim_maxind(thetao_const(deptht|:,time_counter|:,lat|:,lon|:),0)
const_A=ndtooned(num_const)
const_B=depth(const_A)
thermo_const_depth=onedtond(const_B,(/dim(0),dim(2),dim(3)/))
copy_VarMeta(num_const,thermo_const_depth)

system("rm -f "+dir2+"thermo_depth_const_199710-201112.nc")
out=addfile(    dir2+"thermo_depth_const_199710-201112.nc","c")
out->lon=lon
out->lat=lat
out->thermo=thermo_const_depth
out->time_counter=time_counter
print("Accomplished thermo_depth_const_199710-201112.nc")
;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir2+"diff_thetao_inter_199710-201112.nc","r")
thetao_inter=h2->thetao

thermo_inter_depth=new((/dim(0),dim(2),dim(3)/),"float")
num_inter=dim_maxind(thetao_inter(deptht|:,time_counter|:,lat|:,lon|:),0)
inter_A=ndtooned(num_inter)
inter_B=depth(inter_A)
thermo_inter_depth=onedtond(inter_B,(/dim(0),dim(2),dim(3)/))
copy_VarMeta(num_inter,thermo_inter_depth)

system("rm -f "+dir2+"thermo_depth_inter_199710-201112.nc")
out=addfile(    dir2+"thermo_depth_inter_199710-201112.nc","c")
out->lon=lon
out->lat=lat
out->thermo=thermo_inter_depth
out->time_counter=time_counter
print("Accomplished thermo_depth_inter_199710-201112.nc")
;--------------------------------------------------------------------------------------------


end
