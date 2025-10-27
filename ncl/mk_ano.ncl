begin

dir="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir1="/media/cmlws/Data2/hjc/NEMO/r4.0.6/output_pro/"

f=addfile(dir+"grid_T_1950-2009.mm.msk.flt.sstemper.nc","r")
sstemper=f->sstemper ; sea surface temperature
time_counter=f->time_counter
lon=f->lon
lat=f->lat
temp_clim=dim_avg_n_Wrap(sstemper,0)

g=addfile(dir+"tptrc_T_1950-2009.mm.msk.flt.sfcchl.nc","r")
sfcchl=g->sfcchl
chl_clim=dim_avg_n_Wrap(sfcchl,0)

dim=dimsizes(sstemper)

TEMP_clim=new((/dim(0),dim(1),dim(2)/),"float")
CHL_clim=new((/dim(0),dim(1),dim(2)/),"float")

do a=0,dim(0)-1
 TEMP_clim(a,:,:)=temp_clim
 CHL_clim(a,:,:)=chl_clim
end do
 TEMP_clim!0="time_counter"
 CHL_clim!0="time_counter"

temp=sstemper-TEMP_clim
chl=sfcchl-CHL_clim
copy_VarCoords(sstemper,temp)
copy_VarCoords(sfcchl,chl)

out=addfile(dir1+"sst_NEMO_TOPAZ_1950-2009_monthly_ano.nc","c")
out->temp=temp
out->lon=lon
out->lat=lat
out->time_counter=time_counter

out=addfile(dir1+"chl_NEMO_TOPAZ_1950-2009_monthly_ano.nc","c")
out->chl=chl
out->lon=lon
out->lat=lat
out->time_counter=time_counter

end
