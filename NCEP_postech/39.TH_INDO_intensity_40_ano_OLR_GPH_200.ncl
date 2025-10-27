begin

dir1="/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/200/last/"
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
dir3="/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9/"
dir4="/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/200/last/"

U=addfile(dir4+"hgt_ano_mv_11_1991-2022.nc","r")
HGT_300=U->HGT_ANO ; year(32) x time(112) x lat x lon
g=addfile(dir3+"OLR_11moving_199106-202209.nc","r") ; 6-9
olr0=g->orl ; year(32) x time(112) x lat x lon
olr_clim=dim_avg_n_Wrap(olr0,0)
dim00=dimsizes(olr0)
olr=new((/32,112,dim00(2),dim00(3)/),"float")
do i=0,dim00(0)-1
olr(i,:,:,:)=olr0(i,:,:,:)-olr_clim
end do
copy_VarCoords(olr0,olr)

files=systemfunc("ls "+dir1+"hgt.*.nc") ; 1991-2022 
f=addfiles(files,"r")
ListSetType(f,"join")
hgt_1=f[:]->hgt ; time -> 153 (5-9)
hgt=hgt_1(:,:,0,:,:); year(32) x time(153) x level x lat x lon (117-137°E, 31-43°N)
hgt!0="year"
dim=dimsizes(hgt)
;-----------------------------------------------------------------------------------------------
P=0.4
A=addfile(dir1+"hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11_CLIM=A->hgt_mv_11; year (32) x time (143)
hgt_mv_area_CLIM=where(hgt_mv_11_CLIM .ge. P,hgt_mv_11_CLIM,hgt_mv_11_CLIM@_FillValue)
copy_VarMeta(hgt_mv_11_CLIM,hgt_mv_area_CLIM)

HGT=new((/32,153/),"float") ; 5-9
HGT=0
HGT(:,6:148)=hgt_mv_area_CLIM
copy_VarMeta(hgt_mv_area_CLIM,HGT)
HGT@_FillValue=0

HGT_map=new((/32,153,dim(2),dim(3)/),"float")

do i=0,dim(2)-1
 do j=0,dim(3)-1
  HGT_map(:,:,i,j)=HGT
 end do
end do
copy_VarMeta(hgt,HGT_map)
HGT_map@_FillValue=0
;----- 11 days moving; 2016, 2018, 2020-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/32,tp,dim(2),dim(3)/),"float"); Target
imsi=new((/32,p,dim(2),dim(3)/),"float"); Chunck
do k=0,tp-1
  imsi(:,:,:,:)=hgt(:,k:k+p-1,:,:)
  hgt_mv_11(:,k,:,:)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
hgt_mv_11!0="year"
hgt_mv_11!1="time"
HGT_mv_11=new((/32,153,dim(2),dim(3)/),"float")
HGT_mv_11(:,6:148,:,:)=hgt_mv_11

HGT_masked=new((/32,153,dim(2),dim(3)/),"float") ; 5-9
HGT_masked=where(HGT_map .eq. HGT_map@_FillValue, HGT_mv_11@_FillValue,HGT_mv_11)
copy_VarCoords(HGT_mv_11,HGT_masked)

HGT_7_8_2=HGT_masked(:,61:122,:,:); year(32) x time(62) x lat x lon 

HGT_ano=dim_avg_n_Wrap(HGT_7_8_2,0)
HGT_clim1=dim_avg_n_Wrap(HGT_mv_11(:,61:122,:,:),0)
HGT_clim=dim_avg_n_Wrap(HGT_clim1,0); HGT_clim => 7-8, climatic HGT, for black line

HGT_ANO=new((/32,62,dim(2),dim(3)/),"float")
 do i=0,31
 HGT_ANO(i,:,:,:)=HGT_7_8_2(i,:,:,:)-HGT_ano ; HGT_ANO => 7-8, anomalous masked HGT, for color conture 
 end do
