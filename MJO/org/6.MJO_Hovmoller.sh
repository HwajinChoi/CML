#!/bin/bash

for SSS in "ON" "OFF";do
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
 for v1 in "olr" "temp" "wspd";do
 #for v1 in "temp" ;do
# Variable name
# v1="wspd" # olr, temp, wspd
# #v2=""
#---------------------------------------------------------------------------
# Latitude
 lat_s=0
 lat_f=10

 LAT_S="0"
 LAT_F="10N"
#---------------------------------------------------------------------------
 months="6_8" # "11_4"  "6_8" "12_2"
 COLOR="GMT_polar"
 if [ $v1 = "olr" ];then
  MIN=-0.7
  MAX=0.7
  SPACE=0.1
 elif [ $v1 = "temp" ];then
  MIN=-0.25
  MAX=0.25
  SPACE=0.025
 else
  MIN=-1.
  MAX=1.
  SPACE=0.1
 fi
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
 if [ $SSS = "ON" ];then
  s="on"
  else
  s="off"
 fi
 if [ $months = "11_4" ];then
  MONTH="NovApr"
  elif [ $months = "6_8" ];then
  MONTH="JunAug"
  else
  MONTH="DecFeb"
 fi

 if [ $v1 = "temp" ];then
  V1="SST"
  else
  V1=${v1}
 fi

 sed s/LAT_S/${LAT_S}/g ./hj_band_pass_hovmueller_plot.ncl > ./imsi_1.ncl
 sed s/LAT_F/${LAT_F}/g imsi_1.ncl > imsi_2.ncl
 sed s/V1/${V1}/g imsi_2.ncl > imsi_3.ncl
 sed s/SSS/${SSS}/g imsi_3.ncl > imsi_4.ncl
 sed s/COLOR/${COLOR}/g imsi_4.ncl > imsi_5.ncl
 sed s/SPACE/${SPACE}/g imsi_5.ncl > imsi_6.ncl
 sed s/MIN/${MIN}/g imsi_6.ncl > imsi_7.ncl
 sed s/MAX/${MAX}/g imsi_7.ncl > imsi_8.ncl
 sed s/MONTH/${MONTH}/g imsi_8.ncl > ./hj_band_pass_hovmueller_plot_re.ncl
 rm -f ./imsi_?.ncl
#---------------------------------------------------------------------------

cat > imsi.ncl << EOF
load "./hj_band_pass_hovmueller_plot_re.ncl"   
begin

dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/data/$s/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_${SSS}_yesno_num_20000101-20191231.nc","r")
Phase_mjo=f->Phase_mjo ; yes_mjo=1, no_mjo=-1
Phase_num=f->Phase_num
;printVar(Phase_mjo(0:360))
;exit
time=f->time

g1=addfile(dir2+"${v1}_ano_20000101-20191231.nc","r")
${v1}=g1->${v1}Anom(:,{${lat_s}:${lat_f}},:)
${v1}_2=dim_avg_n_Wrap(${v1},1)
grid_xt=g1->grid_xt
dim=dimsizes(${v1}_2)
;------------------------------------------------------------
Phase_mjo_yearly=new((/20,365/),typeof(${v1}_2)); year x day x lon
Phase_num_yearly=new((/20,365/),typeof(${v1}_2)); year x day x lon
${v1}_yearly=new((/20,365,dim(1)/),typeof(${v1}_2)); year x day x lon

do i=0,20-1
 Phase_mjo_yearly(i,:)=Phase_mjo(365*i:365*i+364)
 Phase_num_yearly(i,:)=Phase_num(365*i:365*i+364)
 ${v1}_yearly(i,:,:)=${v1}_2(365*i:365*i+364,:)
end do
Phase_mjo_yearly!0="year"
Phase_mjo_yearly!1="day"
Phase_num_yearly!0="year"
Phase_num_yearly!1="day"
${v1}_yearly!0="year"
${v1}_yearly!1="day"
${v1}_yearly!2="grid_xt"
${v1}_yearly&grid_xt=grid_xt
;---------------------------------------------------------------
; Nov-Apr (11-4, 11-12,+ 1-4)
;---------------------------------------------------------------
Phase_mjo_11_4=new((/20,181/),typeof(${v1}_2))
Phase_num_11_4=new((/20,181/),typeof(${v1}_2))
${v1}_11_4=new((/20,181,dim(1)/),typeof(${v1}_2))
Phase_mjo_11_4(:,0:60)=Phase_mjo_yearly(:,304:364)
Phase_mjo_11_4(:,61:180)=Phase_mjo_yearly(:,0:119)
Phase_num_11_4(:,0:60)=Phase_num_yearly(:,304:364)
Phase_num_11_4(:,61:180)=Phase_num_yearly(:,0:119)
${v1}_11_4(:,0:60,:)=${v1}_yearly(:,304:364,:)
${v1}_11_4(:,61:180,:)=${v1}_yearly(:,0:119,:)
;---------------------------------------------------------------
; Jun-Aug (6-8)
;---------------------------------------------------------------
Phase_mjo_6_8=new((/20,92/),typeof(${v1}_2))
Phase_num_6_8=new((/20,92/),typeof(${v1}_2))
${v1}_6_8=new((/20,92,dim(1)/),typeof(${v1}_2))
Phase_mjo_6_8=Phase_mjo_yearly(:,151:242)
Phase_num_6_8=Phase_num_yearly(:,151:242)
${v1}_6_8=${v1}_yearly(:,151:242,:)
;---------------------------------------------------------------
; Dec-Feb (12-2, 12,+ 1-2)
;---------------------------------------------------------------
Phase_mjo_12_2=new((/20,90/),typeof(${v1}_2))
Phase_num_12_2=new((/20,90/),typeof(${v1}_2))
${v1}_12_2=new((/20,90,dim(1)/),typeof(${v1}_2))
Phase_mjo_12_2(0,0:30)=Phase_mjo_yearly@_FillValue
Phase_mjo_12_2(0,31:89)=Phase_mjo_yearly(0,0:58)
Phase_mjo_12_2(1:19,0:30)=Phase_mjo_yearly(0:18,334:364)
Phase_mjo_12_2(1:19,31:89)=Phase_mjo_yearly(1:19,0:58)

