#!/bin/bash

for h in "200" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
P=0.5
per=flt2string(P)
B=addfile("${dir2}/hgt.200.1991.nc","r")
time=B->time
A=addfile("${dir2}/hgt_count_mv_11_1991-2020.nc","r")
hgt_mv_11_CLIM=A->hgt_mv_11; year x time 

h6=addfile("${dir2}/hgt_count_mv_11_avg.nc","r")
hgt_mv_11_avg_org=h6->hgt_mv_11_avg ; for climate value
dim1=dimsizes(hgt_mv_11_avg_org)

hgt_mv_11_CLIM_avg=new((/30,dim1(0)/),"float")

do K=0,29
hgt_mv_11_CLIM_avg(K,:)=hgt_mv_11_avg_org
end do
;---------------------------------------------------------------------------
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)

hgt_mv_11_CLIM_ano=hgt_mv_11_CLIM-hgt_mv_11_CLIM_avg
copy_VarMeta(hgt_mv_11_CLIM_avg,hgt_mv_11_CLIM_ano)

hgt_mv_area_CLIM=where(hgt_mv_11_CLIM .ge. P,hgt_mv_11_CLIM_ano,hgt_mv_11_CLIM@_FillValue)
copy_VarMeta(hgt_mv_11_CLIM,hgt_mv_area_CLIM)

hgt_mv_4=new((/30,143/),"float")

do F=0,29
 hgt_mv_4(F,:)=where( .not.ismissing(hgt_mv_area_CLIM(0+F,:)), F+1, 0)
end do
hgt_mv_4@_FillValue=0

HGT=new((/30,153/),"float")
HGT=0
HGT(:,6:148)=hgt_mv_4
copy_VarMeta(hgt_mv_area_CLIM,HGT)
HGT@_FillValue=0

;imsi=dim_sum(HGT(10,:))
;print(imsi)
print(HGT(29,:))
exit

;---------------------------------------------------------------------------
Y=ispan(1991,2020,1)
YY=tostring(Y)
y5=ispan(6,148,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"For_COUNT_moving_CLIM_91-20_hgt_${h}_"+per)

plot=new(3,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
 res@gsnYRefLine       =0
 res@gsnYRefLineColor = "black"
 res@gsnYRefLineDashPattern=1
 res@trXMinF                  = 1
 ;res@tmYLMode="Manual"
 ;res@tmYLTickStartF=-0.2
 ;res@tmYLTickSpacingF=0.2
 ;res@tmYLMinorPerMajor=3
 res@trXMaxF                  =153
 res@tmYLMode   = "Explicit"
 res@tmYLPrecision=1
 res@tiYAxisString = "Case" ; y-axis label
 res@tiXAxisString = ""
 ;res@gsnXYBarChart            = True
 ;res@gsnXYBarChartBarWidth = 0.2   
 ;res@gsnLeftStringOrthogonalPosF=0.05
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(0),y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"May","June","July","Aug","Sep"/)
 res@tmYLValues = ispan(1,10,1)
 res@tmYLLabels = YY(0:9)
 res@gsnXRefLine=(/y(0),y(31),y(61),y(92),y(123)/)
 res@gsnXRefLineColors=(/"red","red","red","red","red"/)
 res@gsnXRefLineDashPatterns=(/1,1,1,1,1/)
 res@trYMinF                  = 0+0.5
 res@trYMaxF                  =11-0.5
 res2=res
 res3=res
 res@xyDashPatterns      = (/0,0,0,0,0,0,0,0,0,0/)
 res@xyLineThicknesses    = (/10,10,10,10,10,10,10,10,10,10/)
 res@gsnLeftString="Daily"
 res2@xyLineThicknessF=4
 res2@xyLineColor="black"
 res3@xyLineThicknessF=4
 res3@xyLineColor="black"
 res@tiXAxisString = "Time"
 ;res@gsnLeftString="11 days moving"
 res@gsnLeftString=""
 res@gsnCenterString="Tibetan high ( "+per+" ;200hpa;1991-2020)"
 res@xyLineColors       = (/"black","black","black","black","black","black","black","black","black","black"/)
 plot(0) = gsn_csm_xy (wks,y,HGT(0:9,:),res)
 res@gsnCenterString=""
 res@tmYLValues = ispan(11,20,1)
 res@tmYLLabels = YY(10:19)
 res@trYMinF                  = 10+0.5
 res@trYMaxF                  =21-0.5
 plot(1) = gsn_csm_xy (wks,y,HGT(10:19,:),res)
 res@tmYLValues = ispan(21,30,1)
 res@tmYLLabels = YY(20:29)
 res@trYMinF                  = 20+0.5
 res@trYMaxF                  =31-0.5
 res@xyLineColors       = (/"black","black","black","black","black","red","black","blue","black","green"/)
 plot(2) = gsn_csm_xy (wks,y,HGT(20:29,:),res)

 gres = True
 gres@YPosPercent = 94.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.018,0.018,0.018/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020"/)  ; legend labels (required)
 ;plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 txres               = True
 txres@txFontHeightF = 0.012
