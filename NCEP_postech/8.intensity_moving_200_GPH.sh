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
P=0.2
per=flt2string(P)

;---------------------------------------------------------------------------
; 11 years moving CLIM
;---------------------------------------------------------------------------
H=addfile("${dir2}/HGT_mv_11_1991-2020.nc","r")
hgt_clim_period=H->hgt_mv_11(:,:,{43:31},{117:137})
hgt_clim_period1=dim_avg(hgt_clim_period)
hgt_clim_period2=dim_avg(hgt_clim_period1)
copy_VarMeta(hgt_clim_period(:,:,0,0),hgt_clim_period2)
hgt_clim=dim_avg_n_Wrap(hgt_clim_period2,0)
;---------------------------------------------------------------------------
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)
dim=dimsizes(hgt)
;----- 11 days moving; 2016, 2018, 2020-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/3,tp,dim(2),dim(3)/),"float"); Target
imsi=new((/3,p,dim(2),dim(3)/),"float"); Chunck

do k=0,tp-1
  imsi(:,:,:,:)=hgt(:,k:k+p-1,:,:)
  hgt_mv_11(:,k,:,:)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!0="case"
hgt_mv_11!1="time"
hgt_mv_11_0=dim_avg_n_Wrap(hgt_mv_11,2)
HGT_MV_11=dim_avg_n_Wrap(hgt_mv_11_0,2)


y5=ispan(6,148,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"Intensity_HGT_11_moving_2016_2018_2020_CLIM_${h}")
plot=new(4,"graphic")
plot1=new(4,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
 res@gsnYRefLine       =12480
 res@gsnYRefLineColor = "black"
 res@gsnYRefLineDashPattern=1
 res@trXMinF                  = 1
 ;res@tmYLMode="Manual"
 ;res@tmYLTickStartF=-0.1
 ;res@tmYLTickSpacingF=0.1
 ;res@tmYLMinorPerMajor=3
 res@trXMaxF                  =153
 ;res@trYMinF                  = -0.1
 ;res@trYMaxF                  =0.6
 ;res@tmYLPrecision=1
 res@tiYAxisString = "(m)" ; y-axis label
 res@tiYAxisFontHeightF=0.02
 ;res@gsnXYBarChart            = True
 ;res@gsnXYBarChartBarWidth = 0.2   
 ;res@gsnLeftStringOrthogonalPosF=0.05
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(0),y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"May","June","July","Aug","Sep"/)
 res2=res
 res3=res
 res@xyDashPattern      = (/0/)
 res@xyLineThicknessF    = (/3./)
 res@gsnLeftString="Daily"
 res2@xyLineThicknessF=4
 res2@xyLineColor="black"
 res3@xyLineThicknessF=4
 res3@xyLineColor="black"
 res@tiXAxisString = "Time"
 ;res@gsnLeftString="11 days moving"
 res@gsnLeftString=""
 res@gsnCenterString="Tibetan high (200hpa; Korea peninsula)"
 res@xyLineColor       = (/"red"/)
 plot(0) = gsn_csm_xy (wks,y5,HGT_MV_11(0,:),res)
 res@gsnCenterString=""
 res@xyLineColor       = (/"Blue"/)
 plot(1) = gsn_csm_xy (wks,y5,HGT_MV_11(1,:),res)
 res@xyLineColor       = (/"Green"/)
 plot(2) = gsn_csm_xy (wks,y5,HGT_MV_11(2,:),res)
 res@xyLineThicknessF    = (/5./)
 res@xyLineColor       = (/"black"/)
 plot(3) = gsn_csm_xy (wks,y5,hgt_clim,res)
 res@gsnCenterString=""

 overlay(plot(0),plot(1))
 overlay(plot(0),plot(2))
 overlay(plot(0),plot(3))

 gres = True
 gres@YPosPercent = 91.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 83      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
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