Phase_num_12_2(0,0:30)=Phase_num_yearly@_FillValue
Phase_num_12_2(0,31:89)=Phase_num_yearly(0,0:58)
Phase_num_12_2(1:19,0:30)=Phase_num_yearly(0:18,334:364)
Phase_num_12_2(1:19,31:89)=Phase_num_yearly(1:19,0:58)


${v1}_12_2(0,0:30,:)=${v1}_yearly@_FillValue
${v1}_12_2(0,31:89,:)=${v1}_yearly(0,0:58,:)
${v1}_12_2(1:19,0:30,:)=${v1}_yearly(0:18,334:364,:)
${v1}_12_2(1:19,31:89,:)=${v1}_yearly(1:19,0:58,:)

;*************************************************************************************
; Please, change the name of the "_sel" variables which you want to analysis timeline
;*************************************************************************************
Phase_mjo_sel=Phase_mjo_${months} ; year x day
Phase_num_sel=Phase_num_${months} ; year x day
${v1}_sel=${v1}_${months} ; year x day x lon
;-------------------------------------------------------------------------------------
dim1=dimsizes(${v1}_sel)

Phase_mjo_sel_re=reshape(Phase_mjo_sel,(/dim1(0)*dim1(1)/))
Phase_num_sel_re=reshape(Phase_num_sel,(/dim1(0)*dim1(1)/))
${v1}_sel_re=reshape(${v1}_sel,(/dim1(0)*dim1(1),dim1(2)/))

${v1}_mjo_no_sel=new((/dim1(0)*dim1(1),dim1(2)/),typeof(${v1}_sel))
${v1}_mjo_num_sel=new((/8,dim1(0)*dim1(1),dim1(2)/),typeof(${v1}_sel))
${v1}_mjo_no_sel@_FillValue=${v1}_sel@_FillValue
${v1}_mjo_num_sel@_FillValue=${v1}_sel@_FillValue

do j=0,dim1(0)*dim1(1)-1
 do d=0,dim1(2)-1
   ${v1}_mjo_no_sel(j,d)=where(Phase_mjo_sel_re(j) .eq. -1,${v1}_sel_re(j,d),${v1}_sel_re@_FillValue)
    do m=0,7
     ${v1}_mjo_num_sel(m,j,d)=where(Phase_num_sel_re(j) .eq. m+1,${v1}_sel_re(j,d),${v1}_sel_re@_FillValue)
    end do
 end do
end do

phase=ispan(1,8,1)
${v1}_mjo_num_sel!0="phase"
${v1}_mjo_num_sel!1="time"
${v1}_mjo_num_sel!2="grid_xt"
${v1}_mjo_num_sel&grid_xt=grid_xt
${v1}_mjo_num_sel&phase=phase

${v1}_mjo_num=dim_avg_n_Wrap(${v1}_mjo_num_sel,1)

${v1}_mjo_no_sel!0="time"
${v1}_mjo_no_sel!1="grid_xt"
${v1}_mjo_no_sel&grid_xt=grid_xt

${v1}_mjo_no=dim_avg_n_Wrap(${v1}_mjo_no_sel,0)
${v1}_mjo_no_stdv=dim_stddev_n_Wrap(${v1}_mjo_no_sel,0)

;system("rm -f "+dir1+"${v1}_${SSS}_mjo_no_STDV_${months}_${LAT_S}_${LAT_F}_2000-2019.nc")
;out=addfile(dir1+"${v1}_${SSS}_mjo_no_STDV_${months}_${LAT_S}_${LAT_F}_2000-2019.nc","c")
;out->${v1}_mjo_no_stdv=${v1}_mjo_no_stdv
;exit

${v1}_mjo_num_nor=new((/8,dim1(2)/),typeof(${v1}_sel))

do k=0,7
 ${v1}_mjo_num_nor(k,:)=(${v1}_mjo_num(k,:)-${v1}_mjo_no)/${v1}_mjo_no_stdv
end do
 copy_VarCoords(${v1}_mjo_num,${v1}_mjo_num_nor)

${v1}_mjo_num_nor2=new((/16,dim1(2)/),typeof(${v1}_sel))
${v1}_mjo_num_nor2(0:7,:)=${v1}_mjo_num_nor
${v1}_mjo_num_nor2(8:15,:)=${v1}_mjo_num_nor

${v1}_mjo_num_nor3=${v1}_mjo_num_nor2(:,{30:240})

;----------------------------------------------------------------------------------------
optHov  = False
band_pass_hovmueller_plot(${v1}_mjo_num_nor3,dir3,"png","${v1}_MJO_${SSS}_hovmueller_${months}_${LAT_S}_${LAT_F}_2000-2019",optHov)
end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl
 done
done
