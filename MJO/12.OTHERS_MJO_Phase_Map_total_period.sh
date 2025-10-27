#!/bin/bash
for SSS in "cobalt" "daily_chl" ;do

 if [ $SSS = "cobalt" ];then
  s="ON"
 else
  s="OFF"
 fi

 F=""

 for V in "tos" "ucomp.1000hpa" "hfls" "chlos";do
  for months in "6_8" "12_2" ;do
   if [ $V = "ucomp.1000hpa" ];then
     v="ucomp"
     D="BlueDarkRed18"  
     E="[m/s]"
    if [ $months = "12_2" ];then
     season="DJF"
     A="res@cnMaxLevelValF         =      3"
     B="res@cnMinLevelValF         =      -3"
     C="res@cnLevelSpacingF        =       0.5"
    else
     season="JJA"
     A="res@cnMaxLevelValF         =      3.5"
     B="res@cnMinLevelValF         =      -3.5"
     C="res@cnLevelSpacingF        =       0.5"
    fi
   elif [ $V = "tos" ];then
    v=$V
    D="temp_diff_18lev"
    E="[~S~o~N~C]"
    if [ $months = "12_2" ];then
     season="DJF"
     A="res@cnMaxLevelValF         =      0.7"
     B="res@cnMinLevelValF         =      -0.7"
     C="res@cnLevelSpacingF        =       0.1"
    else
     season="JJA"
     A="res@cnMaxLevelValF         =      0.7"
     B="res@cnMinLevelValF         =      -0.7"
     C="res@cnLevelSpacingF        =       0.1"
    fi
   elif [ $V = "hfls" ];then
    v=$V
    D="BlueDarkRed18"
    E="[W m-2]"
    if [ $months = "12_2" ];then
     season="DJF"
     A="res@cnMaxLevelValF         =      35"
     B="res@cnMinLevelValF         =      -35"
     C="res@cnLevelSpacingF        =       5"
    else
     season="JJA"
     A="res@cnMaxLevelValF         =      35"
     B="res@cnMinLevelValF         =      -35"
     C="res@cnLevelSpacingF        =       5"
    fi
   else 
    v=$V
    D="BlueGreen14"
    E="[mg m-3]"
    F="Pattern = Pattern*10^6" # only for CHL 
    if [ $months = "12_2" ];then
     season="DJF"
     A="res@cnMaxLevelValF         =      0.1"
     B="res@cnMinLevelValF         =      -0.1"
     C="res@cnLevelSpacingF        =       0.01"
    else
     season="JJA"
     A="res@cnMaxLevelValF         =      0.1"
     B="res@cnMinLevelValF         =      -0.1"
     C="res@cnLevelSpacingF        =       0.01"
    fi
   fi

cat > imsi.ncl << EOF
begin
dir0="/media/cmlws/Data2/hjc/MJO/data/RE/${s}/"
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"${V}_map_${SSS}_${months}_MJO_Phase_8_total_period.nc","r")
Pattern=f->${v}_pattern
$F
grid_yt=f->grid_yt
grid_xt=f->grid_xt

plot=new(8,graphic)
wks=gsn_open_wks("png",dir2+"MJO_${V}_${s}_${months}_Phase_Map_total_period")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@vpHeightF=0.2
;res@vpWidthF=0.8
res@cnFillOn             = True         ; turn on color fill
res@cnLineLabelsOn         =       False
res@cnLinesOn            = False         ; True is default
res@lbLabelBarOn         = False        ; turn off individual lb's
res@gsnAddCyclic=False
res@mpCenterLonF         = 180.         ; defailt is 0 [GM]
res@mpMinLatF            =-20
res@mpMaxLatF            =20
res@mpMinLonF            = 0
res@mpMaxLonF            = 360
res@mpShapeMode  = "FreeAspect"
res@mpFillDrawOrder      = "PostDraw"
res@mpLandFillColor      = "transparent"
res@tmXBLabelFontHeightF   =       0.012
res@tmYLLabelFontHeightF   =       0.012
;res@tmYLMinorPerMajor=1
res@gsnLeftStringFontHeightF=0.028
res@gsnRightStringFontHeightF=0.023
res@tmYLLabelStride     =       2
res@tmXBLabelStride     =       2
res@pmLabelBarOrthogonalPosF=0.35
res@gsnCenterStringFontHeightF=0.04
res@gsnCenterStringOrthogonalPosF=0.15
res@pmLabelBarWidthF=0.75
res@lbLabelFontHeightF  = 0.03
res@gsnLeftString  =""
res@gsnCenterString  =""
res@cnFillPalette        = "$D"
res@cnLevelSelectionMode   =       "ManualLevels"
$A
$B
$C

resP                     = True         ; modify the panel plot
resP@gsnMaximize         = False         ; large format
resP@gsnPanelLabelBar    = True         ; add common colorbar
resP@gsnPanelMainString  = "${V} ; ${s} ; ${season}; 1990-2009"
resP@lbLabelFontHeightF  = 0.012
;resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelLeft=0.12
resP@gsnPanelBottom=0.05

res@gsnRightString = "$E"
plot(0) = gsn_csm_contour_map(wks,Pattern(0,:,:),res)
res@gsnRightString = ""
plot(1) = gsn_csm_contour_map(wks,Pattern(1,:,:),res)
plot(2) = gsn_csm_contour_map(wks,Pattern(2,:,:),res)
plot(3) = gsn_csm_contour_map(wks,Pattern(3,:,:),res)
plot(4) = gsn_csm_contour_map(wks,Pattern(4,:,:),res)
plot(5) = gsn_csm_contour_map(wks,Pattern(5,:,:),res)
plot(6) = gsn_csm_contour_map(wks,Pattern(6,:,:),res)
plot(7) = gsn_csm_contour_map(wks,Pattern(7,:,:),res)
txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.018
gsn_text_ndc(wks,"Phase 1",0.12,0.90,txres1)
gsn_text_ndc(wks,"Phase 2",0.12,0.79,txres1)
gsn_text_ndc(wks,"Phase 3",0.12,0.68,txres1)
gsn_text_ndc(wks,"Phase 4",0.12,0.57,txres1)
gsn_text_ndc(wks,"Phase 5",0.12,0.46,txres1)
gsn_text_ndc(wks,"Phase 6",0.12,0.35,txres1)
gsn_text_ndc(wks,"Phase 7",0.12,0.245,txres1)
gsn_text_ndc(wks,"Phase 8",0.12,0.135,txres1)
gsn_panel(wks,plot,(/8,1/),resP)     ; draw all 'neof' as one plot

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl
  done
 done
done
