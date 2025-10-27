#!/bin/bash

for h in "500" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc") ; 2016, 2018, 2020
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat({43:31})
lon=g->lon({117:137})
time=g->time
P=0.4
per=flt2string(P)

;-----------6,7,8,9--------------------
clim_10=(/19.5,37.1785,21.9285,8.9090/)
clim_15=(/12.,28.2142,17.2857,9.5555/)
clim_20=(/0,0,0,0/)
clim_25=(/0,19.8333,11.5,4.5714/)
;----------------------------------------------------
HGT_dur_10=new((/5,4/),"float")
HGT_dur_10(0,:)=0
HGT_dur_10(1,0:2)=0
HGT_dur_10(2,0:2)=(/51,61,45/) ; Jul
HGT_dur_10(3,0:2)=0
HGT_dur_10(4,0:2)=(/2,12,0/) ; Sep
HGT_dur_10(1,3)=clim_10(0)

HGT_dur_10(2,3)=clim_10(1)
HGT_dur_10(3,3)=clim_10(2)
HGT_dur_10(4,3)=clim_10(3)
;----------------------------------------------------
HGT_dur_10!0="month"
HGT_dur_10!1="case"
;----------------------------------------------------
HGT_dur_15=new((/5,4/),"float")
HGT_dur_15(0,:)=0
HGT_dur_15(1,0:2)=0 ; Jun
HGT_dur_15(2,0:2)=(/38,59,42/) ; Jul
HGT_dur_15(3,0:2)=0
HGT_dur_15(4,0:2)=(/0,8,0/) ; Sep
HGT_dur_15(1,3)=clim_15(0)
HGT_dur_15(2,3)=clim_15(1)
HGT_dur_15(3,3)=clim_15(2)
HGT_dur_15(4,3)=clim_15(3)
;----------------------------------------------------
HGT_dur_15!0="month"
HGT_dur_15!1="case"
;----------------------------------------------------
HGT_dur_20=new((/5,4/),"float")
HGT_dur_20(0,:)=0
HGT_dur_20(1,0:2)=0
HGT_dur_20(2,0:2)=(/32,56,40/) ; Jul
HGT_dur_20(3,0:2)=0
HGT_dur_20(4,0:2)=(/0,2,0/) ; Sep
HGT_dur_20(1,3)=clim_20(0)
HGT_dur_20(2,3)=clim_20(1)
HGT_dur_20(3,3)=clim_20(2)
HGT_dur_20(4,3)=clim_20(3)
;----------------------------------------------------
HGT_dur_20!0="month"
HGT_dur_20!1="case"
;----------------------------------------------------
HGT_dur_25=new((/5,4/),"float")
HGT_dur_25(0,:)=0
HGT_dur_25(1,0:2)=0
HGT_dur_25(2,0:2)=(/29,43,34/) ; Jul
HGT_dur_25(3,0:2)=0
HGT_dur_25(4,0:2)=0 ; Sep
HGT_dur_25(1,3)=clim_25(0)
HGT_dur_25(2,3)=clim_25(1)
HGT_dur_25(3,3)=clim_25(2)
HGT_dur_25(4,3)=clim_25(3)
;----------------------------------------------------
HGT_dur_25!0="month"
HGT_dur_25!1="case"
;----------------------------------------------------
y5=ispan(6,148,1)
y10=ispan(1,5,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"NEW_Duration_moving_2016_2018_2020_clim_hgt_${h}_CLIM_"+per)
plot=new(4,"graphic")
plot1=new(4,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
 res@trXMinF                  = 1
 ;res@tmYLMode="Manual"
 ;res@tmYLTickStartF=-0.2
 ;res@tmYLTickSpacingF=0.2
 ;res@tmYLMinorPerMajor=3
 res@trXMaxF                  =6
 res@trYMinF                  =0 
 res@trYMaxF                  =65
 res@tiYAxisString = "Duration (day)" ; y-axis label
 res@tiXAxisString = ""
 res@gsnXYBarChart            = True
 res@gsnXYBarChartBarWidth = 0.2   
 ;res@gsnLeftStringOrthogonalPosF=0.05
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/2,3,4,5/)
 res@tmXBLabels = (/"June","July","Aug","Sep"/)
 res@xyDashPatterns      = (/0,0,0,0/)
 res@xyLineThicknesses    = (/1,1,1,1/)
 res@gsnLeftString="Daily"
 res@tiXAxisString = "Time"
 ;res@gsnLeftString="11 days moving"
 res@gsnLeftString=""
 res@gsnCenterString="North Pacific high (500hpa; 2016, 2018, 2020)"
 res@xyLineColors       = (/"red"/)
 res@gsnXYBarChartColors   =(/"red"/)
 plot(0) = gsn_csm_xy (wks,fspan(0.7,4.7,5),HGT_dur_20(:,0),res)
 res@gsnCenterString=""
 res@xyLineColors       = (/"Blue"/)
 res@gsnXYBarChartColors   =(/"blue"/)
 plot(1) = gsn_csm_xy (wks,fspan(0.9,4.9,5),HGT_dur_20(:,1),res)
 res@xyLineColors       = (/"Green"/)
 res@gsnXYBarChartColors   =(/"green"/)
 plot(2) = gsn_csm_xy (wks,fspan(1.1,5.1,5),HGT_dur_20(:,2),res)
 res@xyLineColors       = (/"black"/)
 res@gsnXYBarChartColors   =(/"black"/)
 plot(3) = gsn_csm_xy (wks,fspan(1.3,5.3,5),HGT_dur_20(:,3),res)

 overlay(plot(0),plot(1))
 overlay(plot(0),plot(2))
 overlay(plot(0),plot(3))

 gres = True
 gres@YPosPercent = 94.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green","black"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.018,0.018,0.018,0.018/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020","Clim"/)  ; legend labels (required)
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 draw(plot(0))
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
