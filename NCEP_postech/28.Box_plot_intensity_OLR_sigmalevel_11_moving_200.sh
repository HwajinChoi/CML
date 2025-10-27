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

h3=addfile("${dir5}/OLR_indo_11moving_1991-2022_June_Sep.nc","r")
olr_indo0=h3->orl(0:29,:); year x time
olr_indo0=olr_indo0*(-1)
olr_indo=h3->orl; year x time
olr_indo=olr_indo*(-1)
olr_indo_for_sig=ndtooned(olr_indo0)
olr_clim_indo1=dim_avg_n_Wrap(olr_indo_for_sig,0)
olr_indo_stdv=stddev(olr_indo_for_sig)
OLR_indo=ndtooned(olr_indo)

olr_indo_case=new((/3,112/),"float")
olr_indo_case(0,:)=olr_indo0(25,:)
olr_indo_case(1,:)=olr_indo0(27,:)
olr_indo_case(2,:)=olr_indo0(29,:)
olr_indo_case!0="case"

h4=addfile("${dir5}/OLR_china_11moving_1991-2022_June_Sep.nc","r")
olr_china0=h4->orl(0:29,:)
olr_china0=olr_china0*(-1)
olr_china=h4->orl
olr_china=olr_china*(-1)
olr_china_for_sig=ndtooned(olr_china0)
olr_clim_china1=dim_avg_n_Wrap(olr_china_for_sig,0)
olr_china_stdv=stddev(olr_china_for_sig)
OLR_china=ndtooned(olr_china)

olr_china_case=new((/3,112/),"float")
olr_china_case(0,:)=olr_china0(25,:)
olr_china_case(1,:)=olr_china0(27,:)
olr_china_case(2,:)=olr_china0(29,:)
olr_china_case!0="case"
;---------------------------------------------------------------------------
III02=olr_clim_indo1+(0.2*olr_indo_stdv)
III04=olr_clim_indo1+(0.4*olr_indo_stdv)
III06=olr_clim_indo1+(0.6*olr_indo_stdv)
III08=olr_clim_indo1+(0.8*olr_indo_stdv)
III10=olr_clim_indo1+(1.0*olr_indo_stdv)
III12=olr_clim_indo1+(1.2*olr_indo_stdv)

CCC02=olr_clim_china1+(0.2*olr_china_stdv)
CCC04=olr_clim_china1+(0.4*olr_china_stdv)
CCC06=olr_clim_china1+(0.6*olr_china_stdv)
CCC08=olr_clim_china1+(0.8*olr_china_stdv)
CCC10=olr_clim_china1+(1.0*olr_china_stdv)
CCC12=olr_clim_china1+(1.2*olr_china_stdv)
;---------------------------------------------------------------------------
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11=A->hgt_mv_11(:,31:142); year (32) x time (112) 
HGT=ndtooned(hgt_mv_11)

hgt_case=new((/3,112/),"float")
hgt_case(0,:)=hgt_mv_11(25,:)
hgt_case(1,:)=hgt_mv_11(27,:)
hgt_case(2,:)=hgt_mv_11(29,:)
hgt_case!0="case"
;---------------------------------------------------------------------------
hgt_indo_01=where(OLR_indo .ge. olr_clim_indo1 .and. OLR_indo .lt. III02,HGT,HGT@_FillValue)
hgt_indo_02=where(OLR_indo .ge. III02 .and. OLR_indo .lt. III04,HGT,HGT@_FillValue)
hgt_indo_03=where(OLR_indo .ge. III04 .and. OLR_indo .lt. III06,HGT,HGT@_FillValue)
hgt_indo_04=where(OLR_indo .ge. III06 .and. OLR_indo .lt. III08,HGT,HGT@_FillValue)
hgt_indo_05=where(OLR_indo .ge. III08 .and. OLR_indo .lt. III10,HGT,HGT@_FillValue)
hgt_indo_06=where(OLR_indo .ge. III10 .and. OLR_indo .lt. III12,HGT,HGT@_FillValue)

