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

f=addfile("${dir4}/olr.daily.jun_aug.1991-2020.nc","r")
olr_for_clim=f->olr ; time x lat x lon
olr_for_indo=olr_for_clim(:,{20:30},{70:80})
olr_for_china=olr_for_clim(:,{15:25},{105:130})

olr_clim_indo1=avg(olr_for_indo)
olr_clim_china1=avg(olr_for_china)


h3=addfile("${dir5}/OLR_indo_11moving_1991-2022_June_Sep.nc","r")
olr_indo=h3->orl
olr_indo_clim=dim_avg_n_Wrap(olr_indo(0:29,:),0)

h4=addfile("${dir5}/OLR_china_11moving_1991-2022_June_Sep.nc","r")
olr_china=h4->orl
olr_china_clim=dim_avg_n_Wrap(olr_china(0:29,:),0)

olr_indo_ano=new((/32,112/),"float")
olr_china_ano=new((/32,112/),"float")

do i=0,31
 olr_indo_ano(i,:)=olr_indo(i,:)-olr_indo_clim
 olr_china_ano(i,:)=olr_china(i,:)-olr_china_clim
end do

copy_VarMeta(olr_indo,olr_indo_ano)
copy_VarMeta(olr_china,olr_china_ano)

olr_indo_ano2=where(olr_indo_ano .gt. 0 .and. olr_indo .lt. olr_clim_indo1,olr_indo_ano,olr_indo@_FillValue)
copy_VarMeta(olr_indo,olr_indo_ano2)
olr_china_ano2=where(olr_china_ano .gt. 0 .and. olr_china .lt. olr_clim_china1,olr_china_ano,olr_china@_FillValue)
copy_VarMeta(olr_china,olr_china_ano2)

OLR=new((/2,32,112/),"float")
OLR(0,:,:)=olr_indo_ano2
OLR(1,:,:)=olr_china_ano2
OLR!0="site"

OLR=OLR*(-1)

;---------------------------------------------------------------------------
B=addfile("${dir2}/hgt.${h}.1991.nc","r")
time=B->time
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11_CLIM=A->hgt_mv_11; year (32) x time (143) 

;---------------------------------------------------------------------------
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)

hgt_mv_area_CLIM=where(hgt_mv_11_CLIM .ge. P,hgt_mv_11_CLIM,hgt_mv_11_CLIM@_FillValue)
copy_VarMeta(hgt_mv_11_CLIM,hgt_mv_area_CLIM)


hgt_mv_4=new((/32,143/),"float")

do F=0,31
 hgt_mv_4(F,:)=where( .not.ismissing(hgt_mv_area_CLIM(0+F,:)), F+1, 0)
end do
hgt_mv_4@_FillValue=0

OLR3=new((/2,32,112/),"float")

do F=0,31
 OLR3(0,F,:)=where(.not.ismissing(OLR(0,F,:)),F+0.85,0) ; indo
 OLR3(1,F,:)=where(.not.ismissing(OLR(1,F,:)),F+1.15,0) ; china
end do
OLR3@_FillValue=0

HGT=new((/32,153/),"float")
HGT=0
HGT(:,6:148)=hgt_mv_4
copy_VarMeta(hgt_mv_area_CLIM,HGT)
HGT@_FillValue=0

;print(HGT(10,:))
;exit

Y=ispan(1991,2022,1)
YY=tostring(Y)

y5=ispan(6,148,1)
AA=new(16,"float")
BB=new(16,"float")
BB1=new(16,"float")
CC1=new(16,"string")
CHINA=new(16,"string")
INDO=new(16,"string")
CC2=new(16,"string")
AA=0
BB=7
BB1=10
CC1="black"
CC2="black"
INDO="gold"
CHINA="purple"
CC2(9)="red" ;2016
CC2(11)="blue" ;2018
CC2(13)="green" ;2020
yyyy=ispan(37,148,1)
;---------------------------------------------------------------------------
wks = gsn_open_wks("png",dir2+"For_COUNT_moving_ANO_CRITERIA_Indo_China_91-22_hgt_${h}_"+per)
plot=new(2,"graphic")
plot1=new(2,"graphic")
plot2=new(2,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@gsnMaximize=True
 ;res@vpHeightF          = 0.8               ; change aspect ratio of plot
 ;res@vpWidthF           = 0.4
 res@trXMinF                  = 32
 res@trXMaxF                  =153
 res@tmYLMode   = "Explicit"
 res@tiYAxisString = "" ; y-axis label
 res@tiXAxisString = ""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.018
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"June","July","Aug","Sep"/)
 res@tmYLValues = ispan(1,16,1)
 res@tmYLLabels = YY(0:15)
 res@tmYLLabelFontHeightF=0.015
 res@tmXBLabelFontHeightF=0.015
 res@gsnXRefLine=(/y(31),y(61),y(92),y(123)/)
 res@gsnXRefLineColors=(/"black","black","black","black"/)
 res@gsnXRefLineDashPatterns=(/1,1,1,1/)
 res@trYMinF                  = 0+0.5
 res@trYMaxF                  =17-0.5
 res@xyDashPatterns      = AA 
 res@xyLineThicknesses    = BB1
 res@gsnLeftString="Daily"
 res@tiXAxisString = "Time"
 res@tiXAxisFontHeightF=0.015
 res@tiYAxisFontHeightF=0.015
 res@gsnLeftString=""
 res@gsnCenterString=""
 res@xyLineColors       = CC1 
 res@gsnYRefLine=(/9.5/)
 res@gsnYRefLineColors=(/"black"/)
 res@gsnYRefLineDashPattern=(/0/)
 plot(0) = gsn_csm_xy (wks,y,HGT(0:15,:),res)
 res@xyLineColors=INDO
 res@xyLineThicknesses    = BB
 plot1(0) = gsn_csm_xy (wks,yyyy,OLR3(0,0:15,:),res)
 res@xyLineColors=CHINA
 plot2(0) = gsn_csm_xy (wks,yyyy,OLR3(1,0:15,:),res)
 delete(res@gsnYRefLine)
 delete(res@gsnYRefLineColors)
 delete(res@gsnYRefLineDashPattern)
 res@gsnYRefLineDashPatterns=(/0,0/)
 res@tmYLValues = ispan(17,32,1)
 res@tmYLLabels = YY(16:31)
 res@gsnYRefLine=(/19.5,29.5/)
 res@gsnYRefLineColors=(/"black","black"/)
 res@xyLineColors       = CC2 
 res@trYMinF                  = 17+0.5
 res@trYMaxF                  =33-0.5
 res@xyLineThicknesses    = BB1
 plot(1) = gsn_csm_xy (wks,y,HGT(16:31,:),res)
 res@xyLineColors=INDO
 res@xyLineThicknesses    = BB
 plot1(1) = gsn_csm_xy (wks,yyyy,OLR3(0,16:31,:),res)
 res@xyLineColors=CHINA
 plot2(1) = gsn_csm_xy (wks,yyyy,OLR3(1,16:31,:),res)
 overlay(plot(0),plot1(0))
 overlay(plot(0),plot2(0))

 overlay(plot(1),plot1(1))
 overlay(plot(1),plot2(1))