; txres@txAngleF      = 90.
; gsn_text_ndc(wks, "(3)",  0.78, 0.94, txres)
 gsn_text_ndc(wks, "(5)",  0.78, 0.919, txres)
 gsn_text_ndc(wks, "(10)",  0.78, 0.896, txres)
 gsn_text_ndc(wks, "(3)",  0.78, 0.875, txres)
 gsn_text_ndc(wks, "(13)",  0.78, 0.854, txres)
 gsn_text_ndc(wks, "(16)",  0.78, 0.833, txres)
 gsn_text_ndc(wks, "(23)",  0.78, 0.812, txres)
; gsn_text_ndc(wks, "()",  0.78, 0.791, txres)
 gsn_text_ndc(wks, "(9)",  0.78, 0.770, txres)
 gsn_text_ndc(wks, "(16)",  0.78, 0.749, txres)

 gsn_text_ndc(wks, "(41)",  0.78, 0.607, txres)
 gsn_text_ndc(wks, "(10)",  0.78, 0.586, txres)
; gsn_text_ndc(wks, "()",  0.78, 0.565, txres)
 gsn_text_ndc(wks, "(15)",  0.78, 0.544, txres)
 gsn_text_ndc(wks, "(16)",  0.78, 0.523, txres)
 gsn_text_ndc(wks, "(8)",  0.78, 0.502, txres)
 gsn_text_ndc(wks, "(2)",  0.78, 0.481, txres)
 gsn_text_ndc(wks, "(6)",  0.78, 0.460, txres)
 gsn_text_ndc(wks, "(10)",  0.78, 0.439, txres)
 gsn_text_ndc(wks, "(8)",  0.78, 0.418, txres)

 gsn_text_ndc(wks, "(32)",  0.78, 0.275, txres)
 gsn_text_ndc(wks, "(29)",  0.78, 0.254, txres)
 gsn_text_ndc(wks, "(50)",  0.78, 0.233, txres)
 gsn_text_ndc(wks, "(23)",  0.78, 0.212, txres)
 gsn_text_ndc(wks, "(40)",  0.78, 0.191, txres)
 gsn_text_ndc(wks, "(4)",  0.78, 0.170, txres)
 gsn_text_ndc(wks, "(13)",  0.78, 0.149, txres)
 gsn_text_ndc(wks, "(16)",  0.78, 0.128, txres)
 gsn_text_ndc(wks, "(24)",  0.78, 0.107, txres)
 gsn_text_ndc(wks, "(7)",  0.78, 0.086, txres)


 pres                       =   True
  pres@gsnFrame         = False
  pres@gsnPanelMainString=""
 ; pres@gsnPanelBottom=0.1
 ; pres@gsnPanelLeft=0.05
  pres@gsnPanelLabelBar      = False
  pres@gsnMaximize        =       True
  pres@gsnPanelYWhiteSpacePercent = 4
  pres@gsnPanelRowSpec = False
  gsn_panel(wks,plot,(/3,1/),pres)

 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