copy_VarCoords(HGT_7_8_2,HGT_ANO)
HGT_7_8_abs=dim_avg_n_Wrap(HGT_7_8_2,1); year x lat x lon, HGT_clim_sp => 7-9, climatic masked HGT, for green line
HGT_7_8=dim_avg_n_Wrap(HGT_ANO,1)
;---------- HGT, olr => 6 to 9 -----------
;---------------------------------------------------
;        CASE 1
;---------------------------------------------------
;case1_indo=(/1995,2006,2016,2020/)
case1_indo=(/1995/)
D=5
  OLR_case1=olr(case1_indo-1991,25-D:25-D+32,:,:)
  hgt_300_case1=HGT_300(case1_indo-1991,25-D:25-D+32,:,:)
OLR_CASE1=dim_avg_n_Wrap(OLR_case1,0)
HGT_300_CASE1=dim_avg_n_Wrap(hgt_300_case1,0)
;---------------------------------------------------
HGT_CASE1=HGT_7_8(case1_indo-1991,:,:)
HGT_abs_CASE1=HGT_7_8_abs(case1_indo-1991,:,:)
;-------------------------------------
;        CASE 2
;---------------------------------------------------
case2_indo=(/2010/)
D=8
OLR_case2=olr(case2_indo-1991,25-D:25-D+56,:,:)
hgt_300_case2=HGT_300(case2_indo-1991,25-D:25-D+56,:,:)
OLR_CASE2=dim_avg_n_Wrap(OLR_case2,0)
HGT_300_CASE2=dim_avg_n_Wrap(hgt_300_case2,0)
;---------------------------------------------------
HGT_CASE2=HGT_7_8(case2_indo-1991,:,:)
HGT_abs_CASE2=HGT_7_8_abs(case2_indo-1991,:,:)
;-------------------------------------
;        CASE 3
;---------------------------------------------------
case3_indo=(/2016/)
D=13
OLR_case3=olr(case3_indo-1991,25-D:25-D+43,:,:)
hgt_300_case3=HGT_300(case3_indo-1991,25-D:25-D+43,:,:)
OLR_CASE3=dim_avg_n_Wrap(OLR_case3,0)
HGT_300_CASE3=dim_avg_n_Wrap(hgt_300_case3,0)
;---------------------------------------------------
HGT_CASE3=HGT_7_8(case3_indo-1991,:,:)
HGT_abs_CASE3=HGT_7_8_abs(case3_indo-1991,:,:)
;-------------------------------------
;        CASE 4
;---------------------------------------------------
case4_indo=(/2020/)
D=5
  OLR_case4=olr(case4_indo-1991,25-D:25-D+36,:,:)
hgt_300_case4=HGT_300(case4_indo-1991,25-D:25-D+36,:,:)
OLR_CASE4=dim_avg_n_Wrap(OLR_case4,0)
HGT_300_CASE4=dim_avg_n_Wrap(hgt_300_case4,0)
;---------------------------------------------------
HGT_CASE4=HGT_7_8(case4_indo-1991,:,:)
HGT_abs_CASE4=HGT_7_8_abs(case4_indo-1991,:,:)
;---------------------------------------------------------------------------
;        CASE 0
;---------------------------------------------------
case0_indo=(/1995,2010,2016,2020/)
OLR_CASE0=(OLR_CASE1+OLR_CASE2+OLR_CASE3+OLR_CASE4)/4
HGT_CASE0=(HGT_CASE1+HGT_CASE2+HGT_CASE3+HGT_CASE4)/4
HGT_abs_CASE0=(HGT_abs_CASE1+HGT_abs_CASE2+HGT_abs_CASE3+HGT_abs_CASE4)/4
HGT_300_CASE0=(HGT_300_CASE1+HGT_300_CASE2+HGT_300_CASE3+HGT_300_CASE4)/4
copy_VarCoords(OLR_CASE1,OLR_CASE0)
copy_VarCoords(HGT_CASE1,HGT_CASE0)
copy_VarCoords(HGT_abs_CASE1,HGT_abs_CASE0)
copy_VarCoords(HGT_300_CASE1,HGT_300_CASE0)
;printMinMax(HGT_300_CASE1,0)
;printMinMax(HGT_300_CASE4,0)
;exit

