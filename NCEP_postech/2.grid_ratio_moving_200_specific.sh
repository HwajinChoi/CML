#!/bin/bash

for h in "200";do
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
h1=addfile("${dir2}/hgt_count_clim.nc","r") ; 2016, 2018, 2020
hgt_count_clim_org=h1->hgt_count_clim

h2=addfile("${dir2}/hgt_count_5days_avg.nc","r")
hgt_5days_avg_org=h2->hgt_5days_avg

h3=addfile("${dir2}/hgt_count_mv_5_avg.nc","r")
hgt_mv_5_avg_org=h3->hgt_mv_5_avg

h4=addfile("${dir2}/hgt_count_mv_7_avg.nc","r")
hgt_mv_7_avg_org=h4->hgt_mv_7_avg

h5=addfile("${dir2}/hgt_count_mv_9_avg.nc","r")
hgt_mv_9_avg_org=h5->hgt_mv_9_avg

h6=addfile("${dir2}/hgt_count_mv_11_avg.nc","r")
hgt_mv_11_avg_org=h6->hgt_mv_11_avg
;---------------------------------------------------------------------------

ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

;hgt_mask=where(hgt .ge. 5880, 1,0)
hgt_mask=where(hgt .ge. 12480, 1,0) ; for 200hpa
copy_VarMeta(hgt,hgt_mask)

test=dim_sum_n_Wrap(hgt_mask,2)
hgt_count=dim_sum_n_Wrap(test,2)
hgt_count2=int2flt(hgt_count)

print(hgt_count2(1,:))
exit

hgt_count2 := hgt_count2/40.

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)

;-----Raw data---------------------------------------------------------------
;hgt_Ave_clim=dim_avg_n_Wrap(hgt_Ave,0)
;-----5 days averaged--------------------------------------------------------
hgt_5days=new((/3,31/),"float")
imsi=new((/3,5/),"float")
A=new((/3,3/),"float")

 do i =0,29
  imsi(:,:)=hgt_count2(:,5*i:5*i+4)
  hgt_5days(:,i)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

 A=hgt_count2(:,150:152)
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
hgt_mv_5=new((/3,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
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
hgt_mv_7=new((/3,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
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
hgt_mv_9=new((/3,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
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
hgt_mv_11=new((/3,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
  hgt_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!1="time"
hgt_mv_11_avg=dim_avg_n_Wrap(hgt_mv_11,0)

y5=ispan(6,148,1)
delete([/imsi,k,p,tp/])

wks = gsn_open_wks("png",dir2+"Count_moving_2016_2018_2020_clim_hgt_${h}")
plot=new(6,"graphic")
plot0=new(6,"graphic")
plot1=new(6,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.7
; res@gsnYRefLine       =5880
; res@gsnYRefLineColor = "black"
; res@gsnYRefLineDashPattern=1
 res@trXMinF                  = 1
 res@trXMaxF                  =153
 res@tiYAxisString = "Expansion ratio" ; y-axis label
 res@tiXAxisString = ""
 res@gsnLeftStringOrthogonalPosF=0.05
 res@gsnLeftStringFontHeightF=0.025
 res@tmXBMode   = "Explicit"
 res@tmXBValues =(/y(0),y(31),y(61),y(92),y(123)/)
 res@tmXBLabels = (/"May","June","July","Aug","Sep"/)
 res2=res
 res3=res
 res@xyDashPatterns      = (/0,0,0/)
 res@xyLineColors       = (/"red","Blue","Green"/)
 res@xyLineThicknesses    = (/3.,3,3/)
 res@gsnLeftString="Daily"
 res2@xyLineThicknessF=4
 res2@xyLineColor="black"
 res3@xyLineThicknessF=4
 res3@xyLineColor="black"
 plot(0) = gsn_csm_xy (wks,y,hgt_count2,res)
; plot0(0) = gsn_csm_xy (wks,y,hgt_Ave_clim,res2)
 plot1(0) = gsn_csm_xy (wks,y,hgt_count_clim_org,res3)

; res@trYMinF                  =5500 
; res@trYMaxF                  =6000
 res@gsnLeftString="5 days ave"
 res@tiYAxisString = ""
 plot(1) = gsn_csm_xy (wks,y1,hgt_5days,res)
; plot0(1) = gsn_csm_xy (wks,y1,hgt_5days_avg,res2)
 plot1(1) = gsn_csm_xy (wks,y1,hgt_5days_avg_org,res3)
 res@gsnLeftString="5 days moving"
 res@tiYAxisString = "Expansion ratio" ; y-axis label
 plot(2) = gsn_csm_xy (wks,y2,hgt_mv_5,res)
; plot0(2) = gsn_csm_xy (wks,y2,hgt_mv_5_avg,res2)
 plot1(2) = gsn_csm_xy (wks,y2,hgt_mv_5_avg_org,res3)
 res@tiYAxisString = ""
 res@gsnLeftString="7 days moving"
 plot(3) = gsn_csm_xy (wks,y3,hgt_mv_7,res)
; plot0(3) = gsn_csm_xy (wks,y3,hgt_mv_7_avg,res2)
 plot1(3) = gsn_csm_xy (wks,y3,hgt_mv_7_avg_org,res3)
 res@tiYAxisString = "Expansion ratio" ; y-axis label
 res@gsnLeftString="9 days moving"
 res@tiXAxisString = "Time"
 plot(4) = gsn_csm_xy (wks,y4,hgt_mv_9,res)
; plot0(4) = gsn_csm_xy (wks,y4,hgt_mv_9_avg,res2)
 plot1(4) = gsn_csm_xy (wks,y4,hgt_mv_9_avg_org,res3)
 res@tiYAxisString = ""
 res@tiXAxisString = "Time"
 res@gsnLeftString="11 days moving"
 plot(5) = gsn_csm_xy (wks,y5,hgt_mv_11,res)
; plot0(5) = gsn_csm_xy (wks,y5,hgt_mv_11_avg,res2)
 plot1(5) = gsn_csm_xy (wks,y5,hgt_mv_11_avg_org,res2)

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
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
 plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)
 plot(4) = simple_legend(wks,plot(4),gres,lineres,textres)
 plot(5) = simple_legend(wks,plot(5),gres,lineres,textres)

 ;overlay(plot(0),plot0(0))
 overlay(plot(0),plot1(0))
 ;overlay(plot(1),plot0(1))
 overlay(plot(1),plot1(1))
 ;overlay(plot(2),plot0(2))
 overlay(plot(2),plot1(2))
 ;overlay(plot(3),plot0(3))
 overlay(plot(3),plot1(3))
 ;overlay(plot(4),plot0(4))
 overlay(plot(4),plot1(4))
 ;overlay(plot(5),plot0(5))
 overlay(plot(5),plot1(5))

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Tibetan high (200hpa; 2016, 2018, 2020)"
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
