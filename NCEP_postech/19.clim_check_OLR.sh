#!/bin/bash

dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/spec_6_9
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/clim_6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
;-------------------------------------------------------------------
h=addfile("${dir3}/OLR_indo_11moving_2016_2018_2020_June_Sep.nc","r")
olr_indo=h->orl
olr_indo=olr_indo*(-1)
h2=addfile("${dir3}/OLR_china_11moving_2016_2018_2020_June_Sep.nc","r")
olr_china=h2->orl
olr_china=olr_china*(-1)

h3=addfile("${dir4}/OLR_indo_11moving_1991-2020_June_Sep.nc","r")
olr_indo_CLIM=h3->orl
olr_indo_clim=dim_avg_n_Wrap(olr_indo_CLIM,0)
olr_indo_clim=olr_indo_clim*(-1)

h4=addfile("${dir4}/OLR_china_11moving_1991-2020_June_Sep.nc","r")
olr_china_CLIM=h4->orl
olr_china_clim=dim_avg_n_Wrap(olr_china_CLIM,0)
olr_china_clim=olr_china_clim*(-1)

;olr_indo_ratio=new((/3,112/),"float")
;olr_china_ratio=new((/3,112/),"float")

;do i=0,2
; olr_indo_ratio(i,:)=olr_indo(i,:)/olr_indo_clim
; olr_china_ratio(i,:)=olr_china(i,:)/olr_china_clim
;end do

;copy_VarMeta(olr_indo,olr_indo_ratio)
;copy_VarMeta(olr_china,olr_china_ratio)

;OLR=new((/2,3,112/),"float")
;OLR(0,:,:)=olr_indo_ratio
;OLR(1,:,:)=olr_china_ratio
;OLR!0="site"
;printMinMax(OLR,0)
;exit
;-------------------------------------------------------------------
y=ispan(1,153,1)
;----- 11 days moving; 2016, 2018, 2020-------------------------------------------------------------

;----- FOR CORR -----------------------
;OLR_cases_7_9=OLR(:,:,25:111)

;;;; *hgt_mv_11*(3 case), hgt_mv_11_CLIM ;;;;;; 

y5=ispan(6,148,1)
y2=ispan(37,148,1)
;;; *TAS_mv_11_cases*; case 3 x year 112 (6_9)

YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)
printMinMax(olr_china,0)
printMinMax(olr_china_clim,0)

INDO=new((/4,112/),"float")
INDO(0:2,:)=olr_indo
INDO(3,:)=olr_indo_clim

CHINA=new((/4,112/),"float")
CHINA(0:2,:)=olr_china
CHINA(3,:)=olr_china_clim
;---------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir2+"CLIM_India_china_OLR_specific_years")
 plot=new(2,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.6
 res@trXMinF                  = 62
 res@trXMaxF                  =153
 
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(61),y(92),y(123)/)
 res@tmXBLabels = (/"July","Aug","Sep"/)
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnLeftString=""
 res@gsnCenterString="NW India" 
 res@trYMinF                  = -275
 res@trYMaxF                  = -185
 res@xyLineThicknesses    = (/5.0,5.0,5.0,5.0/)               ; default is 1.0
 res@xyDashPatterns=(/0,0,0,0/)
 res@xyLineColors         = (/"red","blue","green","black"/)
 res@tiYAxisString = "-OLR(W/m~S~2~N~)" ; y-axis label
 res@tiXAxisString = "Time"
 plot(0) = gsn_csm_xy(wks,y2,INDO,res)
 res@gsnCenterString="S. China Sea" 
 plot(1) = gsn_csm_xy(wks,y2,CHINA,res)

 gres = True
 gres@YPosPercent = 94.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 80      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","blue","green","black"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.015,0.015,0.015,0.015/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020","Clim"/)  ; legend labels (required)
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent =5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/2,1/),pres)
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
