#!/bin/bash

for h in "500" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc") ; 2016, 2018, 2020
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat({43:31})
lon=g->lon({117:137})
time=g->time

;---------------------------------------------------------------------------
h6=addfile("${dir2}/hgt_count_mv_11_avg.nc","r")
hgt_mv_11_avg_org=h6->hgt_mv_11_avg ; for climate value
dim1=dimsizes(hgt_mv_11_avg_org)

hgt_clim_11_avg=new((/3,dim1(0)/),"float")
hgt_clim_11_avg!0="case"

do K=0,2
hgt_clim_11_avg(K,:)=hgt_mv_11_avg_org
end do

;---------------------------------------------------------------------------

ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

hgt_mask=where(hgt .ge. 5880, 1,0)
copy_VarMeta(hgt,hgt_mask)

test=dim_sum_n_Wrap(hgt_mask,2)
hgt_count=dim_sum_n_Wrap(test,2)
hgt_count2=int2flt(hgt_count)
hgt_count2 := hgt_count2/40.

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)

;-----Raw data---------------------------------------------------------------
;hgt_Ave_clim=dim_avg_n_Wrap(hgt_Ave,0)

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

hgt_ano=hgt_mv_11-hgt_clim_11_avg
copy_VarMeta(hgt_clim_11_avg,hgt_ano)

hgt_mv_area=where(hgt_mv_11 .ge. 0.1,hgt_ano,hgt_mv_11@_FillValue)
copy_VarMeta(hgt_mv_11,hgt_mv_area)

hgt_mv_neg=where(hgt_mv_area .lt. 0, hgt_mv_area, hgt_mv_area@_FillValue)
hgt_mv_pos=where(hgt_mv_area .gt. 0, hgt_mv_area, hgt_mv_area@_FillValue)
copy_VarMeta(hgt_mv_area,hgt_mv_neg)
copy_VarMeta(hgt_mv_area,hgt_mv_pos)

y5=ispan(6,148,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"Intensity_count_moving_2016_2018_2020_clim_hgt_${h}")
plot=new(3,"graphic")
plot1=new(3,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
 res@gsnYRefLine       =0
 res@gsnYRefLineColor = "black"
 res@gsnYRefLineDashPattern=1
 res@trXMinF                  = 1
 res@tmYLMode="Manual"
 res@tmYLTickStartF=-0.2
 res@tmYLTickSpacingF=0.1
 res@tmYLMinorPerMajor=3
 res@trXMaxF                  =153
 res@trYMinF                  = -0.2
 res@trYMaxF                  =0.7
 res@tmYLPrecision=1
 res@tiYAxisString = "Intensity" ; y-axis label
 res@tiXAxisString = ""
 res@gsnXYBarChart            = True
 res@gsnXYBarChartBarWidth = 0.2   
 ;res@gsnLeftStringOrthogonalPosF=0.05
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(0),y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"May","June","July","Aug","Sep"/)
 res2=res
 res3=res
 res@xyDashPatterns      = (/0,0,0/)
 res@xyLineThicknesses    = (/3.,3,3/)
 res@gsnLeftString="Daily"
 res2@xyLineThicknessF=4
 res2@xyLineColor="black"
 res3@xyLineThicknessF=4
 res3@xyLineColor="black"
 res@tiXAxisString = "Time"
 ;res@gsnLeftString="11 days moving"
 res@gsnLeftString=""
 res@gsnCenterString="North Pacific high (500hpa; 2016, 2018, 2020)"
 res@xyLineColor       = (/"red"/)
 res@gsnXYBarChartColor   =(/"red"/)
 res@gsnAboveYRefLineBarColor = (/"red"/)
 res@gsnBelowYRefLineBarColor = (/"red"/)
 plot(0) = gsn_csm_xy (wks,fspan(5.7,147.7,143),hgt_mv_pos(0,:),res)
 res@gsnCenterString=""
 plot1(0) = gsn_csm_xy (wks,fspan(5.7,147.7,143),hgt_mv_neg(0,:),res)
 res@xyLineColor       = (/"Blue"/)
 res@gsnXYBarChartColor   =(/"Blue"/)
 res@gsnBelowYRefLineBarColor = (/"Blue"/)
 res@gsnAboveYRefLineBarColor = (/"Blue"/)
 plot(1) = gsn_csm_xy (wks,fspan(5.9,147.9,143),hgt_mv_pos(1,:),res)
 plot1(1) = gsn_csm_xy (wks,fspan(5.9,147.9,143),hgt_mv_neg(1,:),res)
 res@gsnAboveYRefLineBarColor = (/"green"/)
 res@gsnBelowYRefLineBarColor = (/"green"/) 
 res@xyLineColor       = (/"Green"/)
 res@gsnXYBarChartColor   =(/"Green"/)
 plot(2) = gsn_csm_xy (wks,fspan(6.1,148.1,143),hgt_mv_pos(2,:),res)
 plot1(2) = gsn_csm_xy (wks,fspan(6.1,148.1,143),hgt_mv_neg(2,:),res)

 overlay(plot(0),plot1(0))
 overlay(plot(1),plot1(1))
 overlay(plot(2),plot1(2))

 overlay(plot(0),plot(1))
 overlay(plot(0),plot(2))

 gres = True
 gres@YPosPercent = 94.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 81      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.018,0.018,0.018/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020"/)  ; legend labels (required)
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 draw(plot(0))
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
