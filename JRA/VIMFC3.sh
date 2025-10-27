#!/bin/bash
# HOW TO USE
# INPUT MUST BE DAILY, PS and U, V, Q at presure levels 
# SCRIPT.sh Result Name spfh ugrd vgrd top_hPa surface_pressure.nc
# Hwa-Jin revised VIMFC.sh.
# e.g) VIMFC.sh result_ spfh.nc ugrd.nc vgrd.nc 100 ps.nc
SKIP="NO"
############################################################################
clear
DName=$1
DQb=$2;DUb=$3;DVb=$4;TopLV=$5;PS=$6
## IN CASE IF YOU HAVE ERRORS IN VARIABLE NAMES IN GRADS PART, THEN RUN THEM
cdo -s -b 64 -setname,spfh $DQb tmp_spfh2.nc
rm -rf tmp_q.nc
cdo -s -b 64 -setcalendar,standard tmp_spfh2.nc tmp_q.nc

cdo -s -b 64 -setname,ugrd $DUb tmp_u2.nc
rm -rf tmp_u.nc
cdo -s -b 64 -setcalendar,standard tmp_u2.nc tmp_u.nc

cdo -s -b 64 -setname,vgrd $DVb tmp_v2.nc
rm -rf tmp_v.nc
cdo -s -b 64 -setcalendar,standard tmp_v2.nc tmp_v.nc
rm -rf tmp_v2.nc tmp_u2.nc tmp_spfh2.nc 

echo "############################################"
echo "##If there are any blank, check the inputs##"
echo "< INPUTs > "
echo "Data Name : " $DName
echo "Q(base) : " $DQb
echo "U(base) : " $DUb	
echo "V(base) : " $DVb
echo "Top Level (hPa) : " $TopLV
echo "Surface Pressure : " $PS
echo "############################################"
# CHECK PS.
if [ ${SKIP} == "NO" ]; then
echo "# CHECKING PS" 
## IF unit was not millibars (mb) in PS, should change to mb (=hPa).
PSMAX=`cdo -s -outputf,%9.9g,9 -timmax -fldmax $PS | cut -d '.' -f 1`
echo "PSMAX: ${PSMAX}"
if [ ${PSMAX} -gt 10000 ]; then
	echo "change surface pressure (PS) unit to millibar"
	cdo -s -L -setunit,hPa -divc,100 ${PS} tmp_mb_ps_hPa.nc
	mv -f tmp_mb_ps_hPa.nc ${PS}
fi
echo "# CHECKING PS DONE" 
num_X=`cdo griddes ${PS} | grep xsize | awk '{print $3}'`
num_Y=`cdo griddes ${PS} | grep ysize | awk '{print $3}'`

#####################################################################
# CALC. VIMFC (VIMFC, HMFC each level)
# DATA SHOULD HAVE SAME NUM. of MONTH! 
# DATA SHOULD HAVE SAME NUM. of Vertical Level! 
echo "# 4. CALC. VIMFC and HMFC"

fi

Tim=`cdo -s -b 64 ntime ${DQb}`
BTim=`cdo -s -b 64 ntime ${DQb}`
Vlv=`cdo -s -b 64 nlevel ${DQb}`

echo "# of timesteps : "$Tim
echo "# Vertical Level : "$Vlv
echo "# Top Level : "$TopLV
echo "# Number of days in base period : "$BTim

cat << EOC > calc_VIMFC_HMFC.gs
'reinit'
'clear'
'sdfopen ${DUb}'
'sdfopen ${DVb}'
'sdfopen ${DQb}'
'sdfopen ${PS}'

'set dfile 4'
'set lon 0 360'
'set lat -90 90'
'set z 1'
'set t 1 ${Tim}'
'define sfcps=pressfc.4'

'set dfile 1'
'set lon 0 360'
'set lat -90 90'
'set z 1 ${Vlv}'
'set t 1 ${BTim}'
'define ugrd=ugrd.1'

'set dfile 2'
'set lon 0 360'
'set lat -90 90'
'set z 1 ${Vlv}'
'set t 1 ${BTim}'
'define vgrd=vgrd.2'

'set dfile 3'
'set lon 0 360'
'set lat -90 90'
'set z 1 ${Vlv}'
'set t 1 ${BTim}'
'define spfh=spfh.3'

'define test=-1*hdivg(spfh*ugrd,spfh*vgrd)'
'define vimfc=vint(sfcps,test,${TopLV})'

'set t 1 ${BTim}'
'set z 1'
'set sdfwrite ./tmp_vimfc.nc'
'sdfwrite vimfc'
EOC
grads -lxbc calc_VIMFC_HMFC.gs
## after grads moisture budget, -1, +1 grid point are added, at the edge of wolrd (e.g. 0E', 360E' of longitude, and 90S, 90N of latitude) with a missing vgrdlues.
## so selindexbox is necesarry for back to the original grid 
#num_Xp=`echo "${num_X} + 1" | bc`
#num_Yp=`echo "${num_Y} + 1" | bc`
num_Xp=`echo "${num_X} " | bc` # for IPSL-CM5A-LR
num_Yp=`echo "${num_Y} " | bc` # for IPSL-CM5A-LR
echo ${num_Xp}
echo ${num_Yp}
cdo -s -b 64 -selindexbox,2,${num_Xp},2,${num_Yp} -setcalendar,standard -setunit,mm/day -mulc,86400 tmp_vimfc.nc vimfc${DName}
rm -f tmp*.nc
echo "# 5. RESULT NC : vimfc_${DName} is generated"
