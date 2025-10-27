#!/bin/bash

 months="11_4" #"11_4"  "6_8" "12_2"

 lat_s=-7
 lat_f=-3

 LAT_S="7S"
 LAT_F="3S"

if [ $months = "11_4" ];then
  MONTH="NovApr"
  elif [ $months = "6_8" ];then
  MONTH="JunAug"
  else
  MONTH="DecFeb"
 fi

cat > imsi.ncl << EOF
begin
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

file1=systemfunc("ls "+dir1+"olr_*_mjo_no_STDV_${months}_${LAT_S}_${LAT_F}_2000-2019.nc")
F1=systemfunc("ls "+dir1+"olr_*_mjo_no_STDV_${months}_${LAT_S}_${LAT_F}_2000-2019.nc | head -1")
F2=addfile(F1,"r")
f1=addfiles(file1,"r")
ListSetType(f1,"join")
olr_mjo_no_stdv=f1[:]->olr_mjo_no_stdv
olr_mjo_no_stdv!0="scenario" ; OFF, ON
olr_mjo_no_stdv2=olr_mjo_no_stdv(:,{30:240})
X=F2->grid_xt({30:240})

file2=systemfunc("ls "+dir1+"temp_*_mjo_no_STDV_${months}_${LAT_S}_${LAT_F}_2000-2019.nc")
f2=addfiles(file2,"r")
ListSetType(f2,"join")
temp_mjo_no_stdv=f2[:]->temp_mjo_no_stdv
temp_mjo_no_stdv!0="scenario" ; OFF, ON
temp_mjo_no_stdv2=temp_mjo_no_stdv(:,{30:240})

file3=systemfunc("ls "+dir1+"wspd_*_mjo_no_STDV_${months}_${LAT_S}_${LAT_F}_2000-2019.nc")
f3=addfiles(file3,"r")
ListSetType(f3,"join")
wspd_mjo_no_stdv=f3[:]->wspd_mjo_no_stdv
wspd_mjo_no_stdv!0="scenario" ; OFF, ON
wspd_mjo_no_stdv2=wspd_mjo_no_stdv(:,{30:240})


  wks     = gsn_open_wks("png",dir2+"OLR_TEMP_WSPD_MJO_no_STDV_${months}_${LAT_S}_${LAT_F}_2000-2019")
  plot=new(3,"graphic")
  res                       = True     ; plot mods desired
  res@gsnDraw   = False
  res@gsnFrame  = False
  res@vpWidthF = 0.8
  res@vpHeightF = 0.3
  res@tmYLLabelFontHeightF   =       0.02
  res@tiYAxisString="OLR (w/m~S~2~N~)"
  res@tiXAxisString=""
  res@gsnCenterString="00-19 ${MONTH} No-MJO, Standard Dev., (${LAT_S}-${LAT_F})"
  res@gsnMaximize           = False
  res@gsnPaperOrientation   = "portrait"
  res@xyLineThicknesses=(/3,3/)
  res@xyDashPatterns=(/2,0/)

  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of 
  res@pmLegendParallelPosF   = 0.92                  ; move units right
  res@pmLegendOrthogonalPosF =-0.45                ; move units down
  res@pmLegendWidthF         = 0.09                ; Change width and
  res@pmLegendHeightF        = 0.09                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .02                 ; label font height
  res@xyExplicitLegendLabels = (/"OFF","ON"/)         ; create explicit la

  ;res@tmYLMode              = "Explicit"
  ;res@tmYLValues            = ispan(1,16,1)
  ;res@tmYLLabels            = (/"1","2","3","4","5","6","7","8","1","2","3","4","5","6","7","8"/)
  res@tmXBMode="Explicit"
  res@tmXBValues =ispan(30,240,30)
  res@tmXBLabels=(/"30E","60E","90E","120E","160E","180","150W","120W"/)
  plot(0)=gsn_csm_xy(wks,X,olr_mjo_no_stdv2,res)
  res@tiYAxisString="Wspd (m/s)"
  res@pmLegendSide           = "Bottom"
  res@pmLegendOrthogonalPosF =-0.6                ; move units down
  plot(1)=gsn_csm_xy(wks,X,wspd_mjo_no_stdv2,res)
  res@tiYAxisString="SST (deg C)"
  res@pmLegendSide           = "Top"
  res@pmLegendOrthogonalPosF =-0.45                ; move units down
  plot(2)=gsn_csm_xy(wks,X,temp_mjo_no_stdv2,res)

  pres                        = True
  gsn_panel(wks,plot,(/3,1/),pres)

end
EOF

ncl ./imsi.ncl
rm -f ./imsi.ncl