test2=new(20,"string")
test2(0:9)="LineOnly"
test2(10:19)="LineAndLabel"

 wks = gsn_open_wks("png",dir2+"TH_INDO_ano_OLR_ano_GPH_delay_composite_MAP")

plot=new(10,"graphic")
plot1=new(5,"graphic")
plot2=new(5,"graphic")
plot3=new(5,"graphic")
res   = True
res@gsnDraw            = False             ; don't draw yet
res@gsnFrame           = False             ; don't advance frame yet
res@vpHeightF          = 0.4
res@vpWidthF           = 0.7
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn              =       False
res@cnLineLabelsOn         =       False
res@lbLabelBarOn           =      False
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       2   
res@tmYLLabelStride     =       2   
res@gsnRightString=""
res@pmLabelBarOrthogonalPosF=0.3
;res@mpLandFillColor    =   "black"
res3=res
res5=res
res@gsnCenterStringOrthogonalPosF=0.1
res@mpMaxLatF=70
res@mpMinLatF=-10
res@mpMinLonF=40
res@mpMaxLonF=220
res@mpCenterLonF=180
res@gsnCenterStringFontHeightF=0.035
res@gsnMaximize        =       False
res@lbLabelFontHeightF  = 0.025
res@lbLabelStride     =   2
res@pmLabelBarWidthF=0.7
res@pmLabelBarHeightF=0.10
res2=res
res@gsnLeftStringFontHeightF=0.03
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      20 
res@cnMinLevelValF         =      -20
res@cnLevelSpacingF        =       4 
res@cnFillPalette          =       "MPL_RdBu"
;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
res@gsnCenterString="OLR"
res2@cnLevelSelectionMode   =       "ManualLevels"
res2@cnMaxLevelValF         =      70 
res2@cnMinLevelValF         =      -70
res2@cnLevelSpacingF        =       10 
res2@cnFillPalette          =       "BlueDarkRed18"
res2@mpMaxLatF=50
res2@mpMinLatF=10
res2@mpMinLonF=80
res2@mpMaxLonF=180
res2@mpCenterLonF=180
res2@gsnLeftString=""
res@gsnLeftString=""
plot(0)=gsn_csm_contour_map(wks,OLR_CASE0,res)
res2@gsnCenterString="TH"
plot(1)=gsn_csm_contour_map(wks,HGT_CASE0,res2)
res@gsnCenterString=""
res2@gsnCenterString=""
res@gsnLeftString="-5 days"
plot(2)=gsn_csm_contour_map(wks,OLR_CASE1,res)
plot(3)=gsn_csm_contour_map(wks,HGT_CASE1,res2)
res@gsnLeftString="-8 days"
plot(4)=gsn_csm_contour_map(wks,OLR_CASE2,res)
plot(5)=gsn_csm_contour_map(wks,HGT_CASE2,res2)
res@gsnLeftString="-13 days"
plot(6)=gsn_csm_contour_map(wks,OLR_CASE3,res)
plot(7)=gsn_csm_contour_map(wks,HGT_CASE3,res2)
res@lbLabelBarOn           =      True
res2@lbLabelBarOn           =      True
res@gsnLeftString="-5 day"
plot(8)=gsn_csm_contour_map(wks,OLR_CASE4,res)
plot(9)=gsn_csm_contour_map(wks,HGT_CASE4,res2)
;------------India-------------
ypts = (/20,20, 30,30,20/)
xpts = (/70,80,80,70,70/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 6.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(5,graphic)
do i=0,4
dum2(i)=gsn_add_polyline(wks,plot(2*i),xpts,ypts,resp)
end do
;-------------China--------------
ypts = (/15,15,25 ,25,15/)
xpts = (/105,130,130,105,105/)
dum3 = new(3,graphic)
; do I=0,2
;  dum3(I)=gsn_add_polyline(wks,plot(2+2*I),xpts,ypts,resp)
; end do

ypts = (/31,31, 43,43,31/)
xpts = (/117,137,137,117,117/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 6.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum4 = new(5,graphic)
 do I=0,4
  dum4(I)=gsn_add_polyline(wks,plot(1+2*I),xpts,ypts,resp)
 end do
res3@gsnLeftString=""
res3@cnFillOn            = False
res3@cnInfoLabelOn=False
res3@cnLinesOn              =True
res3@cnLevelSelectionMode = "ExplicitLevels"
res3@cnLineColor="black"
res3@cnLineLabelsOn         =       True
res3@cnLineLabelStrings="12480"
res3@cnLevels = 12480.
res3@cnLineThicknessF=4
res3@cnMonoLevelFlag=True
res3@cnConstFLabelFontHeightF=0.005
res3@cnLineLabelsOn       = True
res4=res3
res4@cnLineColor="green"

res5@cnFillOn            = False
res5@cnLinesOn              =True
res5@cnLineColor="gray40"
res5@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
res5@cnMinLevelValF       = -250.              ; set min contour level
res5@cnMaxLevelValF       =  250.              ; set max contour level
res5@cnLevelSpacingF      =  25.              ; set contour spacing
;res5@cnLineLabelInterval = 20
res5@cnLevelFlags=test2

res5@gsnContourZeroLineThicknessF = 2. 	; doubles thickness of zero contour
res5@gsnContourNegLineDashPattern = 1 	; sets negative contours to dash pattern 1
res5@cnLineThicknessF=3
res5@cnLineLabelsOn         =       True
 
plot3(0)=gsn_csm_contour(wks,HGT_300_CASE0,res5)
plot3(1)=gsn_csm_contour(wks,HGT_300_CASE1,res5)
plot3(2)=gsn_csm_contour(wks,HGT_300_CASE2,res5)
plot3(3)=gsn_csm_contour(wks,HGT_300_CASE3,res5)
plot3(4)=gsn_csm_contour(wks,HGT_300_CASE4,res5)

plot2(0)=gsn_csm_contour(wks,HGT_abs_CASE0,res4)
plot2(1)=gsn_csm_contour(wks,HGT_abs_CASE1,res4)
plot2(2)=gsn_csm_contour(wks,HGT_abs_CASE2,res4)
plot2(3)=gsn_csm_contour(wks,HGT_abs_CASE3,res4)
plot2(4)=gsn_csm_contour(wks,HGT_abs_CASE4,res4)

do J=0,4
  plot1(J)=gsn_csm_contour(wks,HGT_clim,res3)
  overlay(plot(2*J+1),plot1(J))
  overlay(plot(2*J),plot3(J))
  overlay(plot(2*J+1),plot2(J))
 end do

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =      False 
pres@gsnPanelYWhiteSpacePercent = 1 
pres@gsnPanelXWhiteSpacePercent = 3 
pres@lbLabelFontHeightF  = 0.015
pres@lbLabelStride     =   2   
pres@gsnPanelBottom  =0.1
pres@pmLabelBarOrthogonalPosF=0.05
pres@pmLabelBarHeightF=0.08
pres@gsnPanelMainString        =   ""
pres@pmLabelBarWidthF=0.7
txres               = True                      ; text mods desired
txres@txFontHeightF = 0.012 
gsn_text_ndc(wks,"W/m~S~2~N~",0.51,0.07,txres)
txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.016 
;txres1@txAngleF=90
gsn_text_ndc(wks,"Comp",0.10,0.9,txres1)
gsn_text_ndc(wks,"1995",0.10,0.73,txres1)
gsn_text_ndc(wks,"2010",0.10,0.54,txres1)
gsn_text_ndc(wks,"2016",0.10,0.36,txres1)
gsn_text_ndc(wks,"2020",0.10,0.19,txres1)
gsn_panel(wks,plot,(/5,2/),pres)
frame(wks)

end
