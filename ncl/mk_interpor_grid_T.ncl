begin

dir1="/media/cmlws/Data2/hjc/NEMO/r4.0.6/OUTPUT/chl_clim_196001-199709/"

f=addfile(dir1+"tos_chl_clim_01_196101_199412.nc","r")
g=addfile(dir1+"raw/chl_clim_01_1d_19640101_19641231_grid_T.nc","r")
h=addfile(dir1+"COBALT_grid.nc","r")
tos=f->tos
nav_lat=g->nav_lat
nav_lon=g->nav_lon
nav_lat = (/nav_lat(::-1,:)/)
tos = (/tos(:,::-1,:)/)

lat=h->yt_ocean
lon=h->xt_ocean

tas_regrid=rcm2rgrid(nav_lat,nav_lon,tos,lat,lon,1)
tas_regrid!0="time"
tas_regrid!1="lat"
tas_regrid!2="lon"
tas_regrid&lat=lat
tas_regrid&lon=lon
printVarSummary(tas_regrid)

end
