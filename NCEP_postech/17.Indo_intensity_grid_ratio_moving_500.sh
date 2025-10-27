#!/bin/bash

for h in "500" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/spec_6_9

cat > imsi.ncl << EOF
begin
C=5850
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
;-------------------------------------------------------------------
h=addfile("${dir3}/OLR_indo_11moving_2016_2018_2020_June_Sep.nc","r")
olr_indo=h->orl
olr_indo=olr_indo*(-1)
h2=addfile("${dir3}/OLR_china_11moving_2016_2018_2020_June_Sep.nc","r")
olr_china=h2->orl
olr_china=olr_china*(-1)
;printMinMax(olr_indo,0)
;printMinMax(olr_china,0)
;exit

;-------------------------------------------------------------------
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc") ; 2016, 2018, 2020
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat({43:31})
lon=g->lon({117:137})
time=g->time
P=0.4
per=flt2string(P)
;----------CHANGE!! ------
;---------------------------------------------------------------------------
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

hgt_mask=where(hgt .ge. C, 1,0)
;----------CHANGE!! ------

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

;;;; *hgt_mv_11*(3 case), hgt_mv_11_CLIM ;;;;;; 

hgt_mv_area=where(hgt_mv_11 .ge. P,hgt_mv_11,hgt_mv_11@_FillValue)
copy_VarMeta(hgt_mv_11,hgt_mv_area)

y5=ispan(6,148,1)
y2=ispan(37,148,1)
;;; *TAS_mv_11_cases*; case 3 x year 112 (6_9)

YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)
;---------------------------------------------------------------------------
do K=0,2
 wks = gsn_open_wks("png",dir2+"Intensity_Indo_OLR_"+YEAR(K)+"_clim_hgt_${h}_"+per)
 xy_plot=new(1,"graphic")
 bar_plot=new(1,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.6
 res@trXMinF                  = 62
 res@trXMaxF                  =153
; res@tmYLPrecision=1
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(61),y(92),y(123)/)
 res@tmXBLabels = (/"July","Aug","Sep"/)
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
 res@gsnCenterString="North Pacific high & NW India OLR ("+YEAR(K)+")" 

  ;---XY curve resources
  xyres@tmYLMode="Manual"
  xyres@tmYLTickSpacingF=10
  xyres@tmYLMinorPerMajor=3
  xyres@xyLineThicknessF    = 4.0               ; default is 1.0
  xyres@xyLineColor         = "Black"
  ;xyres@tmYLTickStartF	    = -274
  xyres@trYMinF             = -274
  xyres@trYMaxF             = -188
  ;---Turn off bottom, top, and left tickmarks
  xyres@tmXBOn              = False
  xyres@tmXTOn              = False
  xyres@tmYLOn              = False
  xyres@tmYROn              = True
  xyres@tmYRLabelsOn        = True
;---Set a title on right Y axis.
  xyres@tiYAxisString       = "ORL(W/m~S~2~N~)"
  xyres@tiYAxisSide         = "Right"
  xyres@tiYAxisAngleF       = 270              ; Rotate the Y-axis title 270 degrees

 res@xyLineColor       = COLOR(K)
 res@gsnXYBarChartColors   =COLOR(K)
 bar_plot = gsn_csm_xy (wks,y5,hgt_mv_area(K,:),res)
 xy_plot= gsn_csm_xy (wks,y2,olr_indo(K,:),xyres)

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
done
