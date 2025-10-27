#!/bin/bash

for h in "200" ;do
dir0=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/tas/specific/6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
;-------------------------------------------------------------------
hfiles=systemfunc("ls ${dir3}/st*_11moving_1991-2022_June_Sep.nc")
h=addfiles(hfiles,"r")
ListSetType(h,"join")
tas_mv_11=h[:]->tas_mv_11
tas_mv_11!0="site"
tas_mv_11_k=dim_avg_n_Wrap(tas_mv_11,0) ; year(1991-2022) x time 112 (6-9)
tas_mv_11_7_9=tas_mv_11_k(:,25:111); year(32) x time 87 (7-9)

;-------------------------------------------------------------------
TAS=new((/29,87/),"float")
TAS(0:24,:)=tas_mv_11_7_9(0:24,:)
TAS(25,:)=tas_mv_11_7_9(26,:)
TAS(26,:)=tas_mv_11_7_9(28,:)
TAS(27:28,:)=tas_mv_11_7_9(30:31,:)

TAS_mv_11_cases=new((/3,87/),"float")
TAS_mv_11_cases(0,:)=tas_mv_11_7_9(25,:)
TAS_mv_11_cases(1,:)=tas_mv_11_7_9(27,:)
TAS_mv_11_cases(2,:)=tas_mv_11_7_9(29,:)
TAS_mv_11_cases!0="case"
A=addfile("${dir2}/hgt_count_mv_11_1991-2020.nc","r")
hgt_mv_11=A->hgt_mv_11; year(30) x time(143) 
hgt_mv_11_7_9=hgt_mv_11(:,56:142) ; time 87 (7-9)
;-------------------------------------------------------------------
files=systemfunc("ls ${dir0}/hgt.${h}.202[1-2].nc")
f=addfiles(files,"r")
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)
hgt_mask=where(hgt .ge. 12480, 1,0)
copy_VarMeta(hgt,hgt_mask)
test=dim_sum_n_Wrap(hgt_mask,2)
hgt_count=dim_sum_n_Wrap(test,2)
hgt_count2=int2flt(hgt_count)
hgt_count2 := hgt_count2/40.

