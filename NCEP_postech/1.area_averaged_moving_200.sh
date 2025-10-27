#!/bin/bash

for h in "200";do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc")
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat({43:31})
lon=g->lon({117:137})
time=g->time

ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)

;-----Raw data---------------------------------------------------------------
hgt_Ave = wgt_areaave_Wrap(hgt, clat, 1.0, 1) ; 44(year) x 153(time) 
hgt_Ave_clim=dim_avg_n_Wrap(hgt_Ave,0)
;-----5 days averaged--------------------------------------------------------
hgt_5days=new((/44,31/),"float")
imsi=new((/44,5/),"float")
A=new((/44,3/),"float")

 do i =0,29
  imsi(:,:)=hgt_Ave(:,5*i:5*i+4)
  hgt_5days(:,i)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

 A=hgt_Ave(:,150:152)
 hgt_5days(:,30)=dim_avg_n_Wrap(A,1)
 hgt_5days!1="time"
 y12=ispan(3,148,5)
 y1=new(31,"integer")
 y1(0:29)=y12
 y1(30)=152
 hgt_5days_avg=dim_avg_n_Wrap(hgt_5days,0)
 delete(imsi)
;----------- For moving average ------------------------------------
p=5;chunck period
tp=153-p+1;total period after moving averaged
;----- 5 days moving-------------------------------------------------------------
hgt_mv_5=new((/44,tp/),"float"); Target
imsi=new((/44,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:)=hgt_Ave(:,k:k+p-1)
  hgt_mv_5(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_5!1="time"
hgt_mv_5_avg=dim_avg_n_Wrap(hgt_mv_5,0)

y2=ispan(3,151,1)
delete([/imsi,k,p,tp/])
;----- 7 days moving-------------------------------------------------------------
p=7;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_7=new((/44,tp/),"float"); Target
imsi=new((/44,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_Ave(:,k:k+p-1)
  hgt_mv_7(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_7!1="time"
hgt_mv_7_avg=dim_avg_n_Wrap(hgt_mv_7,0)

y3=ispan(4,150,1)
delete([/imsi,k,p,tp/])
;----- 9 days moving-------------------------------------------------------------
p=9;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_9=new((/44,tp/),"float"); Target
imsi=new((/44,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_Ave(:,k:k+p-1)
  hgt_mv_9(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_9!1="time"
hgt_mv_9_avg=dim_avg_n_Wrap(hgt_mv_9,0)

y4=ispan(5,149,1)
delete([/imsi,k,p,tp/])
;----- 11 days moving-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/44,tp/),"float"); Target
imsi=new((/44,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_Ave(:,k:k+p-1)
  hgt_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!1="time"
hgt_mv_11_avg=dim_avg_n_Wrap(hgt_mv_11,0)

y5=ispan(6,148,1)
delete([/imsi,k,p,tp/])

system("rm -f ${dir1}/hgt_Ave_clim.nc")
out1=addfile("${dir1}/hgt_Ave_clim.nc","c")
out1->hgt_Ave_clim=hgt_Ave_clim

system("rm -f ${dir1}/hgt_5days_avg.nc")
out2=addfile("${dir1}/hgt_5days_avg.nc","c")
out2->hgt_5days_avg=hgt_5days_avg

system("rm -f ${dir1}/hgt_mv_5_avg.nc")
out3=addfile("${dir1}/hgt_mv_5_avg.nc","c")
out3->hgt_mv_5_avg=hgt_mv_5_avg

system("rm -f ${dir1}/hgt_mv_7_avg.nc")
out4=addfile("${dir1}/hgt_mv_7_avg.nc","c")
out4->hgt_mv_7_avg=hgt_mv_7_avg

system("rm -f ${dir1}/hgt_mv_9_avg.nc")
out5=addfile("${dir1}/hgt_mv_9_avg.nc","c")
out5->hgt_mv_9_avg=hgt_mv_9_avg

system("rm -f ${dir1}/hgt_mv_11_avg.nc")
out6=addfile("${dir1}/hgt_mv_11_avg.nc","c")
out6->hgt_mv_11_avg=hgt_mv_11_avg

exit

wks = gsn_open_wks("png",dir2+"moving_hgt_${h}")
plot=new(6,"graphic")
plot0=new(6,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
 res@gsnYRefLine       =12480
 res@gsnYRefLineColor = "red"
 res@gsnYRefLineDashPattern=1
 res@trXMinF                  = 1
 res@trXMaxF                  =153
 res@tiYAxisString = "Geopotential height [m]" ; y-axis label
 res@tiXAxisString = ""
 res@gsnLeftStringOrthogonalPosF=0.05
 res@gsnLeftStringFontHeightF=0.025
 res@xyDashPattern      = 0
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(0),y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"May","June","July","Aug","Sep"/)
 res2=res
 res@gsnLeftString="Daily"
 res2@xyLineThicknessF=4
 res2@xyLineColor="Gold"
 res@trYMaxF                  =12600
 res@trYMinF                  =11600 
; res@tmYLMode          = "Manual"
; res@tmYLTickSpacingF  =  100
; res@tmYLTickStartF    = 9000
 plot(0) = gsn_csm_xy (wks,y,hgt_Ave,res)
 plot0(0) = gsn_csm_xy (wks,y,hgt_Ave_clim,res2)

; res@trYMinF                  =9100 
; res@trYMaxF                  =9800
 res@gsnLeftString="5 days ave"
 res@tiYAxisString = ""
 plot(1) = gsn_csm_xy (wks,y1,hgt_5days,res)
 plot0(1) = gsn_csm_xy (wks,y1,hgt_5days_avg,res2)
 res@gsnLeftString="5 days moving"
 res@tiYAxisString = "Geopotential height [m]" ; y-axis label
 plot(2) = gsn_csm_xy (wks,y2,hgt_mv_5,res)
 plot0(2) = gsn_csm_xy (wks,y2,hgt_mv_5_avg,res2)
 res@tiYAxisString = ""
 res@gsnLeftString="7 days moving"
 plot(3) = gsn_csm_xy (wks,y3,hgt_mv_7,res)
 plot0(3) = gsn_csm_xy (wks,y3,hgt_mv_7_avg,res2)
 res@tiYAxisString = "Geopotential height [m]" ; y-axis label
 res@gsnLeftString="9 days moving"
 res@tiXAxisString = "Time"
 plot(4) = gsn_csm_xy (wks,y4,hgt_mv_9,res)
 plot0(4) = gsn_csm_xy (wks,y4,hgt_mv_9_avg,res2)
 res@tiYAxisString = ""
 res@tiXAxisString = "Time"
 res@gsnLeftString="11 days moving"
 plot(5) = gsn_csm_xy (wks,y5,hgt_mv_11,res)
 plot0(5) = gsn_csm_xy (wks,y5,hgt_mv_11_avg,res2)

 overlay(plot(0),plot0(0))
 overlay(plot(1),plot0(1))
 overlay(plot(2),plot0(2))
 overlay(plot(3),plot0(3))
 overlay(plot(4),plot0(4))
 overlay(plot(5),plot0(5))

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString=${h}+"hpa (1979 - 2022)"
 pres@gsnPanelBottom=0.05
; pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 2
 gsn_panel(wks,plot,(/3,2/),pres)
 frame(wks)


end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