hgt_indo_case_01=where(olr_indo_case .ge. olr_clim_indo1 .and. olr_indo_case .lt. III02,hgt_case,hgt_case@_FillValue)
hgt_indo_case_02=where(olr_indo_case .ge. III02 .and. olr_indo_case .lt. III04,hgt_case,hgt_case@_FillValue)
hgt_indo_case_03=where(olr_indo_case .ge. III04 .and. olr_indo_case .lt. III06,hgt_case,hgt_case@_FillValue)
hgt_indo_case_04=where(olr_indo_case .ge. III06 .and. olr_indo_case .lt. III08,hgt_case,hgt_case@_FillValue)
hgt_indo_case_05=where(olr_indo_case .ge. III08 .and. olr_indo_case .lt. III10,hgt_case,hgt_case@_FillValue)
hgt_indo_case_06=where(olr_indo_case .ge. III10 .and. olr_indo_case .lt. III12,hgt_case,hgt_case@_FillValue)
copy_VarMeta(hgt_case,hgt_indo_case_01)
copy_VarMeta(hgt_case,hgt_indo_case_02)
copy_VarMeta(hgt_case,hgt_indo_case_03)
copy_VarMeta(hgt_case,hgt_indo_case_04)
copy_VarMeta(hgt_case,hgt_indo_case_05)
copy_VarMeta(hgt_case,hgt_indo_case_06)
I_01=dim_median_n(hgt_indo_case_01,1)
I_02=dim_median_n(hgt_indo_case_02,1)
I_03=dim_median_n(hgt_indo_case_03,1)
I_04=dim_median_n(hgt_indo_case_04,1)
I_05=dim_median_n(hgt_indo_case_05,1)
I_06=dim_median_n(hgt_indo_case_06,1)

I_2016=new((/6/),"float")
I_2016(0)=I_01(0)
I_2016(1)=I_02(0)
I_2016(2)=I_03(0)
I_2016(3)=I_04(0)
I_2016(4)=I_05(0)
I_2016(5)=I_06(0)

I_2018=new((/6/),"float")
I_2018(0)=I_01(1)
I_2018(1)=I_02(1)
I_2018(2)=I_03(1)
I_2018(3)=I_04(1)
I_2018(4)=I_05(1)
I_2018(5)=I_06(1)

I_2020=new((/6/),"float")
I_2020(0)=I_01(2)
I_2020(1)=I_02(2)
I_2020(2)=I_03(2)
I_2020(3)=I_04(2)
I_2020(4)=I_05(2)
I_2020(5)=I_06(2)
;---------------------------------------------------------------------------
hgt_china_01=where(OLR_china .ge. olr_clim_china1 .and. OLR_china .lt. CCC02,HGT,HGT@_FillValue)
hgt_china_02=where(OLR_china .ge. CCC02 .and. OLR_china .lt. CCC04,HGT,HGT@_FillValue)
hgt_china_03=where(OLR_china .ge. CCC04 .and. OLR_china .lt. CCC06,HGT,HGT@_FillValue)
hgt_china_04=where(OLR_china .ge. CCC06 .and. OLR_china .lt. CCC08,HGT,HGT@_FillValue)
hgt_china_05=where(OLR_china .ge. CCC08 .and. OLR_china .lt. CCC10,HGT,HGT@_FillValue)
hgt_china_06=where(OLR_china .ge. CCC10 .and. OLR_china .lt. CCC12,HGT,HGT@_FillValue)

hgt_china_case_01=where(olr_china_case .ge. olr_clim_china1 .and. olr_china_case .lt. CCC02,hgt_case,hgt_case@_FillValue)
hgt_china_case_02=where(olr_china_case .ge. CCC02 .and. olr_china_case .lt. CCC04,hgt_case,hgt_case@_FillValue)
hgt_china_case_03=where(olr_china_case .ge. CCC04 .and. olr_china_case .lt. CCC06,hgt_case,hgt_case@_FillValue)
hgt_china_case_04=where(olr_china_case .ge. CCC06 .and. olr_china_case .lt. CCC08,hgt_case,hgt_case@_FillValue)
hgt_china_case_05=where(olr_china_case .ge. CCC08 .and. olr_china_case .lt. CCC10,hgt_case,hgt_case@_FillValue)
hgt_china_case_06=where(olr_china_case .ge. CCC10 .and. olr_china_case .lt. CCC12,hgt_case,hgt_case@_FillValue)
copy_VarMeta(hgt_case,hgt_china_case_01)
copy_VarMeta(hgt_case,hgt_china_case_02)
copy_VarMeta(hgt_case,hgt_china_case_03)
copy_VarMeta(hgt_case,hgt_china_case_04)
copy_VarMeta(hgt_case,hgt_china_case_05)
copy_VarMeta(hgt_case,hgt_china_case_06)
C_01=dim_median_n(hgt_china_case_01,1)
C_02=dim_median_n(hgt_china_case_02,1)
C_03=dim_median_n(hgt_china_case_03,1)
C_04=dim_median_n(hgt_china_case_04,1)
C_05=dim_median_n(hgt_china_case_05,1)
C_06=dim_median_n(hgt_china_case_06,1)

