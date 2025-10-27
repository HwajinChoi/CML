#!/bin/bash

for h in "200" ;do
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
clim_35=(/0,29.2758,13.8,6.5/)
clim_40=(/0,25,0,0/)
clim_45=(/0,22.84,11.5454,4/)
clim_50=(/0,20.8333,10.2142,0/)
;----------------------------------------------------
HGT_dur_35=new((/5,4/),"float")
HGT_dur_35(0,:)=0
HGT_dur_35(1,0:2)=(/0,0,0/) ;June
HGT_dur_35(2,0:2)=(/51,56,41/) ; Jul
HGT_dur_35(3,0:2)=0 ;Aug
HGT_dur_35(4,0:2)=(/0,0,0/) ; Sep
HGT_dur_35(1,3)=clim_35(0)
HGT_dur_35(2,3)=clim_35(1)
HGT_dur_35(3,3)=clim_35(2)
HGT_dur_35(4,3)=clim_35(3)
HGT_dur_35!0="month"
HGT_dur_35!1="case"
;----------------------------------------------------
HGT_dur_40=new((/5,4/),"float")
HGT_dur_40(0,:)=0
HGT_dur_40(1,0:2)=0
HGT_dur_40(2,0:2)=(/43,54,36/) ; Jul
HGT_dur_40(3,0:2)=0
HGT_dur_40(4,0:2)=0
HGT_dur_40(1,3)=clim_40(0)
HGT_dur_40(2,3)=clim_40(1)
HGT_dur_40(3,3)=clim_40(2)
HGT_dur_40(4,3)=clim_40(3)
;----------------------------------------------------
HGT_dur_40!0="month"
HGT_dur_40!1="case"
;----------------------------------------------------
HGT_dur_45=new((/5,4/),"float")
HGT_dur_45(0,:)=0
HGT_dur_45(1,0:2)=0
HGT_dur_45(2,0:2)=(/41,51,34/) ; Jul
HGT_dur_45(3,0:2)=0
HGT_dur_45(4,0:2)=0 ; Sep
HGT_dur_45(1,3)=clim_45(0)
HGT_dur_45(2,3)=clim_45(1)
HGT_dur_45(3,3)=clim_45(2)
HGT_dur_45(4,3)=clim_45(3)
;----------------------------------------------------
HGT_dur_45!0="month"
HGT_dur_45!1="case"
;----------------------------------------------------
HGT_dur_50=new((/5,4/),"float")
HGT_dur_50(0,:)=0
HGT_dur_50(1,0:2)=0
HGT_dur_50(2,0:2)=(/40,50,0/) ; Jul
HGT_dur_50(3,0:2)=(/0,0,32/)
HGT_dur_50(4,0:2)=0 ; Sep
HGT_dur_50(1,3)=clim_50(0)
HGT_dur_50(2,3)=clim_50(1)
HGT_dur_50(3,3)=clim_50(2)
HGT_dur_50(4,3)=clim_50(3)
;----------------------------------------------------
HGT_dur_50!0="month"
HGT_dur_50!1="case"
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
 res@tmYLMode="Manual"
 res@tmYLTickStartF=0
 res@tmYLTickSpacingF=10
 res@tmYLMinorPerMajor=1
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
 res@gsnCenterString="Tibetan high (200hpa; 2016, 2018, 2020)"
 res@xyLineColors       = (/"red"/)
 res@gsnXYBarChartColors   =(/"red"/)
 plot(0) = gsn_csm_xy (wks,fspan(0.7,4.7,5),HGT_dur_40(:,0),res)
 res@gsnCenterString=""
 res@xyLineColors       = (/"Blue"/)
 res@gsnXYBarChartColors   =(/"blue"/)
 plot(1) = gsn_csm_xy (wks,fspan(0.9,4.9,5),HGT_dur_40(:,1),res)
 res@xyLineColors       = (/"Green"/)
 res@gsnXYBarChartColors   =(/"green"/)
 plot(2) = gsn_csm_xy (wks,fspan(1.1,5.1,5),HGT_dur_40(:,2),res)
 res@xyLineColors       = (/"black"/)
 res@gsnXYBarChartColors   =(/"black"/)
 plot(3) = gsn_csm_xy (wks,fspan(1.3,5.3,5),HGT_dur_40(:,3),res)
 overlay(plot(0),plot(1))
 overlay(plot(0),plot(2))
 overlay(plot(0),plot(3))

 gres = True
 gres@YPosPercent = 94.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 82      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green","Black"/) 
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
