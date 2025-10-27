#!/bin/bash

for h in "500" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific/6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
C=5850
P=0.4
per=flt2string(P)
;-------------------------------------------------------------------
hfiles=systemfunc("ls ${dir3}/st*_11moving_1991-2022_June_Sep.nc")
h=addfiles(hfiles,"r")
ListSetType(h,"join")
pr_mv_11=h[:]->pr_mv_11
pr_mv_11!0="site"
pr_mv_11_k=dim_avg_n_Wrap(pr_mv_11,0) ; year(1991-2022) x time 112 (6-9)

PR_mv_11_cases=new((/3,112/),"float")
PR_mv_11_cases(0,:)=pr_mv_11_k(25,:)
PR_mv_11_cases(1,:)=pr_mv_11_k(27,:)
PR_mv_11_cases(2,:)=pr_mv_11_k(29,:)
PR_mv_11_cases!0="case"
;-------------------------------------------------------------------
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc") ; 2016, 2018, 2020
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat({43:31})
lon=g->lon({117:137})
time=g->time
;---------------------------------------------------------------------------
;----------CHANGE!! ------
;---------------------------------------------------------------------------
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

;----------CHANGE!! ------
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

; hgt_mv_11 -> 3(case) * 143(time)
; PR_mv_11_cases -> 3(case) * 112(time)

;----- FOR CORR -----------------------
hgt_mv_11_7_9=hgt_mv_11(:,31:142)
PR_mv_11_cases_7_9=PR_mv_11_cases

;-- It is correlations of fully data between HGT and PR
corr=escorc_n(hgt_mv_11_7_9,PR_mv_11_cases_7_9,1,1)
;-----------------------------------------
;-----------------------------------------
print("**Fully data correlation**")
print(corr)
;-----------------------------------------
;-----------------------------------------
hgt_mv_area=where(hgt_mv_11_7_9 .ge. P,hgt_mv_11_7_9,hgt_mv_11_7_9@_FillValue)
copy_VarMeta(hgt_mv_11_7_9,hgt_mv_area)
pr_mv_area=where(hgt_mv_11_7_9 .ge. P,PR_mv_11_cases_7_9,PR_mv_11_cases_7_9@_FillValue)
copy_VarMeta(PR_mv_11_cases_7_9,pr_mv_area)

corr2=escorc_n(hgt_mv_area,pr_mv_area,1,1)
;-----------------------------------------
;-----------------------------------------
print("**Partial data correlation**")
print(corr2)
;-----------------------------------------
;-----------------------------------------
; It is a checking proccess of  missisng values for correlations which meet the criteria
;-----------------------------------------
N11 = num(.not.ismissing(hgt_mv_area(0,:)))
N22 = num(.not.ismissing(hgt_mv_area(1,:)))
N33 = num(.not.ismissing(hgt_mv_area(2,:)))
print(N11)
print(N22)
print(N33)
;-----------------------------------------
y5=ispan(6,148,1)
y2=ispan(37,148,1)
y6=ispan(62,148,1)
;;; *PR_mv_11_cases*; case 3 x year 112 (6_9)

YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)

 ;y5,hgt_mv_area
 ;y2,PR_mv_11_cases
;---------------------------------------------------------------------------
do K=0,2
 wks = gsn_open_wks("png",dir2+"6_9_PR_fill_"+C+"_Intensity_count_moving_"+YEAR(K)+"_clim_hgt_${h}_CLIM_"+per)
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
 res@gsnCenterString="North Pacific high ( "+C+" ; "+YEAR(K)+" )" 

  ;---XY curve resources
  xyres@tmYLMode="Manual"
  xyres@tmYLTickSpacingF=5
  xyres@tmYLMinorPerMajor=3
  xyres@xyLineThicknessF    = 5.0               ; default is 1.0
  xyres@xyLineColor         = "grey30"
  xyres@tmYLTickStartF	    = 0
  xyres@trYMinF             = 0
  xyres@trYMaxF             = 30
  ;---Turn off bottom, top, and left tickmarks
  xyres@tmXBOn              = False
  xyres@tmXTOn              = False
  xyres@tmYLOn              = False
  xyres@tmYROn              = True
  xyres@tmYRLabelsOn        = True
;---Set a title on right Y axis.
  xyres@tiYAxisString       = "mm"
  xyres@tiYAxisSide         = "Right"
  xyres@tiYAxisAngleF       = 270              ; Rotate the Y-axis title 270 degrees

 res@xyLineColor       = COLOR(K)
 res@gsnXYBarChartColors   =COLOR(K)
 bar_plot = gsn_csm_xy (wks,y2,hgt_mv_11_7_9(K,:),res)

 xy_plot= gsn_csm_xy (wks,y2,PR_mv_11_cases_7_9(K,:),xyres)

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