;----- 11 days moving; 2021, 2022-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_20=new((/2,tp/),"float"); Target
imsi=new((/2,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
  hgt_mv_20(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_20!0="year"
hgt_mv_20!1="time"

hgt_mv_20_7_9=hgt_mv_20(:,56:142)

HGT_mv_11_7_9=new((/32,87/),"float")
HGT_mv_11_7_9(0:29,:)=hgt_mv_11_7_9
HGT_mv_11_7_9(30:31,:)=hgt_mv_20_7_9
;-------------------------------------------------------------------
HGT=new((/29,87/),"float")
HGT(0:24,:)=hgt_mv_11_7_9(0:24,:)
HGT(25,:)=hgt_mv_11_7_9(26,:)
HGT(26,:)=hgt_mv_11_7_9(28,:)
HGT(27:28,:)=hgt_mv_20_7_9

HGT_mv_11_cases=new((/3,87/),"float")
HGT_mv_11_cases(0,:)=hgt_mv_11_7_9(25,:)
HGT_mv_11_cases(1,:)=hgt_mv_11_7_9(27,:)
HGT_mv_11_cases(2,:)=hgt_mv_11_7_9(29,:)
HGT_mv_11_cases!0="case"
;-------------------------------------------------------------------
P=0.4
per=flt2string(P)
;---------------------------------------------------------------------------
y=ispan(1,153,1)
;-------------------------------------------------------------------
;-------------------------------------------------------------------
; TAS => year except 3 years case
; TAS_mv_11_cases => 3 years case
; HGT => year except 3 years case
; HGT_mv_11_cases => 3 years case
;-------------------------------------------------------------------
;-------------------------------------------------------------------
hgt_mv_area_cases=where(HGT_mv_11_cases .ge. P,HGT_mv_11_cases,HGT_mv_11_cases@_FillValue)
copy_VarMeta(HGT_mv_11_cases,hgt_mv_area_cases)
tas_mv_area_cases=where(HGT_mv_11_cases .ge. P,TAS_mv_11_cases,TAS_mv_11_cases@_FillValue)
copy_VarMeta(TAS_mv_11_cases,tas_mv_area_cases)

hgt_mv_area=where(HGT .ge. P,HGT,HGT@_FillValue)
copy_VarMeta(HGT,hgt_mv_area)
tas_mv_area=where(HGT .ge. P,TAS,TAS@_FillValue)
copy_VarMeta(TAS,tas_mv_area)
;------ 7 - 9 -----------------------------------------------------------
hgt_mv_area2=ndtooned(hgt_mv_area)
tas_mv_area2=ndtooned(tas_mv_area)
;------ 7 -----------------------------------------------------------
hgt_mv_area7=ndtooned(hgt_mv_area(:,0:30))
tas_mv_area7=ndtooned(tas_mv_area(:,0:30))
;------ 8 -----------------------------------------------------------
hgt_mv_area8=ndtooned(hgt_mv_area(:,31:61))
tas_mv_area8=ndtooned(tas_mv_area(:,31:61))
;------ 9 -----------------------------------------------------------
hgt_mv_area9=ndtooned(hgt_mv_area(:,62:86))
tas_mv_area9=ndtooned(tas_mv_area(:,62:86))
;-------------------------------------------------------------------
YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)
;-------------- For statistics ----------------------------------------------------
; tas_mv_11_7_9 ; year (32) x time (87) 
; HGT_mv_11_7_9

TAS_for_reg=where(tas_mv_11_7_9 .ge. P,tas_mv_11_7_9,tas_mv_11_7_9@_FillValue)
HGT_for_reg=where(HGT_mv_11_7_9 .ge. P,HGT_mv_11_7_9,HGT_mv_11_7_9@_FillValue)
copy_VarCoords(tas_mv_11_7_9,TAS_for_reg)
copy_VarCoords(HGT_mv_11_7_9,HGT_for_reg)
TAS_for_reg2=ndtooned(TAS_for_reg)
HGT_for_reg2=ndtooned(HGT_for_reg)

TAS_for_reg7=ndtooned(TAS_for_reg(:,0:30))
HGT_for_reg7=ndtooned(HGT_for_reg(:,0:30))

TAS_for_reg8=ndtooned(TAS_for_reg(:,31:61))
HGT_for_reg8=ndtooned(HGT_for_reg(:,31:61))

TAS_for_reg9=ndtooned(TAS_for_reg(:,62:86))
HGT_for_reg9=ndtooned(HGT_for_reg(:,62:86))

rc=regline(HGT_for_reg2,TAS_for_reg2)
rc7=regline(HGT_for_reg7,TAS_for_reg7)
rc8=regline(HGT_for_reg8,TAS_for_reg8)
rc9=regline(HGT_for_reg9,TAS_for_reg9)

corr=escorc(HGT_for_reg2,TAS_for_reg2)
corr7=escorc(HGT_for_reg7,TAS_for_reg7)
corr8=escorc(HGT_for_reg8,TAS_for_reg8)
corr9=escorc(HGT_for_reg9,TAS_for_reg9)

N = num(.not.ismissing(HGT_for_reg2))
N7 = num(.not.ismissing(HGT_for_reg7))
N8 = num(.not.ismissing(HGT_for_reg8))
N9 = num(.not.ismissing(HGT_for_reg9))

;print(corr)
;print(corr7)
;print(corr8)
;print(corr9)
;exit
;---------------------------------------------------------------------------
    mono  = 1                            ; ascending=1 , descending=-1
    i2   :=  dim_pqsort_n(HGT_for_reg2,mono,0)
    i7   :=  dim_pqsort_n(HGT_for_reg7,mono,0)
    i8   :=  dim_pqsort_n(HGT_for_reg8,mono,0)
    i9   :=  dim_pqsort_n(HGT_for_reg9,mono,0)
    x2    := HGT_for_reg2(i2)                       ; ascending order 
    x7    := HGT_for_reg7(i7)                       ; ascending order 
    x8    := HGT_for_reg8(i8)                       ; ascending order 
    x9    := HGT_for_reg9(i9)                       ; ascending order 

    ;y2    := TAS_for_reg2(ii)

yReg = rc*x2 + rc@yintercept  
yReg7 = rc7*x7 + rc7@yintercept  
yReg8 = rc8*x8 + rc8@yintercept  
yReg9 = rc9*x9 + rc9@yintercept  
;---------------------------------------------------------------------------

 wks = gsn_open_wks("png",dir2+"Scatter_OBS_Intensity_hgt_${h}_"+per)
 plot=new(4,"graphic")
 plot1=new(3,"graphic")
 plot7=new(3,"graphic")
 plot8=new(3,"graphic")
 plot9=new(3,"graphic")
 plot10=new(4,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.6
 res@trXMinF            = 0
 res@trXMaxF            =1
 res@gsnLeftStringFontHeightF=0.015
 res@trYMinF                  = 18
 res@trYMaxF                  = 30
 res@tmXBMode="Manual"
 res@tmXBTickStartF=-0.1
 res@tmXBTickSpacingF=0.1
 res@tmXBMinorPerMajor=3
 res@tiXAxisString = "Intensity" ; y-axis label
 res@xyDashPattern      = 0
 res@xyLineThicknessF    = 3.
 res@gsnLeftString= "7-9"
 res@tiYAxisString = "Temperature (~S~o~N~C)"
 res@gsnLeftString=""
 res2 =res
 res@xyMarkLineMode    = "Markers"                ; choose to use markers
 res@xyMarkers         =  16                      ; choose type of marker  
 res@xyMarkerColor     = "black" 
 res@xyMarkerSizeF     = 0.01                     ; Marker size (default 0.01
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnCenterString="July - September"
 plot(0) = gsn_csm_xy (wks,hgt_mv_area2,tas_mv_area2,res)
 res@tiYAxisString = ""
 res@gsnCenterString=""
 res@xyMarkerColor     = COLOR(0)
 plot1(0) = gsn_csm_xy (wks,hgt_mv_area_cases(0,:),tas_mv_area_cases(0,:),res)
 res@xyMarkerColor     = COLOR(1)
 plot1(1) = gsn_csm_xy (wks,hgt_mv_area_cases(1,:),tas_mv_area_cases(1,:),res)
 res@xyMarkerColor     = COLOR(2)
 plot1(2) = gsn_csm_xy (wks,hgt_mv_area_cases(2,:),tas_mv_area_cases(2,:),res)
 res2@xyMarkLineMode    = "Lines"
 res2@xyLineThicknessF   = (/4/)
 res2@xyDashPatterns      = 0 
 res2@xyLineColor       = "gray50"
 plot10(0)=gsn_csm_xy(wks,x2, yReg ,res2)
 overlay(plot(0),plot1(0))
 overlay(plot(0),plot1(1))
 overlay(plot(0),plot1(2))
 overlay(plot(0),plot10(0))

 res@gsnCenterString="July"
 res@xyMarkerColor     = "black" 
 plot(1) = gsn_csm_xy (wks,hgt_mv_area7,tas_mv_area7,res)
 res@gsnCenterString=""
 res@xyMarkerColor     = COLOR(0)
 plot7(0) = gsn_csm_xy (wks,hgt_mv_area_cases(0,0:30),tas_mv_area_cases(0,0:30),res)
 res@xyMarkerColor     = COLOR(1)
 plot7(1) = gsn_csm_xy (wks,hgt_mv_area_cases(1,0:30),tas_mv_area_cases(1,0:30),res)
 res@xyMarkerColor     = COLOR(2)
 plot7(2) = gsn_csm_xy (wks,hgt_mv_area_cases(2,0:30),tas_mv_area_cases(2,0:30),res)
 plot10(1)=gsn_csm_xy(wks,x7, yReg7 ,res2)
 overlay(plot(1),plot7(0))
 overlay(plot(1),plot7(1))
 overlay(plot(1),plot7(2))
 overlay(plot(1),plot10(1))

 res@tiYAxisString = "Temperature (~S~o~N~C)"
 res@gsnCenterString="August"
 res@xyMarkerColor     = "black" 
 plot(2) = gsn_csm_xy (wks,hgt_mv_area8,tas_mv_area8,res)
 res@tiYAxisString = ""
 res@gsnCenterString=""
 res@xyMarkerColor     = COLOR(0)
 plot8(0) = gsn_csm_xy (wks,hgt_mv_area_cases(0,31:61),tas_mv_area_cases(0,31:61),res)
 res@xyMarkerColor     = COLOR(1)
 plot8(1) = gsn_csm_xy (wks,hgt_mv_area_cases(1,31:61),tas_mv_area_cases(1,31:61),res)
 res@xyMarkerColor     = COLOR(2)
 plot8(2) = gsn_csm_xy (wks,hgt_mv_area_cases(2,31:61),tas_mv_area_cases(2,31:61),res)
 plot10(2)=gsn_csm_xy(wks,x8, yReg8 ,res2)
 overlay(plot(2),plot8(0))
 overlay(plot(2),plot8(1))
 overlay(plot(2),plot8(2))
 overlay(plot(2),plot10(2))

 res@gsnCenterString="September"
 res@xyMarkerColor     = "black" 
 plot(3) = gsn_csm_xy (wks,hgt_mv_area9,tas_mv_area9,res)
 res@gsnCenterString=""
 res@xyMarkerColor     = COLOR(0)
 plot9(0) = gsn_csm_xy (wks,hgt_mv_area_cases(0,62:86),tas_mv_area_cases(0,62:86),res)
 res@xyMarkerColor     = COLOR(1)
 plot9(1) = gsn_csm_xy (wks,hgt_mv_area_cases(1,62:86),tas_mv_area_cases(1,62:86),res)
 res@xyMarkerColor     = COLOR(2)
 plot9(2) = gsn_csm_xy (wks,hgt_mv_area_cases(2,62:86),tas_mv_area_cases(2,62:86),res)
 plot10(3)=gsn_csm_xy(wks,x9, yReg9 ,res2)
 overlay(plot(3),plot9(0))
 overlay(plot(3),plot9(1))
 overlay(plot(3),plot9(2))
 overlay(plot(3),plot10(3))

 gres = True
 gres@YPosPercent = 22.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 82      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 2.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.018,0.018,0.018/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020"/)  ; legend labels (required)
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
 plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

 txres               = True
 txres@txFontHeightF = 0.011
; txres@txAngleF      = 90.
 gsn_text_ndc(wks, "corr = 0.50* ",  0.4, 0.59, txres) ; 7-9
 gsn_text_ndc(wks, "corr = 0.49* ",  0.85, 0.59, txres) ; 7
 gsn_text_ndc(wks, "corr = 0.50* ",  0.4, 0.21, txres) ; 8
 gsn_text_ndc(wks, "corr = 0.54* ",  0.85, 0.21, txres) ; 9

 pres             = True
 pres@gsnFrame         = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 7 
 pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/2,2/),pres)
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done
