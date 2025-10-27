#!/bin/bash

for h in "200" ;do
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR
dir5=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/tas/specific/6_9
dir6=/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific/6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
P=0.4
per=flt2string(P)
YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)

NPH=(/1994,1995,2001,2006,2010,2012,2016,2018,2020,2022/)
TH=(/1995,2006,2010,2012,2013,2016,2018,2019,2020,2022/)
NPHs=tostring(NPH)
THs=tostring(TH)

colors_NPH=(/"HotPink","BurlyWood","Coral","darkorchid","deepskyblue","LightSalmon","red","Blue","Green","Gold"/)
colors_TH=(/"BurlyWood","darkorchid","deepskyblue","LightSalmon","DarkSeaGreen","red","Blue","Peru","Green","Gold"/)

hfiles=systemfunc("ls ${dir3}/st*_11moving_1991-2022_June_Sep.nc")
h=addfiles(hfiles,"r")
ListSetType(h,"join")
tas_mv_11=h[:]->tas_mv_11
tas_mv_11!0="site"
tas_mv_11 := tas_mv_11(:,:,25:86)
tas_mv_11_k=dim_avg_n_Wrap(tas_mv_11,0) ; year(1991-2022) x time 62 (6-9)

delete([/hfiles,h/])
hfiles=systemfunc("ls ${dir6}/st*_11moving_1991-2022_June_Sep.nc")
h=addfiles(hfiles,"r")
ListSetType(h,"join")
pr_mv_11=h[:]->pr_mv_11
pr_mv_11!0="site"
pr_mv_11 := pr_mv_11(:,:,25:86)
pr_mv_11_k=dim_avg_n_Wrap(pr_mv_11,0) ; year(1991-2022) x time 62 (6-9)
;-------------------------------------------------------------------
;---------------------------------------------------------------------------
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11=A->hgt_mv_11(:,31:142); year (32) x time (62) 
hgt_mv_11 := hgt_mv_11(:,25:86)

tas_10=new((/10,62/),"float")
pr_10=new((/10,62/),"float")
hgt_10=new((/10,62/),"float")
do i=0,9
 hgt_10(i,:)=hgt_mv_11(TH(i)-1991,:)
 tas_10(i,:)=tas_mv_11_k(TH(i)-1991,:)
 pr_10(i,:)=pr_mv_11_k(TH(i)-1991,:)
end do
;---------------------------------------------------------------------------
mylag=15
hgt_lead_tas=esccr(hgt_10,tas_10,mylag)
tas_lead_hgt=esccr(tas_10,hgt_10,mylag)
ccr_tas_10=new((/10,2*mylag+1/),float)
ccr_tas_10(:,0:mylag-1)=tas_lead_hgt(:,1:mylag:-1)
ccr_tas_10(:,mylag:)=hgt_lead_tas(:,0:mylag)

hgt_lead_pr=esccr(hgt_10,pr_10,mylag)
pr_lead_hgt=esccr(pr_10,hgt_10,mylag)
ccr_pr_10=new((/10,2*mylag+1/),float)
ccr_pr_10(:,0:mylag-1)=pr_lead_hgt(:,1:mylag:-1)
ccr_pr_10(:,mylag:)=hgt_lead_pr(:,0:mylag)
;---------------------------------------------------------------------------
do j=0,9
 H=max(ccr_tas_10(j,16:30))
 if (ccr_tas_10(j,15) .lt. H) then
    print("Temperature = "+TH(j))
 end if

; K=max(ccr_pr_10(j,16:30))
; if (ccr_pr_10(j,15) .lt. K) then
;    print("Precipitation = "+TH(j))
; end if
end do
exit
;---------------------------------------------------------------------------

CCR_tas=new((/10,2*mylag+1/),float)
CCR_tas(:,:)=ccr_tas_10
CCR_tas2=dim_avg_n_Wrap(CCR_tas,0)

CCR_pr=new((/10,2*mylag+1/),float)
CCR_pr(:,:)=ccr_pr_10
CCR_pr2=dim_avg_n_Wrap(CCR_pr,0)
;---------------------------------------------------------------------------
AA=new(10,"integer")
AA=4
BB=new(10,"integer")
BB=0
CC=new(10,"string")
CC="gray70"
x=ispan(mylag*(-1),mylag,1)
;---------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir2+"colors_7_8_Lag_Corr_TAS_PR_Intensity_hgt_${h}_"+per)
 plot=new(2,"graphic")
 plot2=new(2,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@gsnMaximize = True                        ; Maximize box plot in frame.
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.6
 res@trXMinF            = -0.1+mylag*(-1)
 res@trXMaxF            =0.1+mylag
 res@trYMinF                  = -1-0.01
 res@trYMaxF                  = 1+0.01
 res@tmXBMode="Manual"
 res@tmXBTickStartF=(-1)*mylag
 res@tmXBTickSpacingF=5
 res@tmYLMode="Manual"
 res@tmYLTickStartF=-1
 res@tmYLTickSpacingF=0.5
 res2=res
 res3=res
 res@gsnYRefLine=0
 res@gsnYRefLineDashPattern=0
 res@gsnYRefLineThicknessF=2
 res@gsnYRefLineColor=(/"black"/)
 res@gsnXRefLine=0
 res@gsnXRefLineDashPattern=1
 res@gsnXRefLineThicknessF=2
 res@gsnXRefLineColor=(/"black"/)
 ;res@tmXBLabels=(/"0.2","0.4","0.6","0.8","1.0","1.2"/)
 res@tiXAxisString = "Lag (day)" ; y-axis label
 res@tiYAxisString = "Correlation" 
 res@tiMainString = "Temperature"
 res@xyLineThicknesses=AA
 res@xyDashPatterns=BB
 res@xyLineColors=colors_TH
 res3@xyLineColor="black"
 res3@xyLineThicknessF=6
 res3@xyDashPattern=2
 plot(0) = gsn_csm_xy(wks,x,ccr_tas_10,res)       ; All 3 options used...
 plot2(0) = gsn_csm_xy(wks,x,CCR_tas2,res3)       ; All 3 options used...
 res@tiMainString = "Precipitation"
 res@tiYAxisString = "" 
 plot(1) = gsn_csm_xy(wks,x,ccr_pr_10,res)       ; All 3 options used...
 plot2(1) = gsn_csm_xy(wks,x,CCR_pr2,res3)       ; All 3 options used...
 overlay(plot(0),plot2(0))
 overlay(plot(1),plot2(1))

 gres = True
 gres@YPosPercent = 15.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 82      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 5.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 2.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.02,0.02,0.02/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020"/)  ; legend labels (required)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =      True
 pres@gsnPanelXWhiteSpacePercent = 5
;pres@gsnPanelLeft  =0.1
 pres@gsnPanelMainString        =   "TH"
;txres               = True                      ; text mods desired
;txres@txFontHeightF = 0.016
;gsn_text_ndc(wks,":F8:s",0.942,0.267,txres)

 gsn_panel(wks,plot,(/1,2/),pres)
  
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done

