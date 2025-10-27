#!/bin/bash

for h in "200" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/spec_6_9
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/clim_6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
C=12480
P=0.4
per=flt2string(P)
;-------------------------------------------------------------------
h=addfile("${dir3}/OLR_indo_11moving_2016_2018_2020_June_Sep.nc","r")
olr_indo=h->orl
h2=addfile("${dir3}/OLR_china_11moving_2016_2018_2020_June_Sep.nc","r")
olr_china=h2->orl

h3=addfile("${dir4}/OLR_indo_11moving_1991-2020_June_Sep.nc","r")
olr_indo_CLIM=h3->orl
olr_indo_clim=dim_avg_n_Wrap(olr_indo_CLIM,0)

h4=addfile("${dir4}/OLR_china_11moving_1991-2020_June_Sep.nc","r")
olr_china_CLIM=h4->orl
olr_china_clim=dim_avg_n_Wrap(olr_china_CLIM,0)

olr_indo_ano=new((/3,112/),"float")
olr_china_ano=new((/3,112/),"float")

do i=0,2
 olr_indo_ano(i,:)=olr_indo(i,:)-olr_indo_clim
 olr_china_ano(i,:)=olr_china(i,:)-olr_china_clim
end do

copy_VarMeta(olr_indo,olr_indo_ano)
copy_VarMeta(olr_china,olr_china_ano)

OLR=new((/2,3,112/),"float")
OLR(0,:,:)=olr_indo_ano
OLR(1,:,:)=olr_china_ano
OLR!0="site"
OLR=OLR*(-1)
;printMinMax(olr_china,0)
;-------------------------------------------------------------------
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc") ; 2016, 2018, 2020
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat({43:31})
lon=g->lon({117:137})
time=g->time
;---------------------------------------------------------------------------
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)
hgt_mask=where(hgt .ge. C, 1,0)

copy_VarMeta(hgt,hgt_mask)

test=dim_sum_n_Wrap(hgt_mask,2)
hgt_count=dim_sum_n_Wrap(test,2)
hgt_count2=int2flt(hgt_count)
hgt_count2 := hgt_count2/40.

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)
;----- 11 days moving; 2016, 2018, 2020-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/3,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
  hgt_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!0="case"
hgt_mv_11!1="time"

;----- FOR CORR -----------------------
;printVarSummary(hgt_mv_11);143
;printVarSummary(OLR);112
;exit
hgt_mv_11_7_9=hgt_mv_11(:,31:142)
OLR_cases_7_9=OLR
;printVarSummary(hgt_mv_11_7_9)
;printVarSummary(OLR_cases_7_9)
;exit

;-- It is correlations of fully data between HGT and TAS
indo_corr=escorc_n(hgt_mv_11_7_9,OLR_cases_7_9(0,:,:),1,1)
china_corr=escorc_n(hgt_mv_11_7_9,OLR_cases_7_9(1,:,:),1,1)
print("indo_corr = "+indo_corr)
print("china_corr = "+china_corr)
exit
;-----------------------------------------
hgt_mv_area=where(hgt_mv_11 .ge. P,hgt_mv_11,hgt_mv_11@_FillValue)
copy_VarMeta(hgt_mv_11,hgt_mv_area)

;hgt_mv_area=where(hgt_mv_11_7_9 .ge. P,hgt_mv_11_7_9,hgt_mv_11_7_9@_FillValue)
;copy_VarMeta(hgt_mv_11_7_9,hgt_mv_area)
;tas_mv_area=where(hgt_mv_11_7_9 .ge. P,TAS_mv_11_cases_7_9,TAS_mv_11_cases_7_9@_FillValue)
;copy_VarMeta(TAS_mv_11_cases_7_9,tas_mv_area)

;corr2=escorc_n(hgt_mv_area,tas_mv_area,1,1)
;-----------------------------------------
; It is a checking proccess of  missisng values for correlations which meet the criteria
;-----------------------------------------
;N11 = num(.not.ismissing(hgt_mv_area(0,:)))
;N22 = num(.not.ismissing(hgt_mv_area(1,:)))
;N33 = num(.not.ismissing(hgt_mv_area(2,:)))
;print(N11)
;print(N22)
;print(N33)
;exit
;-----------------------------------------

y5=ispan(6,148,1)
y2=ispan(37,148,1)
y6=ispan(62,148,1)
;;; *TAS_mv_11_cases*; case 3 x year 112 (6_9)

YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)

 ;y5,hgt_mv_area
 ;y2,TAS_mv_11_cases
;---------------------------------------------------------------------------
do K=0,2
 wks = gsn_open_wks("png",dir2+"6_9_ratio_total_Intensity_India_china_OLR_"+YEAR(K)+"_clim_hgt_${h}_"+per)
 xy_plot=new(1,"graphic")
 bar_plot=new(1,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.6
 res@trXMinF                  = 32
 res@trXMaxF                  =148
; res@tmYLPrecision=1
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"June","July","Aug","Sep"/)
 xyres                     = res
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@trYMinF                  = 0
 res@trYMaxF                  =1
 res@tmYLMode="Manual"
 res@tmYLTickStartF=-0.1
 res@tmYLTickSpacingF=0.1
 res@tmYLMinorPerMajor=3
 res@gsnXYBarChart            = True
 res@gsnXYBarChartBarWidth = 0.4   
 res@tiYAxisString = "Intensity" ; y-axis label
 res@xyDashPattern      = 0
 res@xyLineThicknessF    = 3.
 res@gsnLeftString=YEAR(K)
 res@tiXAxisString = "Time"
 res@tmYROn              = False
 res@gsnLeftString=""
 res@gsnCenterString="Tibetan high & OLR ("+YEAR(K)+")" 

  ;---XY curve resources
  xyres@tmYLMode="Manual"
  xyres@tmYLTickSpacingF=10
  xyres@tmYLMinorPerMajor=3
  xyres@xyLineThicknessF    = 4.0               ; default is 1.0
  xyres@xyLineThicknesses    = (/5.0,5.0/)               ; default is 1.0
  xyres@xyDashPatterns=(/0,0/)
  xyres@xyLineColors         = (/"gold","purple"/)
  xyres@tmYLTickStartF     = -30
  xyres@trYMinF             = -30
  xyres@trYMaxF             = 45
  ;---Turn off bottom, top, and left tickmarks
  xyres@tmXBOn              = False
  xyres@tmXTOn              = False
  xyres@tmYLOn              = False
  xyres@tmYROn              = True
  xyres@tmYRLabelsOn        = True
;---Set a title on right Y axis.
  xyres@tiYAxisString       = "-OLR(W/m~S~2~N~)"
  xyres@tiYAxisSide         = "Right"
  xyres@tiYAxisAngleF       = 270              ; Rotate the Y-axis title 270 degrees

 res@xyLineColor       = COLOR(K)
 res@gsnXYBarChartColors   =COLOR(K)
 bar_plot = gsn_csm_xy (wks,y5,hgt_mv_11(K,:),res)
 gres = True
 gres@YPosPercent = 94.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 70      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"gold","purple"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.015,0.015/)                           ; label font heights
 textres@lgLabels = (/"NW India","S. China Sea"/)  ; legend labels (required)
 bar_plot = simple_legend(wks,bar_plot,gres,lineres,textres)

 xy_plot= gsn_csm_xy (wks,y2,OLR(:,K,:),xyres)

 anno_id  = gsn_add_annotation(bar_plot, xy_plot, False)
 pres             = True
 pres@gsnMaximize = True
 maximize_output(wks,pres)
 delete([/res,xyres,wks,bar_plot,xy_plot,anno_id/])
 end do

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
