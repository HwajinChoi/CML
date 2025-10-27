#!/bin/bash

for h in "500" ;do
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR
dir5=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
P=0.4
SSS=1.0
per=flt2string(P)

h3=addfile("${dir5}/OLR_indo_11moving_1991-2022_June_Sep.nc","r")
olr_indo0=h3->orl(0:29,:); year x time
olr_indo0=olr_indo0*(-1)
olr_indo=h3->orl; year x time
olr_indo=olr_indo*(-1)
olr_indo_for_sig=ndtooned(olr_indo0)
olr_clim_indo1=dim_avg_n_Wrap(olr_indo_for_sig,0)
olr_indo_stdv=stddev(olr_indo_for_sig)

h4=addfile("${dir5}/OLR_china_11moving_1991-2022_June_Sep.nc","r")
olr_china0=h4->orl(0:29,:)
olr_china0=olr_china0*(-1)
olr_china=h4->orl
olr_china=olr_china*(-1)
olr_china_for_sig=ndtooned(olr_china0)
olr_clim_china1=dim_avg_n_Wrap(olr_china_for_sig,0)
olr_china_stdv=stddev(olr_china_for_sig)

OLR_CLIM_INDO=olr_clim_indo1+(SSS*olr_indo_stdv)
OLR_CLIM_CHINA=olr_clim_china1+(SSS*olr_china_stdv)

;print("olr_clim_indo ="+olr_clim_indo1)
;print("olr_indo_stdv="+olr_indo_stdv)
;print("olr_clim_china ="+olr_clim_china1)
;print("olr_china_stdv="+olr_china_stdv)
;exit

olr_indo2=where(olr_indo .gt. OLR_CLIM_INDO,olr_indo,olr_indo@_FillValue)
olr_china2=where(olr_china .gt. OLR_CLIM_CHINA,olr_clim_china1,olr_clim_china1@_FillValue) 
copy_VarMeta(olr_indo,olr_indo2)
copy_VarMeta(olr_china,olr_china2)

OLR=new((/2,32,112/),"float")
OLR(0,:,:)=olr_indo2
OLR(1,:,:)=olr_china2
OLR!0="site"

;---------------------------------------------------------------------------
B=addfile("${dir2}/hgt.500.1991.nc","r")
time=B->time
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11_CLIM=A->hgt_mv_11; year (32) x time (143) 

;---------------------------------------------------------------------------
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)

hgt_mv_area_CLIM=where(hgt_mv_11_CLIM .ge. P,hgt_mv_11_CLIM,hgt_mv_11_CLIM@_FillValue)
copy_VarMeta(hgt_mv_11_CLIM,hgt_mv_area_CLIM)

hgt_mv_4=new((/32,143/),"float")

do F=0,31
 hgt_mv_4(F,:)=where( .not.ismissing(hgt_mv_area_CLIM(0+F,:)), F+1, 0)
end do
hgt_mv_4@_FillValue=0


OLR3=new((/2,32,112/),"float")

do F=0,31
 OLR3(0,F,:)=where(.not.ismissing(OLR(0,F,:)),F+0.85,0) ; indo
 OLR3(1,F,:)=where(.not.ismissing(OLR(1,F,:)),F+1.15,0) ; china
end do
OLR3@_FillValue=0

HGT=new((/32,153/),"float")
HGT=0
HGT(:,6:148)=hgt_mv_4
copy_VarMeta(hgt_mv_area_CLIM,HGT)
HGT@_FillValue=0

H=2012
y=H-1991
print(HGT(y,:))
exit

Y=ispan(1991,2022,1)
YY=tostring(Y)