C_2016=new((/6/),"float")
C_2016(0)=C_01(0)
C_2016(1)=C_02(0)
C_2016(2)=C_03(0)
C_2016(3)=C_04(0)
C_2016(4)=C_05(0)
C_2016(5)=C_06(0)

C_2018=new((/6/),"float")
C_2018(0)=C_01(1)
C_2018(1)=C_02(1)
C_2018(2)=C_03(1)
C_2018(3)=C_04(1)
C_2018(4)=C_05(1)
C_2018(5)=C_06(1)

C_2020=new((/6/),"float")
C_2020(0)=C_01(2)
C_2020(1)=C_02(2)
C_2020(2)=C_03(2)
C_2020(3)=C_04(2)
C_2020(4)=C_05(2)
C_2020(5)=C_06(2)
;---------------------------------------------------------------------------
;y(n,0)=bottom_value, y(n,1)=bottom_value_of_box, y(n,2)=mid-value_of_box, y(n,3)=top_value_of_box, y(n,4)=top_value.
;---------------------------------------------------------------------------
L1=stat_dispersion(hgt_indo_01,True)
L2=stat_dispersion(hgt_indo_02,True)
L3=stat_dispersion(hgt_indo_03,True)
L4=stat_dispersion(hgt_indo_04,True)
L5=stat_dispersion(hgt_indo_05,True)
L6=stat_dispersion(hgt_indo_06,True)

S1=stat_dispersion(hgt_china_01,True)
S2=stat_dispersion(hgt_china_02,True)
S3=stat_dispersion(hgt_china_03,True)
S4=stat_dispersion(hgt_china_04,True)
S5=stat_dispersion(hgt_china_05,True)
S6=stat_dispersion(hgt_china_06,True)

INDO=new((/6,5/),"float"); for box plot
INDO(0,0)=L1(2)
INDO(0,1)=L1(6)
INDO(0,2)=L1(8)
INDO(0,3)=L1(10)
INDO(0,4)=L1(14)

INDO(1,0)=L2(2)
INDO(1,1)=L2(6)
INDO(1,2)=L2(8)
INDO(1,3)=L2(10)
INDO(1,4)=L2(14)

INDO(2,0)=L3(2)
INDO(2,1)=L3(6)
INDO(2,2)=L3(8)
INDO(2,3)=L3(10)
INDO(2,4)=L3(14)

INDO(3,0)=L4(2)
INDO(3,1)=L4(6)
INDO(3,2)=L4(8)
INDO(3,3)=L4(10)
INDO(3,4)=L4(14)

INDO(4,0)=L5(2)
INDO(4,1)=L5(6)
INDO(4,2)=L5(8)
INDO(4,3)=L5(10)
INDO(4,4)=L5(14)

INDO(5,0)=L6(2)
INDO(5,1)=L6(6)
INDO(5,2)=L6(8)
INDO(5,3)=L6(10)
INDO(5,4)=L6(14)

CHINA=new((/6,5/),"float"); for box plot
CHINA(0,0)=S1(2)
CHINA(0,1)=S1(6)
CHINA(0,2)=S1(8)
CHINA(0,3)=S1(10)
CHINA(0,4)=S1(14)

CHINA(1,0)=S2(2)
CHINA(1,1)=S2(6)
CHINA(1,2)=S2(8)
CHINA(1,3)=S2(10)
CHINA(1,4)=S2(14)

CHINA(2,0)=S3(2)
CHINA(2,1)=S3(6)
CHINA(2,2)=S3(8)
CHINA(2,3)=S3(10)
CHINA(2,4)=S3(14)

