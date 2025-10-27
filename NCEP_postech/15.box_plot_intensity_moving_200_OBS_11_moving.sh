#!/bin/bash

for h in "200" ;do
dir0=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/tas/specific/6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
C=12480
;-------------------------------------------------------------------
hfiles=systemfunc("ls ${dir3}/st*_11moving_1991-2022_June_Sep.nc")
h=addfiles(hfiles,"r")
ListSetType(h,"join")
tas_mv_11=h[:]->tas_mv_11
tas_mv_11!0="site"
tas_mv_11_k=dim_avg_n_Wrap(tas_mv_11,0) ; year(1991-2022) x time 112 (6-9)
tas_mv_11_6_9=tas_mv_11_k; year(32) x time 112 (7-9)
;-------------------------------------------------------------------
TAS_mv_11_cases=new((/3,112/),"float")
TAS_mv_11_cases(0,:)=tas_mv_11_6_9(25,:)
TAS_mv_11_cases(1,:)=tas_mv_11_6_9(27,:)
TAS_mv_11_cases(2,:)=tas_mv_11_6_9(29,:)
TAS_mv_11_cases!0="case"

A=addfile("${dir2}/hgt_count_"+C+"_mv_11_1991-2020.nc","r")
hgt_mv_11=A->hgt_mv_11; year(30) x time(143) 
hgt_mv_11_6_9=hgt_mv_11(:,31:142) ; time 112 (7-9)
;-------------------------------------------------------------------
files=systemfunc("ls ${dir0}/hgt.${h}.202[1-2].nc")
f=addfiles(files,"r")
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)
hgt_mask=where(hgt .ge. C, 1,0)
copy_VarMeta(hgt,hgt_mask)
test=dim_sum_n_Wrap(hgt_mask,2)
hgt_count=dim_sum_n_Wrap(test,2)
hgt_count2=int2flt(hgt_count)
hgt_count2 := hgt_count2/40.

