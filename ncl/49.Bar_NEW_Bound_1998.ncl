begin
dir1="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir2="/media/cmlws/Data2/hjc/image/"
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/cfgs/ORCA_test4/EXP20/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;--------------------------------------------------------------------------------------
d="20m";depth
rad    = 4.0*atan(1.0)/180.0
;-----------------------------
f=addfile(dir1+"qsr3d_0-"+d+"_Bound_chl_clim_98_init_clim_199801-199912.nc","r")
q_clim=f->qsr3d(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
lat=f->lat({lat_min:lat_max})
lon=f->lon({nino34_lon_min:nino34_lon_max})
q_clim_mon=clmMonTLL(q_clim)
clat1   = cos(lat*rad)
q_clim_nino34_wgt = wgt_areaave_Wrap(q_clim_mon,clat1,1.0,1)
;-----------------------------
g=addfile(dir1+"qsr3d_0-"+d+"_Bound_chl_const_98_init_clim_199801-199912.nc","r")
q_const=g->qsr3d(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
q_const_mon=clmMonTLL(q_const)
q_const_nino34_wgt = wgt_areaave_Wrap(q_const_mon,clat1,1.0,1)
;-----------------------------
h=addfile(dir1+"qsr3d_0-"+d+"_Bound_chl_inter_98_init_clim_199801-199912.nc","r")
q_inter=h->qsr3d(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
q_inter_mon=clmMonTLL(q_inter)
q_inter_nino34_wgt = wgt_areaave_Wrap(q_inter_mon,clat1,1.0,1)

q_clim_avg=avg(q_clim_nino34_wgt)
q_const_avg=avg(q_const_nino34_wgt)
q_inter_avg=avg(q_inter_nino34_wgt)
;-----------------------------
c1=addfile(dir3+"chl_clim_seawifs_modis_199710-202112.nc","r")
chl_clim=c1->chlor_a(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
lat_chl=c1->lat({lat_min:lat_max})
lon_chl=c1->lon({nino34_lon_min:nino34_lon_max})
clat2   = cos(lat_chl*rad)
chl_clim_nino34_wgt = wgt_areaave_Wrap(chl_clim,clat2,1.0,1)
;-----------------------------
c2=addfile(dir3+"chl_y1998-1999.nc","r")
chl_inter=c2->chlor_a(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
chl_inter_mon=clmMonTLL(chl_inter)
chl_inter_nino34_wgt = wgt_areaave_Wrap(chl_inter_mon,clat2,1.0,1)
;-----------------------------
print(";----------------------------------------------------------")
print("ENSO region, Shortwave Radiation 3D distribution (w/m^2)")
print(";----------------------------------------------------------")
print("clim (7 ; 0-"+d+") = "+q_clim_nino34_wgt(6))
print("const (7 ; 0-"+d+") = "+q_const_nino34_wgt(6))
print("inter (7 ; 0-"+d+") = "+q_inter_nino34_wgt(6))
print(";----------------------------------------------------------")
print("clim (8 ; 0-"+d+") = "+q_clim_nino34_wgt(7))
print("const (8 ; 0-"+d+") = "+q_const_nino34_wgt(7))
print("inter (8 ; 0-"+d+") = "+q_inter_nino34_wgt(7))
print(";----------------------------------------------------------")
print("ENSO region, Chlorophyll (mg m^-3)")
print(";----------------------------------------------------------")
print("CHL_clim (7) = "+chl_clim_nino34_wgt(6))
print("CHL_inter (7) = "+chl_inter_nino34_wgt(6))
print(";----------------------------------------------------------")
print("CHL_clim (8) = "+chl_clim_nino34_wgt(7))
print("CHL_inter (8) = "+chl_inter_nino34_wgt(7))
print(";----------------------------------------------------------")
;print(chl_clim_nino34_wgt)
;print(";----------------------------------------------------------")
;print(chl_inter_nino34_wgt)
end
