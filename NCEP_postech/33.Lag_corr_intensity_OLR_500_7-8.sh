#!/bin/bash

for h in "500" ;do
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR
dir5=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
P=0.4
per=flt2string(P)
YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)

NPH=(/1994,1995,2001,2006,2010,2012,2022/)
TH=(/1995,2006,2010,2012,2013,2019,2022/)

h3=addfile("${dir5}/OLR_indo_11moving_1991-2022_June_Sep.nc","r")
olr_indo=h3->orl; year x time
olr_indo=olr_indo*(-1)
olr_indo := olr_indo(:,25:86)

olr_indo_case=new((/3,62/),"float")
olr_indo_case(0,:)=olr_indo(25,:)
olr_indo_case(1,:)=olr_indo(27,:)
olr_indo_case(2,:)=olr_indo(29,:)
olr_indo_case!0="year"

h4=addfile("${dir5}/OLR_china_11moving_1991-2022_June_Sep.nc","r")
olr_china=h4->orl
olr_china=olr_china*(-1)
olr_china := olr_china(:,25:86)

olr_china_case=new((/3,62/),"float")
olr_china_case(0,:)=olr_china(25,:)
olr_china_case(1,:)=olr_china(27,:)
olr_china_case(2,:)=olr_china(29,:)
olr_china_case!0="year"

orl_indo_10=new((/7,62/),"float")
orl_china_10=new((/7,62/),"float")

do i=0,6
 orl_indo_10(i,:)=olr_indo(NPH(i)-1991,:)
 orl_china_10(i,:)=olr_china(NPH(i)-1991,:)
end do
;---------------------------------------------------------------------------
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11=A->hgt_mv_11(:,31:142); year (32) x time (62) 
hgt_mv_11 := hgt_mv_11(:,25:86)

hgt_case=new((/3,62/),"float")
hgt_case(0,:)=hgt_mv_11(25,:)
hgt_case(1,:)=hgt_mv_11(27,:)
hgt_case(2,:)=hgt_mv_11(29,:)
hgt_case!0="case"

hgt_10=new((/7,62/),"float")
do i=0,6
 hgt_10(i,:)=hgt_mv_11(NPH(i)-1991,:)
end do
;---------------------------------------------------------------------------
mylag=15
indo_lead_hgt=esccr(orl_indo_10,hgt_10,mylag)
hgt_lead_indo=esccr(hgt_10,orl_indo_10,mylag)
ccr_indo_10=new((/7,2*mylag+1/),float)
ccr_indo_10(:,0:mylag-1)=hgt_lead_indo(:,1:mylag:-1)
ccr_indo_10(:,mylag:)=indo_lead_hgt(:,0:mylag)

china_lead_hgt=esccr(orl_china_10,hgt_10,mylag)
hgt_lead_china=esccr(hgt_10,orl_china_10,mylag)
ccr_china_10=new((/7,2*mylag+1/),float)
ccr_china_10(:,0:mylag-1)=hgt_lead_china(:,1:mylag:-1)
ccr_china_10(:,mylag:)=china_lead_hgt(:,0:mylag)

indo_case_lead_hgt=esccr(olr_indo_case,hgt_case,mylag)
hgt_case_lead_indo=esccr(hgt_case,olr_indo_case,mylag)
ccr_indo_case=new((/3,2*mylag+1/),float)
ccr_indo_case(:,0:mylag-1)=hgt_case_lead_indo(:,1:mylag:-1)
ccr_indo_case(:,mylag:)=indo_case_lead_hgt(:,0:mylag)

china_case_lead_hgt=esccr(olr_china_case,hgt_case,mylag)
hgt_case_lead_china=esccr(hgt_case,olr_china_case,mylag)
ccr_china_case=new((/3,2*mylag+1/),float)
ccr_china_case(:,0:mylag-1)=hgt_case_lead_china(:,1:mylag:-1)
ccr_china_case(:,mylag:)=china_case_lead_hgt(:,0:mylag)

CCR_indo=new((/10,2*mylag+1/),float)
CCR_indo(0:6,:)=ccr_indo_10
CCR_indo(7:9,:)=ccr_indo_case
CCR_indo2=dim_avg_n_Wrap(CCR_indo,0)

CCR_china=new((/10,2*mylag+1/),float)
CCR_china(0:6,:)=ccr_china_10
CCR_china(7:9,:)=ccr_china_case
CCR_china2=dim_avg_n_Wrap(CCR_china,0)
;---------------------------------------------------------------------------
AA=new(7,"integer")
AA=4
BB=new(7,"integer")
BB=0
CC=new(7,"string")
CC="gray70"
x=ispan(mylag*(-1),mylag,1)
;---------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir2+"7_8_Lag_Corr_OLR_Intensity_hgt_${h}_"+per)
 plot=new(2,"graphic")
 plot1=new(2,"graphic")
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
 res@tiMainString = "NW India"
 res@xyLineThicknesses=AA
 res@xyDashPatterns=BB
 res@xyLineColors=CC
 res2@xyLineColors=COLOR
 res2@xyDashPatterns=(/0,0,0/)
 res2@xyLineThicknesses=(/4,4,4/)
 res3@xyLineColor="black"
 res3@xyLineThicknessF=6
 res3@xyDashPattern=2
 plot(0) = gsn_csm_xy(wks,x,ccr_indo_10,res)       ; All 3 options used...
 plot1(0) = gsn_csm_xy(wks,x,ccr_indo_case,res2)       ; All 3 options used...
 plot2(0) = gsn_csm_xy(wks,x,CCR_indo2,res3)       ; All 3 options used...
 res@tiMainString = "S. China Sea"
 res@tiYAxisString = "" 
 plot(1) = gsn_csm_xy(wks,x,ccr_china_10,res)       ; All 3 options used...
 plot1(1) = gsn_csm_xy(wks,x,ccr_china_case,res2)       ; All 3 options used...
 plot2(1) = gsn_csm_xy(wks,x,CCR_china2,res3)       ; All 3 options used...
 overlay(plot(0),plot1(0))
 overlay(plot(1),plot1(1))
 overlay(plot(0),plot2(0))
 overlay(plot(1),plot2(1))

 gres = True
 gres@YPosPercent = 15.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 55      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 5.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 2.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.02,0.02,0.02/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020"/)  ; legend labels (required)
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =      True
 pres@gsnPanelXWhiteSpacePercent = 5
;pres@gsnPanelLeft  =0.1
 pres@gsnPanelMainString        =   "NPH"
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