;----- 11 days moving; 2021, 2022-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_20=new((/2,tp/),"float"); Target
imsi=new((/2,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
  hgt_mv_20(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_20!0="year"
hgt_mv_20!1="time"
hgt_mv_20_6_9=hgt_mv_20(:,31:142)

HGT_mv_11_6_9=new((/32,112/),"float")
HGT_mv_11_6_9(0:29,:)=hgt_mv_11_6_9
HGT_mv_11_6_9(30:31,:)=hgt_mv_20_6_9
;-------------------------------------------------------------------
HGT_mv_11_cases=new((/3,112/),"float")
HGT_mv_11_cases(0,:)=hgt_mv_11_6_9(25,:)
HGT_mv_11_cases(1,:)=hgt_mv_11_6_9(27,:)
HGT_mv_11_cases(2,:)=hgt_mv_11_6_9(29,:)
HGT_mv_11_cases!0="case"
;-------------------------------------------------------------------
P=0.4
per=flt2string(P)
;---------------------------------------------------------------------------
y=ispan(1,153,1)
;-------------------------------------------------------------------
;-------------------------------------------------------------------
; tas_mv_11_6_9 => total year
; TAS_mv_11_cases => 3 years case
; HGT_mv_11_6_9 => total year 
; HGT_mv_11_cases => 3 years case
;-------------------------------------------------------------------
;-------------------------------------------------------------------
hgt_mv_area_cases=where(HGT_mv_11_cases .ge. P,HGT_mv_11_cases,HGT_mv_11_cases@_FillValue)
copy_VarMeta(HGT_mv_11_cases,hgt_mv_area_cases)
tas_mv_area_cases=where(HGT_mv_11_cases .ge. P,TAS_mv_11_cases,TAS_mv_11_cases@_FillValue)
copy_VarMeta(TAS_mv_11_cases,tas_mv_area_cases)

hgt_mv_area=where(HGT_mv_11_6_9 .ge. P,HGT_mv_11_6_9,HGT_mv_11_6_9@_FillValue)
copy_VarMeta(HGT_mv_11_6_9,hgt_mv_area)
tas_mv_area=where(HGT_mv_11_6_9 .ge. P,tas_mv_11_6_9,tas_mv_11_6_9@_FillValue)
copy_VarMeta(tas_mv_11_6_9,tas_mv_area)
;-------------------------------------------------------------------
YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)
;-------------- For statistics ----------------------------------------------------
; tas_mv_11_6_9 ; year (32) x time (112) 
; HGT_mv_11_6_9
tas_mv_11_6_9_2=ndtooned(tas_mv_11_6_9)
HGT_mv_11_6_9_2=ndtooned(HGT_mv_11_6_9)

tas_04=where(HGT_mv_11_6_9_2 .ge. 0.4 .and. HGT_mv_11_6_9_2 .lt. 0.5,tas_mv_11_6_9_2,tas_mv_11_6_9_2@_FillValue)
tas_05=where(HGT_mv_11_6_9_2 .ge. 0.5 .and. HGT_mv_11_6_9_2 .lt. 0.6,tas_mv_11_6_9_2,tas_mv_11_6_9_2@_FillValue)
tas_06=where(HGT_mv_11_6_9_2 .ge. 0.6 .and. HGT_mv_11_6_9_2 .lt. 0.7,tas_mv_11_6_9_2,tas_mv_11_6_9_2@_FillValue)
tas_07=where(HGT_mv_11_6_9_2 .ge. 0.7 .and. HGT_mv_11_6_9_2 .lt. 0.8,tas_mv_11_6_9_2,tas_mv_11_6_9_2@_FillValue)
tas_08=where(HGT_mv_11_6_9_2 .ge. 0.8 .and. HGT_mv_11_6_9_2 .lt. 0.9,tas_mv_11_6_9_2,tas_mv_11_6_9_2@_FillValue)
tas_09=where(HGT_mv_11_6_9_2 .ge. 0.9 .and. HGT_mv_11_6_9_2 .lt. 1.0,tas_mv_11_6_9_2,tas_mv_11_6_9_2@_FillValue)

tas_case_04=where(HGT_mv_11_cases .ge. 0.4 .and. HGT_mv_11_cases .lt. 0.5,TAS_mv_11_cases,TAS_mv_11_cases@_FillValue)
tas_case_05=where(HGT_mv_11_cases .ge. 0.5 .and. HGT_mv_11_cases .lt. 0.6,TAS_mv_11_cases,TAS_mv_11_cases@_FillValue)
tas_case_06=where(HGT_mv_11_cases .ge. 0.6 .and. HGT_mv_11_cases .lt. 0.7,TAS_mv_11_cases,TAS_mv_11_cases@_FillValue)
tas_case_07=where(HGT_mv_11_cases .ge. 0.7 .and. HGT_mv_11_cases .lt. 0.8,TAS_mv_11_cases,TAS_mv_11_cases@_FillValue)
tas_case_08=where(HGT_mv_11_cases .ge. 0.8 .and. HGT_mv_11_cases .lt. 0.9,TAS_mv_11_cases,TAS_mv_11_cases@_FillValue)
tas_case_09=where(HGT_mv_11_cases .ge. 0.9 .and. HGT_mv_11_cases .lt. 1.0,TAS_mv_11_cases,TAS_mv_11_cases@_FillValue)
copy_VarMeta(TAS_mv_11_cases,tas_case_04)
copy_VarMeta(TAS_mv_11_cases,tas_case_05)
copy_VarMeta(TAS_mv_11_cases,tas_case_06)
copy_VarMeta(TAS_mv_11_cases,tas_case_07)
copy_VarMeta(TAS_mv_11_cases,tas_case_08)
copy_VarMeta(TAS_mv_11_cases,tas_case_09)

m_04=dim_median_n(tas_case_04,1)
m_05=dim_median_n(tas_case_05,1)
m_06=dim_median_n(tas_case_06,1)
m_07=dim_median_n(tas_case_07,1)
m_08=dim_median_n(tas_case_08,1)
m_09=dim_median_n(tas_case_09,1)

M_2016=new((/6/),"float")
M_2016(0)=m_04(0)
M_2016(1)=m_05(0)
M_2016(2)=m_06(0)
M_2016(3)=m_07(0)
M_2016(4)=m_08(0)
M_2016(5)=m_09(0)

M_2018=new((/6/),"float")
M_2018(0)=m_04(1)
M_2018(1)=m_05(1)
M_2018(2)=m_06(1)
M_2018(3)=m_07(1)
M_2018(4)=m_08(1)
M_2018(5)=m_09(1)

M_2020=new((/6/),"float")
M_2020(0)=m_04(2)
M_2020(1)=m_05(2)
M_2020(2)=m_06(2)
M_2020(3)=m_07(2)
M_2020(4)=m_08(2)
M_2020(5)=m_09(2)
;---------------------------------------------------------------------------
;----- It is needed for checking the number of data except missing values -----------
;---------------------------------------------------------------------------
;N2 = num(.not.ismissing(tas_02))
;N3 = num(.not.ismissing(tas_03))
;N4 = num(.not.ismissing(tas_04))
;N5 = num(.not.ismissing(tas_05))
;N6 = num(.not.ismissing(tas_06))
;N7 = num(.not.ismissing(tas_07))
;N8 = num(.not.ismissing(tas_08))
;N9 = num(.not.ismissing(tas_09))
;
;print(N2)
;print(N3)
;print(N4)
;print(N5)
;print(N6)
;print(N7)
;print(N8)
;print(N9)
;exit
;---------------------------------------------------------------------------
;y(n,0)=bottom_value, y(n,1)=bottom_value_of_box, y(n,2)=mid-value_of_box, y(n,3)=top_value_of_box, y(n,4)=top_value.
;---------------------------------------------------------------------------
S4=stat_dispersion(tas_04,True)
S5=stat_dispersion(tas_05,True)
S6=stat_dispersion(tas_06,True)
S7=stat_dispersion(tas_07,True)
S8=stat_dispersion(tas_08,True)
S9=stat_dispersion(tas_09,True)

TAS=new((/6,5/),"float"); for box plot
TAS(0,0)=S4(2)
TAS(0,1)=S4(6)
TAS(0,2)=S4(8)
TAS(0,3)=S4(10)
TAS(0,4)=S4(14)
TAS(1,0)=S5(2)
TAS(1,1)=S5(6)
TAS(1,2)=S5(8)
TAS(1,3)=S5(10)
TAS(1,4)=S5(14)
TAS(2,0)=S6(2)
TAS(2,1)=S6(6)
TAS(2,2)=S6(8)
TAS(2,3)=S6(10)
TAS(2,4)=S6(14)

TAS(3,0)=S7(2)
TAS(3,1)=S7(6)
TAS(3,2)=S7(8)
TAS(3,3)=S7(10)
TAS(3,4)=S7(14)
TAS(4,0)=S8(2)
TAS(4,1)=S8(6)
TAS(4,2)=S8(8)
TAS(4,3)=S8(10)
TAS(4,4)=S8(14)
TAS(5,0)=S9(2)
TAS(5,1)=S9(6)
TAS(5,2)=S9(8)
TAS(5,3)=S9(10)
TAS(5,4)=S9(14)

x=(/1,2,3,4,5,6/)
colors=new(6,"string")
colors="black"
;---------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir2+"6_9_Box_plot_7-9_"+C+"_OBS_Intensity_hgt_${h}_"+per)
 plot=new(1,"graphic")
 res   = True
 ;res@gsnDraw            = False             ; don't draw yet
 ;res@gsnFrame           = False             ; don't advance frame yet
 res@gsnMaximize = True                        ; Maximize box plot in frame.
 ;res@vpHeightF          = 0.4               ; change aspect ratio of plot
 ;res@vpWidthF           = 0.6
 res@trXMinF            = 0
 res@trXMaxF            =7
 res@trYMinF                  = 16
 res@trYMaxF                  = 30
 res@tmXBLabels=(/"0.4","0.5","0.6","0.7","0.8","0.9"/)
 res@tiXAxisString = "Intensity" ; y-axis label
 res@tiYAxisString = "Temperature (~S~o~N~C)" 
 res@tiMainString = "Tibetan High ("+C+", 40% Jun-Sep)"
 ;**********************************************
; resources for polylines that draws the boxes
;**********************************************  
  llres                   = True			
  llres@gsLineThicknessF  = 2.5                 ; line thickness 
;**********************************************
; resources that control color and width of boxes
;**********************************************  
  opti          = True			
  opti@boxWidth = 0.7				; Width of box (x units)
  opti@boxColors = colors 
;***********************************************
;***********************************************
  plot = boxplot(wks,x,TAS,opti,res,llres)	; All 3 options used...
;***********************************************
; add some polymarkers
;***********************************************
  mres               = True                     ; marker mods desired
  mres@gsMarkerIndex = 1                        ; polymarker style
  mres@gsMarkerSizeF = 40.                      ; polymarker size
  mres@gsMarkerColor = "red"                    ; polymarker color
  dum1 = gsn_add_polymarker(wks,plot,x,M_2016,mres) 
  mres@gsMarkerColor = "blue"                    ; polymarker color
  dum2 = gsn_add_polymarker(wks,plot,x,M_2018,mres) 
  mres@gsMarkerColor = "green"                    ; polymarker color
  dum3 = gsn_add_polymarker(wks,plot,x,M_2020,mres) 

 gres = True
 gres@YPosPercent = 25.    ; expressed as %, 0->100, sets position of top border of legend 
 gres@XPosPercent = 82      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
 gres@ItemSpacePercent = 7.
 lineres = True
 lineres@lgLineColors = (/"red","Blue","Green"/) 
 lineres@lgLineThicknesses = 5                        ; line thicknesses
 lineres@LineLengthPercent = 2.                         ; expressed as %, 0->100, length of line
 textres = True
 textres@lgLabelFontHeights = (/0.018,0.018,0.018/)                           ; label font heights
 textres@lgLabels = (/"2016","2018","2020"/)  ; legend labels (required)
 plot = simple_legend(wks,plot,gres,lineres,textres)
  
 draw(plot)
 frame(wks)
 

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done