CHINA(3,0)=S4(2)
CHINA(3,1)=S4(6)
CHINA(3,2)=S4(8)
CHINA(3,3)=S4(10)
CHINA(3,4)=S4(14)

CHINA(4,0)=S5(2)
CHINA(4,1)=S5(6)
CHINA(4,2)=S5(8)
CHINA(4,3)=S5(10)
CHINA(4,4)=S5(14)

CHINA(5,0)=S6(2)
CHINA(5,1)=S6(6)
CHINA(5,2)=S6(8)
CHINA(5,3)=S6(10)
CHINA(5,4)=S6(14)

x=(/1,2,3,4,5,6/)
colors=new(6,"string")
colors="black"

;---------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir2+"Box_plot_6-9_OLR_sigma_Intensity_hgt_${h}_"+per)
 plot=new(2,"graphic")
 res   = True
 ;res@gsnDraw            = False             ; don't draw yet
 ;res@gsnFrame           = False             ; don't advance frame yet
 res@gsnMaximize = True                        ; Maximize box plot in frame.
 ;res@vpHeightF          = 0.4               ; change aspect ratio of plot
 ;res@vpWidthF           = 0.6
 res@trXMinF            = 0
 res@trXMaxF            =7
 res@trYMinF                  = 0
 res@trYMaxF                  = 1
 res@tmXBLabels=(/"0.2","0.4","0.6","0.8","1.0","1.2"/)
 res@tiXAxisString = "OLR" ; y-axis label
 res@tiYAxisString = "Intensity" 
 res@tiMainString = "NW India (Jun-Sep)"
 ;**********************************************
; resources for polylines that draws the boxes
;**********************************************  
  llres                   = True                        
  llres@gsLineThicknessF  = 2.5                 ; line thickness 
;**********************************************
; resources that control color and width of boxes
;**********************************************  
  opti          = True                  
  opti@boxWidth = 0.7                           ; Width of box (x units)
  opti@boxColors = colors 
;***********************************************
;***********************************************
  plot(0) = boxplot(wks,x,INDO,opti,res,llres)       ; All 3 options used...
  res@tiMainString = "S. China Sea (Jun-Sep)"
  plot(1) = boxplot(wks,x,CHINA,opti,res,llres)       ; All 3 options used...
;***********************************************
; add some polymarkers
;***********************************************
  mres               = True                     ; marker mods desired
  mres@gsMarkerIndex = 1                        ; polymarker style
  mres@gsMarkerSizeF = 40.                      ; polymarker size
  mres@gsMarkerColor = "red"                    ; polymarker color
  dum1 = gsn_add_polymarker(wks,plot(0),x,I_2016,mres) 
  dum4 = gsn_add_polymarker(wks,plot(1),x,C_2016,mres) 
  mres@gsMarkerColor = "blue"                    ; polymarker color
  dum2 = gsn_add_polymarker(wks,plot(0),x,I_2018,mres) 
  dum5 = gsn_add_polymarker(wks,plot(1),x,C_2018,mres) 
  mres@gsMarkerColor = "green"                    ; polymarker color
  dum3 = gsn_add_polymarker(wks,plot(0),x,I_2020,mres) 
  dum6 = gsn_add_polymarker(wks,plot(1),x,C_2020,mres) 

 gres = True
 gres@YPosPercent = 97.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 82      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 2.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.018,0.018,0.018/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020"/)  ; legend labels (required)
 ;plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 ;plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =      True
 pres@gsnPanelXWhiteSpacePercent = 5
;pres@gsnPanelLeft  =0.1
 pres@gsnPanelMainString        =   "TH"

txres               = True                      ; text mods desired
txres@txFontHeightF = 0.016
txres@txFuncCode    = ":" 
gsn_text_ndc(wks,":F8:s",0.17,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.223,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.278,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.333,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.386,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.441,0.267,txres)

gsn_text_ndc(wks,":F8:s",0.67,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.722,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.778,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.832,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.888,0.267,txres)
gsn_text_ndc(wks,":F8:s",0.942,0.267,txres)

 gsn_panel(wks,plot,(/1,2/),pres)
  
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done

