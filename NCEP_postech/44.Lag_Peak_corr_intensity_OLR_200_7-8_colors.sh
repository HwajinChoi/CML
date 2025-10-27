#!/bin/bash

for h in "200" ;do
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

NPH=(/1994,1995,2001,2006,2010,2012,2016,2018,2020,2022/)
TH=(/1995,2006,2010,2012,2013,2016,2018,2019,2020,2022/)
NPHs=tostring(NPH)
THs=tostring(TH)

colors_NPH=(/"HotPink","BurlyWood","Coral","darkorchid","deepskyblue","LightSalmon","red","Blue","Green","Gold"/)
colors_TH=(/"BurlyWood","darkorchid","deepskyblue","LightSalmon","DarkSeaGreen","red","Blue","Peru","Green","Gold"/)

h3=addfile("${dir5}/OLR_ANO_wide_indo_11moving_1991-2022_June_Sep.nc","r")
olr_indo=h3->orl; year x time
olr_indo=olr_indo*(-1)

h4=addfile("${dir5}/OLR_ANO_china_11moving_1991-2022_June_Sep.nc","r")
olr_china=h4->orl
olr_china=olr_china*(-1)

orl_indo_10=new((/10,112/),"float")
orl_china_10=new((/10,112/),"float")

do i=0,9
 orl_indo_10(i,:)=olr_indo(TH(i)-1991,:)
 orl_china_10(i,:)=olr_china(TH(i)-1991,:)
end do
;---------------------------------------------------------------------------
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11=A->hgt_mv_11(:,31:142); year (32) x time (62) 

hgt_10=new((/10,112/),"float")
do i=0,9
 hgt_10(i,:)=hgt_mv_11(TH(i)-1991,:)
end do
;---------------------------------------------------------------------------
THmax=(/53,72,57,54,58,49,45,56,69,57/)
X=30
olr_indo_2=new((/10,2*X+1/),"float")
olr_china_2=new((/10,2*X+1/),"float")
hgt_2=new((/10,2*X+1/),"float")
do i=0,9
 hgt_2(i,:)=hgt_10(i,THmax(i)-X:THmax(i)+X)
 olr_indo_2(i,:)=orl_indo_10(i,THmax(i)-X:THmax(i)+X)
 olr_china_2(i,:)=orl_china_10(i,THmax(i)-X:THmax(i)+X)
end do
;---------------------------------------------------------------------------
mylag=10
indo_lead_hgt=esccr(olr_indo_2,hgt_2,mylag)
hgt_lead_indo=esccr(hgt_2,olr_indo_2,mylag)
ccr_indo_10=new((/10,2*mylag+1/),float)
ccr_indo_10(:,0:mylag-1)=hgt_lead_indo(:,1:mylag:-1)
ccr_indo_10(:,mylag:)=indo_lead_hgt(:,0:mylag)

china_lead_hgt=esccr(olr_china_2,hgt_2,mylag)
hgt_lead_china=esccr(hgt_2,olr_china_2,mylag)
ccr_china_10=new((/10,2*mylag+1/),float)
ccr_china_10(:,0:mylag-1)=hgt_lead_china(:,1:mylag:-1)
ccr_china_10(:,mylag:)=china_lead_hgt(:,0:mylag)

;---------------------------------------------------------------------------
;do j=0,9
; H=max(ccr_indo_10(j,16:30))
; if (ccr_indo_10(j,15) .lt. H) then
;    print("NW India = "+TH(j))
;end if

; K=max(ccr_china_10(j,16:30))
; if (ccr_china_10(j,15) .lt. K) then
;    print("S. China sea = "+TH(j))
;end if
;end do
;exit
;---------------------------------------------------------------------------

CCR_indo=new((/10,2*mylag+1/),float)
CCR_indo(:,:)=ccr_indo_10
CCR_indo2=dim_avg_n_Wrap(CCR_indo,0)

CCR_china=new((/10,2*mylag+1/),float)
CCR_china(:,:)=ccr_china_10
CCR_china2=dim_avg_n_Wrap(CCR_china,0)
;---------------------------------------------------------------------------
AA=new(10,"integer")
AA=4
BB=new(10,"integer")
BB=0
CC=new(10,"string")
x=ispan(mylag*(-1),mylag,1)
;---------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir2+"colors_PEAK_ANO_OLR_Lag_Corr_Intensity_hgt_${h}_"+per)
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
 res@xyLineColors=colors_TH
 res3@xyLineColor="black"
 res3@xyLineThicknessF=6
 res3@xyDashPattern=2
 plot(0) = gsn_csm_xy(wks,x,ccr_indo_10,res)       ; All 3 options used...
 plot2(0) = gsn_csm_xy(wks,x,CCR_indo2,res3)       ; All 3 options used...
 res@tiMainString = "S. China Sea"
 res@tiYAxisString = "" 
 plot(1) = gsn_csm_xy(wks,x,ccr_china_10,res)       ; All 3 options used...
 plot2(1) = gsn_csm_xy(wks,x,CCR_china2,res3)       ; All 3 options used...
 overlay(plot(0),plot2(0))
 overlay(plot(1),plot2(1))

 gres = True
 gres@YPosPercent = 35.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 75      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 3.
 lineres = True
 lineres@lgLineColors =colors_TH 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 2.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.015,0.015,0.015,0.015,0.015,0.015,0.015,0.015,0.015/)
 textres@lgLabels =THs 

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =      False
 pres@gsnPanelTop=0.9
 pres@gsnPanelBottom=0.4
 pres@gsnPanelXWhiteSpacePercent = 5
;pres@gsnPanelLeft  =0.1
 pres@gsnPanelMainString        =   "TH"
;txres               = True                      ; text mods desired
;txres@txFontHeightF = 0.016
;gsn_text_ndc(wks,":F8:s",0.942,0.267,txres)

 gsn_panel(wks,plot,(/1,2/),pres)
 simple_legend_ndc(wks, gres, lineres, textres)
  
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done