y5=ispan(6,148,1)
AA=new(16,"float")
BB=new(16,"float")
BB1=new(16,"float")
CC1=new(16,"string")
CHINA=new(16,"string")
INDO=new(16,"string")
CC2=new(16,"string")
AA=0
BB=7
BB1=10
CC1="black"
CC2="black"
INDO="gold"
CHINA="purple"
CC2(9)="red" ;2016
CC2(11)="blue" ;2018
CC2(13)="green" ;2020
yyyy=ispan(37,148,1)
;---------------------------------------------------------------------------
wks = gsn_open_wks("png",dir2+"Minus_For_COUNT_moving_OLR_ABS_CLIM_STDV_"+SSS+"_Indo_China_91-22_hgt_${h}_"+per)
plot=new(2,"graphic")
plot1=new(2,"graphic")
plot2=new(2,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@gsnMaximize=True
 ;res@vpHeightF          = 0.8               ; change aspect ratio of plot
 ;res@vpWidthF           = 0.4
 res@trXMinF                  = 32
 res@trXMaxF                  =153
 res@tmYLMode   = "Explicit"
 res@tiYAxisString = "" ; y-axis label
 res@tiXAxisString = ""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.018
 res@gsnLeftStringFontHeightF=0.015
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"June","July","Aug","Sep"/)
 res@tmYLValues = ispan(1,16,1)
 res@tmYLLabels = YY(0:15)
 res@tmYLLabelFontHeightF=0.015
 res@tmXBLabelFontHeightF=0.015
 res@gsnXRefLine=(/y(31),y(61),y(92),y(123)/)
 res@gsnXRefLineColors=(/"black","black","black","black"/)
 res@gsnXRefLineDashPatterns=(/1,1,1,1/)
 res@trYMinF                  = 0+0.5
 res@trYMaxF                  =17-0.5
 res@xyDashPatterns      = AA 
 res@xyLineThicknesses    = BB1
 res@gsnLeftString="Daily"
 res@tiXAxisString = "Time"
 res@tiXAxisFontHeightF=0.015
 res@tiYAxisFontHeightF=0.015
 res@gsnLeftString=""
 res@gsnCenterString=""
 res@xyLineColors       = CC1 
 res@gsnYRefLine=(/9.5/)
 res@gsnYRefLineColors=(/"black"/)
 res@gsnYRefLineDashPattern=(/0/)
 plot(0) = gsn_csm_xy (wks,y,HGT(0:15,:),res)
 res@xyLineColors=INDO
 res@xyLineThicknesses    = BB
 plot1(0) = gsn_csm_xy (wks,yyyy,OLR3(0,0:15,:),res)
 res@xyLineColors=CHINA
 plot2(0) = gsn_csm_xy (wks,yyyy,OLR3(1,0:15,:),res)
 delete(res@gsnYRefLine)
 delete(res@gsnYRefLineColors)
 delete(res@gsnYRefLineDashPattern)
 res@gsnYRefLineDashPatterns=(/0,0/)
 res@tmYLValues = ispan(17,32,1)
 res@tmYLLabels = YY(16:31)
 res@gsnYRefLine=(/19.5,29.5/)
 res@gsnYRefLineColors=(/"black","black"/)
 res@xyLineColors       = CC2 
 res@trYMinF                  = 17+0.5
 res@trYMaxF                  =33-0.5
 res@xyLineThicknesses    = BB1
 plot(1) = gsn_csm_xy (wks,y,HGT(16:31,:),res)
 res@xyLineColors=INDO
 res@xyLineThicknesses    = BB
 plot1(1) = gsn_csm_xy (wks,yyyy,OLR3(0,16:31,:),res)
 res@xyLineColors=CHINA
 plot2(1) = gsn_csm_xy (wks,yyyy,OLR3(1,16:31,:),res)
 overlay(plot(0),plot1(0))
 overlay(plot(0),plot2(0))

 overlay(plot(1),plot1(1))
 overlay(plot(1),plot2(1))

;
pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =      True
pres@gsnPanelXWhiteSpacePercent = 5
;pres@gsnPanelLeft  =0.1
pres@gsnPanelMainString        =   "NPH & NW India, S. China sea | ABS Clim + "+SSS+" sig"
;txres               = True                      ; text mods desired
;txres@txFontHeightF = 0.016
;gsn_text_ndc(wks,"W/m~S~2~N~",0.89,0.365,txres)
gsn_panel(wks,plot,(/1,2/),pres)
frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
