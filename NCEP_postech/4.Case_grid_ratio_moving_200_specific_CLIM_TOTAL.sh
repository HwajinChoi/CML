#!/bin/bash

for h in "200" ;do
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/total

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
P=0.4
per=flt2string(P)
B=addfile("${dir2}/hgt.200.1991.nc","r")
time=B->time
A=addfile("${dir2}/hgt_count_mv_11_1980-2022.nc","r")
hgt_mv_11_CLIM=A->hgt_mv_11; year x time 

;---------------------------------------------------------------------------
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)

hgt_mv_area_CLIM=where(hgt_mv_11_CLIM .ge. P,hgt_mv_11_CLIM,hgt_mv_11_CLIM@_FillValue)
copy_VarMeta(hgt_mv_11_CLIM,hgt_mv_area_CLIM)

hgt_mv_4=new((/43,143/),"float")

do F=0,42
 hgt_mv_4(F,:)=where( .not.ismissing(hgt_mv_area_CLIM(0+F,:)), F+1, 0)
end do
hgt_mv_4@_FillValue=0

HGT=new((/43,153/),"float")
HGT=0
HGT(:,6:148)=hgt_mv_4
copy_VarMeta(hgt_mv_area_CLIM,HGT)
HGT@_FillValue=0

;print(HGT(10,:))
;exit

Y=ispan(1980,2022,1)
YY=tostring(Y)

y5=ispan(6,148,1)
AA=new(43,"float")
BB=new(43,"float")
CC=new(43,"string")
AA=0
BB=10
CC="black"
CC(36)="red" ;2016
CC(38)="blue" ;2018
CC(40)="green" ;2020
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"For_COUNT_moving_CLIM_80-22_hgt_${h}_"+per)
plot=new(1,"graphic")
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
 res@gsnYRefLine=(/10.5,20.5,30.5,40.5/)
 res@gsnYRefLineColors=(/"black","black","black","black"/)
 res@gsnYRefLineDashPatterns=(/0,0,0,0/)
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"June","July","Aug","Sep"/)
 res@tmYLValues = ispan(1,43,1)
 res@tmYLLabels = YY
 res@tmYLLabelFontHeightF=0.01
 res@tmXBLabelFontHeightF=0.015
 res@gsnXRefLine=(/y(31),y(61),y(92),y(123)/)
 res@gsnXRefLineColors=(/"black","black","black","black"/)
 res@gsnXRefLineDashPatterns=(/1,1,1,1/)
 res@trYMinF                  = 0+0.5
 res@trYMaxF                  =44-0.5
 res@xyDashPatterns      = AA 
 res@xyLineThicknesses    = BB 
 res@gsnLeftString="Daily"
 res@tiXAxisString = "Time"
 res@tiXAxisFontHeightF=0.015
 res@tiYAxisFontHeightF=0.015
 res@gsnLeftString=""
 res@gsnCenterString="Tibetan high ( "+per+" ;200hpa; 1980-2022)"
 res@xyLineColors       = CC 
printVarSummary(y)
printVarSummary(HGT)
exit
 plot(0) = gsn_csm_xy (wks,y,HGT,res)

 txres               = True
 txres@txFontHeightF = 0.01
; txres@txAngleF      = 90.

 gsn_text_ndc(wks, "(58)",  0.98, 0.884, txres);2022
 gsn_text_ndc(wks, "(20)",  0.98, 0.866, txres);2021
 gsn_text_ndc(wks, "(36)",  0.98, 0.848, txres);2020

 gsn_text_ndc(wks, "(32)",  0.98, 0.830, txres);2019
 gsn_text_ndc(wks, "(54)",  0.98, 0.812, txres)
 gsn_text_ndc(wks, "(27)",  0.98, 0.794, txres)
 gsn_text_ndc(wks, "(43)",  0.98, 0.776, txres)
 gsn_text_ndc(wks, "(14)",  0.98, 0.758, txres)
 gsn_text_ndc(wks, "(21)",  0.98, 0.740, txres)
 gsn_text_ndc(wks, "(52)",  0.98, 0.722, txres)
 gsn_text_ndc(wks, "(38)",  0.98, 0.704, txres)
 gsn_text_ndc(wks, "(21)",  0.98, 0.686, txres)
 gsn_text_ndc(wks, "(56)",  0.98, 0.668, txres);2010

 gsn_text_ndc(wks, "(19)",  0.98, 0.650, txres)
 gsn_text_ndc(wks, "(22)",  0.98, 0.632, txres)
 gsn_text_ndc(wks, "(21)",  0.98, 0.614, txres)
 gsn_text_ndc(wks, "(50)",  0.98, 0.596, txres)
 gsn_text_ndc(wks, "(14)",  0.98, 0.578, txres)
 gsn_text_ndc(wks, "(9)",  0.98, 0.560, txres)
 gsn_text_ndc(wks, "(13)",  0.98, 0.542, txres)
 gsn_text_ndc(wks, "(13)",  0.98, 0.524, txres)
 gsn_text_ndc(wks, "(14)",  0.98, 0.506, txres)
; gsn_text_ndc(wks, "()",  0.98, 0.488, txres) ;2000

 gsn_text_ndc(wks, "(22)",  0.98, 0.470, txres) ; 1999
 gsn_text_ndc(wks, "(18)",  0.98, 0.452, txres)
 gsn_text_ndc(wks, "(11)",  0.98, 0.434, txres)
 gsn_text_ndc(wks, "(16)",  0.98, 0.416, txres)
 gsn_text_ndc(wks, "(32)",  0.98, 0.398, txres)
 gsn_text_ndc(wks, "(30)",  0.98, 0.380, txres)
; gsn_text_ndc(wks, "()",  0.98, 0.362, txres)
 gsn_text_ndc(wks, "(12)",  0.98, 0.344, txres)
 gsn_text_ndc(wks, "(19)",  0.98, 0.326, txres)
 gsn_text_ndc(wks, "(24)",  0.98, 0.308, txres); 1990

 gsn_text_ndc(wks, "(19)",  0.98, 0.290, txres); 1989
 gsn_text_ndc(wks, "(38)",  0.98, 0.272, txres)
 gsn_text_ndc(wks, "(3)",  0.98, 0.254, txres)
 ;gsn_text_ndc(wks, "()",  0.98, 0.236, txres)
 gsn_text_ndc(wks, "(17)",  0.98, 0.218, txres)
 gsn_text_ndc(wks, "(32)",  0.98, 0.200, txres)
 gsn_text_ndc(wks, "(34)",  0.98, 0.182, txres)
 gsn_text_ndc(wks, "(19)",  0.98, 0.164, txres)
 gsn_text_ndc(wks, "(28)",  0.98, 0.146, txres); 1980
; gsn_text_ndc(wks, "()",  0.98, 0.128, txres)

 draw(plot)
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
