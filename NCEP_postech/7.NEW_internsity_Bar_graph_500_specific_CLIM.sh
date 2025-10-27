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
P=0.4
per=flt2string(P)
;---------------------------------------------------------------------------
A=addfile("${dir2}/hgt_AVG_count_mv_11_1991-2020.nc","r")
hgt_mv_11_CLIM=A->hgt_mv_11; year x time 
;---------------------------------------------------------------------------
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

hgt_mask=where(hgt .ge. 5850, 1,0)
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

hgt_mv_area=where(hgt_mv_11 .ge. P,hgt_mv_11,hgt_mv_11@_FillValue)
copy_VarMeta(hgt_mv_11,hgt_mv_area)
hgt_mv_area_CLIM=where(hgt_mv_11_CLIM .ge. P,hgt_mv_11_CLIM,hgt_mv_11_CLIM@_FillValue)
copy_VarMeta(hgt_mv_11_CLIM,hgt_mv_area_CLIM)


;hgt_mv_area
;hgt_mv_area_CLIM

HGT2=new((/4,153/),"float")
HGT2=0
HGT2(0:2,6:148)=hgt_mv_area
HGT2(3,6:148)=hgt_mv_area_CLIM

HGT_avg_5=dim_avg_n_Wrap(HGT2(:,0:30),1)
HGT_avg_6=dim_avg_n_Wrap(HGT2(:,31:60),1)
HGT_avg_7=dim_avg_n_Wrap(HGT2(:,61:91),1)
HGT_avg_8=dim_avg_n_Wrap(HGT2(:,92:122),1)
HGT_avg_9=dim_avg_n_Wrap(HGT2(:,123:152),1)

HGT_freq=new((/5,4/),"float")
HGT_freq(0,:)=HGT_avg_5
HGT_freq(1,:)=HGT_avg_6
HGT_freq(2,:)=HGT_avg_7
HGT_freq(3,:)=HGT_avg_8
HGT_freq(4,:)=HGT_avg_9

y5=ispan(6,148,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"For_NEW_Intensity_Bar_graph_clim_hgt_${h}_CLIM_"+per)
 plot=new(4,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
 res@trXMinF                  = 1
 res@tmYLMode="Manual"
 res@tmYLTickStartF=0
 res@tmYLTickSpacingF=0.1
 res@tmYLMinorPerMajor=4
 res@trXMaxF                  =6
 res@trYMinF                  =0 
 res@trYMaxF                  =1
 res@tiYAxisString = "Intensity" ; y-axis label
 res@tiXAxisString = ""
 res@gsnXYBarChart            = True
 ;res@gsnYRefLine=(/0.2/)
 ;res@gsnYRefLineColor=(/"black"/)
 ;res@gsnYRefLineDashPattern=(/1/)
 res@gsnXYBarChartBarWidth = 0.2   
 ;res@gsnLeftStringOrthogonalPosF=0.05
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/2,3,4,5/)
 res@tmXBLabels = (/"June","July","Aug","Sep"/)
 res@xyDashPatterns      = (/0,0,0,0/)
 res@xyLineThicknesses    = (/1,1,1,1/)
 res@gsnLeftString="Daily"
 res@tiXAxisString = "Time"
 ;res@gsnLeftString="11 days moving"
 res@gsnLeftString=""
 res@gsnCenterString="North Pacific high (500hpa; 2016, 2018, 2020)"
 res@xyLineColors       = (/"red"/)
 res@gsnXYBarChartColors   =(/"red"/)
 plot(0) = gsn_csm_xy (wks,fspan(0.7,4.7,5),HGT_freq(:,0),res)
 res@xyLineColors       = (/"Blue"/)
 res@gsnCenterString=""
 res@gsnXYBarChartColors   =(/"blue"/)
 plot(1) = gsn_csm_xy (wks,fspan(0.9,4.9,5),HGT_freq(:,1),res)
 res@xyLineColors       = (/"Green"/)
 res@gsnXYBarChartColors   =(/"green"/)
 plot(2) = gsn_csm_xy (wks,fspan(1.1,5.1,5),HGT_freq(:,2),res)
 res@xyLineColors       = (/"black"/)
 res@gsnXYBarChartColors   =(/"black"/)
 plot(3) = gsn_csm_xy (wks,fspan(1.3,5.3,5),HGT_freq(:,3),res)

 overlay(plot(0),plot(1))
 overlay(plot(0),plot(2))
 overlay(plot(0),plot(3))

 gres = True
 gres@YPosPercent = 94.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 81      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green","black"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.018,0.018,0.018,0.018/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020","Clim"/)  ; legend labels (required)
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
