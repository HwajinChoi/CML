#!/bin/bash
# HOW TO USE
# This script is for models using namelist. For example, "_r1i1p1_19500101-19541231.nc".
# Only saved file name is diffetent from "vertical_integ_transport.sh" 
# INPUT MUST BE daily PS and EDDY data at presure levels 
# SCRIPT.sh DATA_Name MMF SE TE top_hPa surface_pressure.nc
# e.g) vertical_integ_transport_2.sh BNU-ESM tmp_mmf.nc tmp_se.nc tmp_te.nc 10 tmp_ps.nc
SKIP="NO"
############################################################################
clear
DName=$1;Mmf=$2;Se=$3;Te=$4;TopLV=$5;PS=$6
## IN CASE IF YOU HAVE ERRORS IN VARIABLE NAMES IN GRADS PART, THEN RUN THEM
cdo -s -b 64 -setname,MMF $Mmf tmp_mmf2.nc
 mv -f tmp_mmf2.nc $Mmf
cdo -s -b 64 -setname,SE $Se tmp_se2.nc
 mv -f tmp_se2.nc $Se
cdo -s -b 64 -setname,TE $Te tmp_te2.nc
 mv -f tmp_te2.nc $Te

echo "############################################"
echo "##If there are any blank, check the inputs##"
echo "< INPUTs > "
echo "Data Name : " $DName
echo "MMF(base) : " $Mmf
echo "SE(base) : " $Se
echo "TE(base) : " $Te
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
fi

Tim=`cdo -s -b 64 ntime ${Mmf}`
Vlv=`cdo -s -b 64 nlevel ${Mmf}`
echo "Time of surface presseure :" $Tim
echo "Levels of Mean Meridional Flux :" $Vlv

cat << EOC > calc_vertical_integral_of_eddies.gs
'reinit'
'clear'
'sdfopen ${PS}'
'sdfopen ${Mmf}'
'sdfopen ${Se}'
'sdfopen ${Te}'

'set dfile 1'
'set lon 0 360'
'set lat -90 90'
'set z 1'
'set t 1 ${Tim}'
'define sfcps=pressfc.1'

'set dfile 2'
'set lon 0 360'
'set lat -90 90'
'set t 1 ${Tim}'
'set z 1 ${Vlv}'
'define mmf=MMF.2'

'set dfile 3'
'set lon 0 360'
'set lat -90 90'
'set t 1 ${Tim}'
'set z 1 ${Vlv}'
'define se=SE.3'

'set dfile 4'
'set lon 0 360'
'set lat -90 90'
'set t 1 ${Tim}'
'set z 1 ${Vlv}'
'define te=TE.4'

'set z 1'
'define SE2=vint(sfcps,te,${TopLV})'
'set z 1'
'define TE2=vint(sfcps,te,${TopLV})'
'set z 1'
'define MMF2=vint(sfcps,mmf,${TopLV})'

'set t 1 ${Tim}'
'set z 1'
'set sdfwrite ./verti_integ_SE_${DName}'
'sdfwrite SE2'
'set t 1 ${Tim}'
'set z 1'
'set sdfwrite ./verti_integ_TE_${DName}'
'sdfwrite TE2'
'set t 1 ${Tim}'
'set z 1'
'set sdfwrite ./verti_integ_MMF_${DName}'
'sdfwrite MMF2'
EOC

grads -lxbc calc_vertical_integral_of_eddies.gs

rm -rf tmp_*.nc


