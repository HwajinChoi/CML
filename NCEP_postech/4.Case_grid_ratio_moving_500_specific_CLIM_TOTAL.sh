#!/bin/bash

for h in "500" ;do
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
P=0.4
per=flt2string(P)
B=addfile("${dir2}/hgt.500.1991.nc","r")
time=B->time
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11_CLIM=A->hgt_mv_11; year x time 

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
AA=new(32,"float")
BB=new(32,"float")
CC=new(32,"string")
AA=0
BB=10
CC="black"
CC(25)="red" ;2016
CC(27)="blue" ;2018
CC(29)="green" ;2020
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"For_New_For_COUNT_moving_CLIM_91-22_hgt_${h}_"+per)
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
 res@tmYLValues = ispan(1,32,1)
 res@tmYLLabels = YY
 res@tmYLLabelFontHeightF=0.01
 res@tmXBLabelFontHeightF=0.015
 res@gsnXRefLine=(/y(31),y(61),y(92),y(123)/)
 res@gsnXRefLineColors=(/"black","black","black","black"/)
 res@gsnXRefLineDashPatterns=(/1,1,1,1/)
 res@trYMinF                  = 0+0.5
 res@trYMaxF                  =33-0.5
 res@xyDashPatterns      = AA 
 res@xyLineThicknesses    = BB 
 res@gsnLeftString="Daily"
 res@tiXAxisString = "Time"
 res@tiXAxisFontHeightF=0.015
 res@tiYAxisFontHeightF=0.015
 res@gsnLeftString=""
 res@gsnCenterString="North Pacific high ( "+per+" ;500hpa; 1991-2022)"
 res@xyLineColors       = CC 
 plot(0) = gsn_csm_xy (wks,y,HGT,res)

 txres               = True
 txres@txFontHeightF = 0.01
; txres@txAngleF      = 90.

 gsn_text_ndc(wks, "(36)",  0.98, 0.882, txres);2022
 gsn_text_ndc(wks, "(17)",  0.98, 0.857, txres);2021
 gsn_text_ndc(wks, "(40)",  0.98, 0.832, txres);2020

 gsn_text_ndc(wks, "(18)",  0.98, 0.807, txres);2019
 gsn_text_ndc(wks, "(56)",  0.98, 0.783, txres)
 gsn_text_ndc(wks, "(22)",  0.98, 0.760, txres)
 gsn_text_ndc(wks, "(32)",  0.98, 0.737, txres)
 gsn_text_ndc(wks, "(20)",  0.98, 0.713, txres)
 gsn_text_ndc(wks, "(11)",  0.98, 0.689, txres)
 gsn_text_ndc(wks, "(24)",  0.98, 0.665, txres)
 gsn_text_ndc(wks, "(44)",  0.98, 0.641, txres)
 gsn_text_ndc(wks, "(8)",  0.98, 0.617, txres)
 gsn_text_ndc(wks, "(58)",  0.98, 0.593, txres);2010

 gsn_text_ndc(wks, "(13)",  0.98, 0.569, txres)
 gsn_text_ndc(wks, "(20)",  0.98, 0.545, txres)
 gsn_text_ndc(wks, "(23)",  0.98, 0.521, txres)
 gsn_text_ndc(wks, "(36)",  0.98, 0.497, txres)
 gsn_text_ndc(wks, "(14)",  0.98, 0.473, txres)
 gsn_text_ndc(wks, "(20)",  0.98, 0.449, txres)
 gsn_text_ndc(wks, "(25)",  0.98, 0.425, txres)
 gsn_text_ndc(wks, "(14)",  0.98, 0.401, txres)
 gsn_text_ndc(wks, "(32)",  0.98, 0.376, txres)
 gsn_text_ndc(wks, "(7)",  0.98, 0.352, txres) ;2000

; gsn_text_ndc(wks, "()",  0.98, 0.328, txres) ; 1999
 gsn_text_ndc(wks, "(20)",  0.98, 0.304, txres)
 gsn_text_ndc(wks, "(13)",  0.98, 0.280, txres)
 gsn_text_ndc(wks, "(15)",  0.98, 0., txres)
 gsn_text_ndc(wks, "(32)",  0.98, 0., txres)
 gsn_text_ndc(wks, "(36)",  0.98, 0., txres)
; gsn_text_ndc(wks, "()",  0.98, 0., txres)
 gsn_text_ndc(wks, "(14)",  0.98, 0., txres)
 gsn_text_ndc(wks, "(10)",  0.98, 0., txres)

 draw(plot)
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
