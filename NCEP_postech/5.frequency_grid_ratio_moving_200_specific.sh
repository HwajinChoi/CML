#!/bin/bash

for h in "200" ;do
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

hgt_mask=where(hgt .ge. 12480, 1,0)
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


hgt_mv_1=where( .not.ismissing(hgt_mv_area(0,:)), 1, 0)
hgt_mv_2=where( .not.ismissing(hgt_mv_area(1,:)), 1, 0)
hgt_mv_3=where( .not.ismissing(hgt_mv_area(2,:)), 1, 0)

HGT=new((/3,143/),"float")
HGT(0,:)=hgt_mv_1
HGT(1,:)=hgt_mv_2
HGT(2,:)=hgt_mv_3
copy_VarMeta(hgt_mv_area,HGT)

HGT2=new((/3,153/),"float")
HGT2=0
HGT2(:,6:148)=HGT

HGT_sum_5=dim_sum_n_Wrap(HGT2(:,0:30),1)
HGT_sum_6=dim_sum_n_Wrap(HGT2(:,31:60),1)
HGT_sum_7=dim_sum_n_Wrap(HGT2(:,61:91),1)
HGT_sum_8=dim_sum_n_Wrap(HGT2(:,92:122),1)
HGT_sum_9=dim_sum_n_Wrap(HGT2(:,123:152),1)
print("HGT_sum_5 = "+HGT_sum_5)
print("------------------------------")
print("HGT_sum_6 = "+HGT_sum_6)
print("------------------------------")
print("HGT_sum_7 = "+HGT_sum_7)
print("------------------------------")
print("HGT_sum_8 = "+HGT_sum_8)
print("------------------------------")
print("HGT_sum_9 = "+HGT_sum_9)
print("------------------------------")

HGT_freq=new((/5,3/),"float")
HGT_freq(0,:)=HGT_sum_5
HGT_freq(1,:)=HGT_sum_6
HGT_freq(2,:)=HGT_sum_7
HGT_freq(3,:)=HGT_sum_8
HGT_freq(4,:)=HGT_sum_9
HGT_freq!0="month"
HGT_freq!1="case"

y5=ispan(6,148,1)
y10=ispan(1,5,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"Frequency_moving_2016_2018_2020_clim_hgt_${h}")
plot=new(3,"graphic")
plot1=new(3,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
 res@trXMinF                  = 0
 ;res@tmYLMode="Manual"
 ;res@tmYLTickStartF=-0.2
 ;res@tmYLTickSpacingF=0.2
 ;res@tmYLMinorPerMajor=3
 res@trXMaxF                  =6
 res@trYMinF                  =0 
 res@trYMaxF                  =35
 res@tiYAxisString = "Frequency (day)" ; y-axis label
 res@tiXAxisString = ""
 res@gsnXYBarChart            = True
 res@gsnXYBarChartBarWidth = 0.2   
 ;res@gsnLeftStringOrthogonalPosF=0.05
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/1,2,3,4,5/)
 res@tmXBLabels = (/"May","June","July","Aug","Sep"/)
 res@xyDashPatterns      = (/0,0,0/)
 res@xyLineThicknesses    = (/1,1,1/)
 res@gsnLeftString="Daily"
 res@tiXAxisString = "Time"
 ;res@gsnLeftString="11 days moving"
 res@gsnLeftString=""
 res@gsnCenterString="Tibetan high (200hpa; 2016, 2018, 2020)"
 res@xyLineColors       = (/"red"/)
 res@gsnXYBarChartColors   =(/"red"/)
 plot(0) = gsn_csm_xy (wks,fspan(0.8,4.8,5),HGT_freq(:,0),res)
 res@gsnCenterString=""
 res@xyLineColors       = (/"Blue"/)
 res@gsnXYBarChartColors   =(/"blue"/)
 plot(1) = gsn_csm_xy (wks,fspan(1.0,5.0,5),HGT_freq(:,1),res)
 res@xyLineColors       = (/"Green"/)
 res@gsnXYBarChartColors   =(/"green"/)
 plot(2) = gsn_csm_xy (wks,fspan(1.2,5.2,5),HGT_freq(:,2),res)
 overlay(plot(0),plot(1))
 overlay(plot(0),plot(2))

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
