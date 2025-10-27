;
; convert variables on sigma coordinates to pressure coordinate
; including calculation and converting geopotential height
;
; Date : 20110726
; Author : Sang-Yoon Jun, Climate Physics Laboratory
;
; modified by Eun-Hyuk Baek, KORDI at 20120515
; change sum code in order to use GFDL CM2.1 Hybrid Coordinate

begin

; read data
nc_f_in = systemfunc("ls atmos_month_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc")
print(nc_f_in)
dim_in=dimsizes(nc_f_in)

do itt=0, dim_in(0)-1
  it=itt+1
  nc_in = addfile(nc_f_in(itt),"r");

; define output name.
  if(it.lt.10) then
  NC_F_O = "./converted_00"+it+".nc";
  else
   if(it.lt.100) then
    NC_F_O = "./converted_0"+it+".nc";
   else
    NC_F_O = "./converted_"+it+".nc";
   end if
  end if
;  NC_F_O = "out.nc";

; read 1d or 2d vars for interpolating to pressure level
  ps = nc_in->ps; surface pressure (Pa)
  nps = ps/100.0
  zsurf = nc_in->zsurf; surface height (lon*lat)
  zsurf@_FillValue=-1
  zsurf=where(ismissing(zsurf),0,zsurf)

  tbot = nc_in->t_surf; bottom temperature (time*lon*lat)
  time = nc_in->time
  lon = nc_in->lon
  lat = nc_in->lat

; set dimension
  nt = dimsizes(time)
  nx = dimsizes(lon)
  ny = dimsizes(lat)

; convert unit of surface height to m2/s2
  grav = 9.80655;
  zsurfg = zsurf*grav;

  P0 = 1000.0;

; calculate pressure value of Hybrid Coordinate at mid-point (coef A)
  pk = nc_in->pk; pressure part of Hybrid Coordinate at interface
  am_n = dimsizes(pk) - 1
  am = new (am_n,"float");
  do ai=0,am_n-1
    am(ai) = sqrt(pk(ai)*pk(ai+1))/100000;
  end do 
  am@_FillValue=-1
  am(ind(ismissing(am)))=0

; calculate sigma values of Hybrid Coordinate at mid-point (coef B)
  bk = nc_in->bk; vertical coordinate sigma value at interface

  bm_n = dimsizes(bk) - 1
  bm = new (bm_n,"float");
  do bi=0,bm_n-1
    bm(bi) = (bk(bi)+bk(bi+1))/2.0;
  end do 
  bm@_FillValue=-1
  bm(ind(ismissing(bm)))=0

; define pressure level for output
  lev = (/ 1000, 925, 850, 700, 600, 500, 400, 300, 250, 200, 150, 100, 70, 50, 30, 20, 10, 5, 3, 1/)
  lev!0         = "lev"                
  lev&lev     =  lev                  
  lev@long_name = "pressure"
  lev@units     = "hPa"
  lev@positive  = "down"

  nlev = dimsizes(lev);

; set up function options
  interp = 2; 1:linear 2:log 3:log log
  extrap = True; extrapolation below surface pressure

; remove old one and create new one
  system("rm -f " + NC_F_O);
  out_nc = addfile(NC_F_O,"c");
  filedimdef(out_nc,"time",-1,True);

; convert temperature.
  temp = nc_in->temp;
  var_3d_temp = vinth2p_ecmwf(temp,am,bm,lev,ps,interp,P0,1,extrap,1,tbot,zsurfg) ;

; write converted temperature
  out_nc->temp = var_3d_temp;

; convert specific humidity
  sphum = nc_in->sphum;
  var_3d_humid = vinth2p_ecmwf(sphum,am,bm,lev,ps,interp,P0,1,extrap,0,tbot,zsurfg) ;

; write converted humidity
  out_nc->sphum = var_3d_humid;
  
; calculate virtual temp., real pressure, and surface elevation
  vt = temp*(1. + 0.61*sphum);
  copy_VarCoords(temp,vt);
  P0s = fspan(1000.,1000.,ny);
  P0ss = conform_dims((/nt,ny,nx/),P0s,(/1/));
  presa = pres_sigma(am,P0ss)
  presb = pres_sigma(bm,nps);
  presa@_FillValue=-1
  presb@_FillValue=-1

  ;printVarSummary(presa)
  ;printVarSummary(presb)

  pres = presa+presb
  copy_VarCoords(temp,pres);
  
;  printVarSummary(pres)

  zsurf_con = conform_dims((/nt,ny,nx/),zsurf,(/1,2/));

; calculate geopotential using the hydrostatic equation
  geop = hydro(pres(time|:,lat|:,lon|:,pfull|::-1) \
             ,vt(time|:,lat|:,lon|:,pfull|::-1) \
             ,zsurf_con)
  geop!0 = "time";
  geop!1 = "lat";
  geop!2 = "lon";
  geop!3 = "pfull";

; convert geopotential to pressure level
  var_3d_geop = vinth2p_ecmwf(geop(time|:,pfull|::-1,lat|:,lon|:),am,bm,lev,ps,interp,P0,1,extrap,-1,tbot,zsurfg) ;
  copy_VarCoords(var_3d_humid,var_3d_geop)
; wrtie converted geopotential
  out_nc->hgt = var_3d_geop;

; 3d vars to be converted on pressure level except for temperature and specific humidity
  var_3d = (/"ucomp","vcomp","qo3"/)
  cnt_var_3d = dimsizes(var_3d);

  do vi_3d=0,cnt_var_3d-1
    var_3d_sig = nc_in->$var_3d(vi_3d)$

    var_3d_onP = vinth2p_ecmwf(var_3d_sig,am,bm,lev,ps,interp,P0,1,extrap,0,tbot,zsurfg) ;
;    printVarSummary(var_3d_onP);
    out_nc->$var_3d(vi_3d)$ = var_3d_onP;
  end do
  
  end do
end
