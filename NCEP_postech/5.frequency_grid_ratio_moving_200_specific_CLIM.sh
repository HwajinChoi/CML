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
P=0.4
per=flt2string(P)
;---------------------------------------------------------------------------
A=addfile("${dir2}/hgt_AVG_count_mv_11_1991-2020.nc","r")
hgt_mv_11_CLIM=A->hgt_mv_11; year x time 
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

hgt_mv_1=where( .not.ismissing(hgt_mv_area(0,:)), 1, 0)
hgt_mv_2=where( .not.ismissing(hgt_mv_area(1,:)), 1, 0)
hgt_mv_3=where( .not.ismissing(hgt_mv_area(2,:)), 1, 0)

hgt_mv_4=where( .not.ismissing(hgt_mv_area_CLIM), 1, 0)

HGT=new((/3,143/),"float")
HGT(0,:)=hgt_mv_1
HGT(1,:)=hgt_mv_2
HGT(2,:)=hgt_mv_3
copy_VarMeta(hgt_mv_area,HGT)

HGT2=new((/3,153/),"float")
HGT2=0
HGT2(:,6:148)=HGT

HGT22=new((/153/),"float")
HGT22=0
HGT22(6:148)=hgt_mv_4

HGT_sum_55=dim_sum_n_Wrap(HGT22(0:30),0)
HGT_sum_66=dim_sum_n_Wrap(HGT22(31:60),0)
HGT_sum_77=dim_sum_n_Wrap(HGT22(61:91),0)
HGT_sum_88=dim_sum_n_Wrap(HGT22(92:122),0)
HGT_sum_99=dim_sum_n_Wrap(HGT22(123:152),0)

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

HGT_freq=new((/5,4/),"float")
HGT_freq(0,0:2)=HGT_sum_5
HGT_freq(1,0:2)=HGT_sum_6
HGT_freq(2,0:2)=HGT_sum_7
HGT_freq(3,0:2)=HGT_sum_8
HGT_freq(4,0:2)=HGT_sum_9

HGT_freq(0,3)=HGT_sum_55
HGT_freq(1,3)=HGT_sum_66
HGT_freq(2,3)=HGT_sum_77
HGT_freq(3,3)=HGT_sum_88
HGT_freq(4,3)=HGT_sum_99

HGT_freq!0="month"
HGT_freq!1="case"

y5=ispan(6,148,1)
y10=ispan(1,5,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"NEW_Frequency_moving_2016_2018_2020_clim_hgt_${h}_CLIM_"+per)
plot=new(4,"graphic")
plot1=new(4,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
 res@trXMinF                  = 1
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
 res@tmXBValues =(/2,3,4,5/)
 res@tmXBLabels = (/"June","July","Aug","Sep"/)
 res@xyDashPatterns      = (/0,0,0/)
 res@xyLineThicknesses    = (/1,1,1/)
 res@gsnLeftString="Daily"
 res@tiXAxisString = "Time"
 ;res@gsnLeftString="11 days moving"
 res@gsnLeftString=""
 res@gsnCenterString="Tibetan high (200hpa; 2016, 2018, 2020)"
 res@xyLineColors       = (/"red"/)
 res@gsnXYBarChartColors   =(/"red"/)
 plot(0) = gsn_csm_xy (wks,fspan(0.7,4.7,5),HGT_freq(:,0),res)
 res@gsnCenterString=""
 res@xyLineColors       = (/"Blue"/)
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
 gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
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
