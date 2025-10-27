#!/bin/csh 

#######################################################
# Made by Eun-Hyuk Baek 2016.09.22
# You can change loop command 'foreach' to 'while', if you want.
# You should set up Varialbe lists and level Lists which you want to convert.
# #####################################################

set model1 = F_AMIP_CAM5_2deg_mme
set model2 = F_AMIP_C5UNI_2deg_mme
set model3 = sam0_amip_0000_2deg_NoAdc
set model4 = scam5_A068j_amip_new
set case1 = "2012"
set case2 = "climo36"
set case3 = "climo32"
set season = ANN

set var_3d = '$var_3d(vi_3d)$'
set var_2d = '\$var_2d(vi_2d)$'
set ivar_3d = '\$ivar_3d(ivi_3d)$'

######### Variable Lists ###########
#set var2d = '"QFLX","SHFLX","LHFLX","FLUT","TREFHT","CLDTOT_CAL","CLDLOW_CAL","CLDMED_CAL","CLDHGH_CAL","PSL","PBLH"'
set var2d = '"QFLX","SHFLX","LHFLX","FLUT","TREFHT","CLDTOT","CLDLOW","CLDMED","CLDHGH","PSL","PBLH"'
#set var3d = '"DTCOND","PTTEND","SHDLFT","DPDLFT","TTEND","TTGWORO","CMFDT","DTV","OMEGA","OMEGAT","OMEGAU","T","Q","Z3","U","UU","VT","VU","VV","VQ","RELHUM","V","CLOUD","CLDICE","CLDLIQ"'
set var3d = '"DTCOND","DTV","OMEGA","OMEGAT","T","Q","Z3","U","UU","VT","VU","VV","VQ","RELHUM","V","CLOUD","CLDICE","CLDLIQ"'
set ivar3d = '"CMFMC"' # This is for the variables which get 'ilev' vertical coordinate.


######### Level Lists ##############
set levels = '1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10,7,5,3,2,1'

#set outloc = /home/eunhyuk2/ArcticCloud/WACC_data/
#set inloc = /NAS-data/CESM/${model}/AMIP/MME/

#foreach model ($model1 $model2 $model3)
foreach model ($model4)

#foreach case ($case1 $case2)
foreach case ($case3)

	echo "Start to convert file = "${model}.cam.${case}.${season}.nc
	echo "Making ncl file"

cat <<EOF >! ./convert_temp.ncl
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; read data
  nc_f_in = "${model}.cam.${case}.${season}.nc";
  nc_in = addfile(nc_f_in,"r");

; define output name
  NC_F_O = "converted_${model}.cam.${case}.${season}.nc";

; read 1d or 2d vars for interpolating to pressure level
  ps = nc_in->PS; surface pressure
  phis = nc_in->PHIS; surface geopotential
  tbot = nc_in->TS; bottom temperature
  time = nc_in->time
  lon = nc_in->lon
  lat = nc_in->lat

; set dimension
  nt = dimsizes(time)
  nx = dimsizes(lon)
  ny = dimsizes(lat)

  P0 = 1000.0;

  am = nc_in->hyam
  bm = nc_in->hybm
  ai = nc_in->hyai
  bi = nc_in->hybi

  lev=(/$levels/)
  lev!0         = "lev"
  lev&lev     =  lev
  lev@long_name = "pressure"
  lev@units     = "hPa"
  lev@positive  = "down"

; set up function options
  interp = 2; 1:linear 2:log 3:log log
  extrap = True; extrapolation below surface pressure

; remove old one and create new one
  system("rm -f " + NC_F_O);
  out_nc = addfile(NC_F_O,"c");
  filedimdef(out_nc,"time",-1,True);
; 3d vars to be converted on pressure level

  var_3d = (/$var3d/)
  cnt_var_3d = dimsizes(var_3d);
  do vi_3d=0,cnt_var_3d-1
  var_3d_sig = nc_in->$var_3d

   if ( var_3d(vi_3d).eq."T" ) then
   varflg = 1
   else if ( var_3d(vi_3d).eq."Z3" ) then
   varflg = -1
   else
   varflg = 0
   end if
   end if

    var_3d_onP = vinth2p_ecmwf(var_3d_sig,am,bm,lev,ps,interp,P0,1,extrap,varflg,tbot,phis) ;
    out_nc->$var_3d = var_3d_onP;
  end do

; ilev 3d vars to be converted
  ivar_3d = (/$ivar3d/)
  cnt_ivar_3d = dimsizes(ivar_3d);
  do ivi_3d=0,cnt_ivar_3d-1
     ivar_3d_sig = nc_in->$ivar_3d

 if ( var_3d(ivi_3d).eq."T" ) then
 varflg = 1
 else if ( var_3d(ivi_3d).eq."Z3" ) then
 varflg = -1
 else
 varflg = 0
 end if
 end if

	 ivar_3d_onP = vinth2p_ecmwf(ivar_3d_sig,ai,bi,lev,ps,interp,P0,1,extrap,varflg,tbot,phis) ;
     out_nc->$ivar_3d = ivar_3d_onP;
  end do

; 2d vars to be write
   var_2d = (/$var2d/)
   cnt_var_2d = dimsizes(var_2d);
   do vi_2d=0,cnt_var_2d-1
     var_2d_sig = nc_in->$var_2d
     out_nc->$var_2d = var_2d_sig;
   end do
end
EOF

echo "Complete ncl file"

ncl convert_temp.ncl

rm -rf convert_temp.ncl

cat <<EOF >! converted_${model}.cam.${case}.${season}.ctl
dset ^converted_${model}.cam.${case}.${season}.nc
options 365_day_calendar
tdef time
zdef lev
EOF

end

end

exit