; txres               = True
; txres@txFontHeightF = 0.01
; txres@txAngleF      = 90.

 ;gsn_text_ndc(wks, "(36)",  0.98, 0.884, txres);2022
 ;gsn_text_ndc(wks, "(17)",  0.98, 0.866, txres);2021
 ;gsn_text_ndc(wks, "(40)",  0.98, 0.848, txres);2020

 ;gsn_text_ndc(wks, "(18)",  0.98, 0.830, txres);2019
 ;gsn_text_ndc(wks, "(56)",  0.98, 0.812, txres)
 ;gsn_text_ndc(wks, "(22)",  0.98, 0.794, txres)
 ;gsn_text_ndc(wks, "(32)",  0.98, 0.776, txres)
 ;gsn_text_ndc(wks, "(20)",  0.98, 0.758, txres)
 ;gsn_text_ndc(wks, "(11)",  0.98, 0.740, txres)
 ;gsn_text_ndc(wks, "(24)",  0.98, 0.722, txres)
 ;gsn_text_ndc(wks, "(44)",  0.98, 0.704, txres)
 ;gsn_text_ndc(wks, "(8)",  0.98, 0.686, txres)
 ;gsn_text_ndc(wks, "(58)",  0.98, 0.668, txres);2010
;
 ;gsn_text_ndc(wks, "(13)",  0.98, 0.650, txres)
 ;gsn_text_ndc(wks, "(20)",  0.98, 0.632, txres)
 ;gsn_text_ndc(wks, "(23)",  0.98, 0.614, txres)
 ;gsn_text_ndc(wks, "(36)",  0.98, 0.596, txres)
 ;gsn_text_ndc(wks, "(14)",  0.98, 0.578, txres)
 ;gsn_text_ndc(wks, "(20)",  0.98, 0.560, txres)
 ;gsn_text_ndc(wks, "(25)",  0.98, 0.542, txres)
 ;gsn_text_ndc(wks, "(14)",  0.98, 0.524, txres)
 ;gsn_text_ndc(wks, "(32)",  0.98, 0.506, txres)
 ;gsn_text_ndc(wks, "(7)",  0.98, 0.488, txres) ;2000

; gsn_text_ndc(wks, "()",  0.98, 0.470, txres) ; 1999
; gsn_text_ndc(wks, "(20)",  0.98, 0.452, txres)
; gsn_text_ndc(wks, "(13)",  0.98, 0.434, txres)
; gsn_text_ndc(wks, "(15)",  0.98, 0.416, txres)
; gsn_text_ndc(wks, "(32)",  0.98, 0.398, txres)
; gsn_text_ndc(wks, "(36)",  0.98, 0.380, txres)
; gsn_text_ndc(wks, "()",  0.98, 0.362, txres)
; gsn_text_ndc(wks, "(14)",  0.98, 0.344, txres)
; gsn_text_ndc(wks, "(10)",  0.98, 0.326, txres)
; gsn_text_ndc(wks, "(16)",  0.98, 0.308, txres); 1990

; gsn_text_ndc(wks, "(10)",  0.98, 0.290, txres); 1989
; gsn_text_ndc(wks, "(18)",  0.98, 0.272, txres)
; gsn_text_ndc(wks, "(3)",  0.98, 0.254, txres)
; gsn_text_ndc(wks, "(9)",  0.98, 0.236, txres)
; gsn_text_ndc(wks, "(16)",  0.98, 0.218, txres)
; gsn_text_ndc(wks, "(18)",  0.98, 0.200, txres)
; gsn_text_ndc(wks, "(22)",  0.98, 0.182, txres)
; gsn_text_ndc(wks, "(9)",  0.98, 0.164, txres)
; gsn_text_ndc(wks, "(25)",  0.98, 0.146, txres); 1980
; gsn_text_ndc(wks, "()",  0.98, 0.128, txres)
;
pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =      True
pres@gsnPanelXWhiteSpacePercent = 5
;pres@gsnPanelLeft  =0.1
pres@gsnPanelMainString        =   "NPH & NW India, S. China sea | Ano | Clim 6-8 "
;txres               = True                      ; text mods desired
;txres@txFontHeightF = 0.016
;gsn_text_ndc(wks,"W/m~S~2~N~",0.89,0.365,txres)
gsn_panel(wks,plot,(/1,2/),pres)
frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
