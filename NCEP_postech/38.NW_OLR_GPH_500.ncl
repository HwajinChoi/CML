begin

dir1="/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/500/last/"
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
dir3="/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9/"

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
;----- 11 days moving; 2016, 2018, 2020-------------------------------------------------------------
dim=dimsizes(hgt)
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
HGT=hgt_mv_11(:,31:142,:,:); year(32) x time(112) x lat x lon
HGT_7_8_2=HGT(:,25:86,:,:)

HGT_ano=dim_avg_n_Wrap(HGT_7_8_2,0)
HGT_clim=dim_avg_n_Wrap(HGT_ano,0)
HGT_ANO=new((/32,62,dim(2),dim(3)/),"float")

 do i=0,31
 HGT_ANO(i,:,:,:)=HGT_7_8_2(i,:,:,:)-HGT_ano
 end do
copy_VarCoords(HGT_7_8_2,HGT_ANO)
HGT_7_8_abs=dim_avg_n_Wrap(HGT_7_8_2,1)
HGT_7_8=dim_avg_n_Wrap(HGT_ANO,1)
;---------- HGT, olr => 6 to 9 -----------
;        CASE 1
;---------------------------------------------------
case1_indo=(/1995,2006,2016,2020,2022/)
dim1=dimsizes(case1_indo)
OLR_case1=new((/dim1(0),62,dim(2),dim(3)/),"float")
D=9
 do i=0,dim1(0)-1
  OLR_case1(i,:,:,:)=olr(case1_indo(i)-1991,25-D:86-D,:,:)
 end do
OLR_CASE1_2=dim_avg_n_Wrap(OLR_case1,1)
OLR_CASE1=dim_avg_n_Wrap(OLR_CASE1_2,0)
;---------------------------------------------------
HGT_case1=new((/dim1(0),dim(2),dim(3)/),"float")
HGT_abs_case1=new((/dim1(0),dim(2),dim(3)/),"float")
 do i=0,dim1(0)-1
  HGT_case1(i,:,:)=HGT_7_8(case1_indo(i)-1991,:,:)
  HGT_abs_case1(i,:,:)=HGT_7_8_abs(case1_indo(i)-1991,:,:)
 end do
HGT_case1!0="year"
HGT_abs_case1!0="year"
HGT_CASE1=dim_avg_n_Wrap(HGT_case1,0)
HGT_abs_CASE1=dim_avg_n_Wrap(HGT_abs_case1,0)
;-------------------------------------
;        CASE 2
;---------------------------------------------------
case2_china=(/1994,2001,2006,2012,2020/)
dim2=dimsizes(case2_china)
OLR_case2=new((/dim2(0),62,dim(2),dim(3)/),"float")
D=5
 do i=0,dim2(0)-1
  OLR_case2(i,:,:,:)=olr(case2_china(i)-1991,25-D:86-D,:,:)
 end do
OLR_CASE2_2=dim_avg_n_Wrap(OLR_case2,1)
OLR_CASE2=dim_avg_n_Wrap(OLR_CASE2_2,0)
;---------------------------------------------------
HGT_case2=new((/dim2(0),dim(2),dim(3)/),"float")
HGT_abs_case2=new((/dim2(0),dim(2),dim(3)/),"float")
 do i=0,dim2(0)-1
  HGT_case2(i,:,:)=HGT_7_8(case2_china(i)-1991,:,:)
  HGT_abs_case2(i,:,:)=HGT_7_8_abs(case2_china(i)-1991,:,:)
 end do
HGT_case2!0="year"
HGT_abs_case2!0="year"
HGT_CASE2=dim_avg_n_Wrap(HGT_case2,0)
HGT_abs_CASE2=dim_avg_n_Wrap(HGT_abs_case2,0)
;-------------------------------------
;        CASE 3
;---------------------------------------------------
case3_china=(/1994,2001,2006/)
dim3=dimsizes(case3_china)
OLR_case3=new((/dim3(0),62,dim(2),dim(3)/),"float")
D=15
 do i=0,dim3(0)-1
  OLR_case3(i,:,:,:)=olr(case3_china(i)-1991,25-D:86-D,:,:)
 end do
OLR_CASE3_2=dim_avg_n_Wrap(OLR_case3,1)
OLR_CASE3=dim_avg_n_Wrap(OLR_CASE3_2,0)
;---------------------------------------------------
HGT_case3=new((/dim3(0),dim(2),dim(3)/),"float")
HGT_abs_case3=new((/dim3(0),dim(2),dim(3)/),"float")
 do i=0,dim3(0)-1
  HGT_case3(i,:,:)=HGT_7_8(case3_china(i)-1991,:,:)
  HGT_abs_case3(i,:,:)=HGT_7_8_abs(case3_china(i)-1991,:,:)
 end do
HGT_case3!0="year"
HGT_abs_case3!0="year"
HGT_CASE3=dim_avg_n_Wrap(HGT_case3,0)
HGT_abs_CASE3=dim_avg_n_Wrap(HGT_abs_case3,0)
;-------------------------------------
;        CASE 4
;---------------------------------------------------
case4_china=(/2012,2020/)
dim4=dimsizes(case4_china)
OLR_case4=new((/dim4(0),62,dim(2),dim(3)/),"float")
D=1
 do i=0,dim4(0)-1
  OLR_case4(i,:,:,:)=olr(case4_china(i)-1991,25-D:86-D,:,:)
 end do
OLR_CASE4_2=dim_avg_n_Wrap(OLR_case4,1)
OLR_CASE4=dim_avg_n_Wrap(OLR_CASE4_2,0)
;---------------------------------------------------
HGT_case4=new((/dim4(0),dim(2),dim(3)/),"float")
HGT_abs_case4=new((/dim4(0),dim(2),dim(3)/),"float")
 do i=0,dim4(0)-1
  HGT_case4(i,:,:)=HGT_7_8(case4_china(i)-1991,:,:)
  HGT_abs_case4(i,:,:)=HGT_7_8_abs(case4_china(i)-1991,:,:)
 end do
HGT_case4!0="year"
HGT_abs_case4!0="year"
HGT_CASE4=dim_avg_n_Wrap(HGT_case4,0)
HGT_abs_CASE4=dim_avg_n_Wrap(HGT_abs_case4,0)
;---------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir2+"NPH_ano_OLR_ano_GPH_delay_composite_MAP")

plot=new(8,"graphic")
plot1=new(4,"graphic")
plot2=new(4,"graphic")
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
res@gsnLeftStringFontHeightF=0.02
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      20 
res@cnMinLevelValF         =      -20
res@cnLevelSpacingF        =       4 
res@cnFillPalette          =       "MPL_RdBu"
;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
res@gsnCenterString="OLR"
res2@cnLevelSelectionMode   =       "ManualLevels"
res2@cnMaxLevelValF         =      35 
res2@cnMinLevelValF         =      -35
res2@cnLevelSpacingF        =       5 
res2@cnFillPalette          =       "BlueDarkRed18"
res2@mpMaxLatF=50
res2@mpMinLatF=10
res2@mpMinLonF=80
res2@mpMaxLonF=180
res2@mpCenterLonF=180
res2@gsnLeftString=""
res@gsnLeftString="-9 days"
plot(0)=gsn_csm_contour_map(wks,OLR_CASE1,res)
res2@gsnCenterString="NPH"
plot(1)=gsn_csm_contour_map(wks,HGT_CASE1,res2)
res@gsnCenterString=""
res2@gsnCenterString=""
res@gsnLeftString="-5 days"
plot(2)=gsn_csm_contour_map(wks,OLR_CASE2,res)
plot(3)=gsn_csm_contour_map(wks,HGT_CASE2,res2)
res@gsnLeftString="-15 days"
plot(4)=gsn_csm_contour_map(wks,OLR_CASE3,res)
plot(5)=gsn_csm_contour_map(wks,HGT_CASE3,res2)
res@lbLabelBarOn           =      True
res2@lbLabelBarOn           =      True
res@gsnLeftString="-1 days"
plot(6)=gsn_csm_contour_map(wks,OLR_CASE4,res)
plot(7)=gsn_csm_contour_map(wks,HGT_CASE4,res2)
;------------India-------------
ypts = (/20,20, 30,30,20/)
xpts = (/70,80,80,70,70/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 6.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(1,graphic)
dum2(0)=gsn_add_polyline(wks,plot(0),xpts,ypts,resp)
;-------------China--------------
ypts = (/15,15,25 ,25,15/)
xpts = (/105,130,130,105,105/)
dum3 = new(3,graphic)
 do I=0,2
  dum3(I)=gsn_add_polyline(wks,plot(2+2*I),xpts,ypts,resp)
 end do

ypts = (/31,31, 43,43,31/)
xpts = (/117,137,137,117,117/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 6.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum4 = new(4,graphic)
 do I=0,3
  dum4(I)=gsn_add_polyline(wks,plot(1+2*I),xpts,ypts,resp)
 end do
res3@gsnLeftString=""
res3@cnFillOn            = False
res3@cnInfoLabelOn=False
res3@cnLinesOn              =True
res3@cnLevelSelectionMode = "ExplicitLevels"
res3@cnLineColor="black"
res3@cnLineLabelsOn         =       True
res3@cnLineLabelStrings="5850"
res3@cnLevels = 5850.
res3@cnLineThicknessF=4
res3@cnMonoLevelFlag=True
res3@cnConstFLabelFontHeightF=0.005
res3@cnLineLabelsOn       = True
res4=res3
res4@cnLineColor="green"

plot2(0)=gsn_csm_contour(wks,HGT_abs_CASE1,res4)
plot2(1)=gsn_csm_contour(wks,HGT_abs_CASE2,res4)
plot2(2)=gsn_csm_contour(wks,HGT_abs_CASE3,res4)
plot2(3)=gsn_csm_contour(wks,HGT_abs_CASE4,res4)

do J=0,3
  plot1(J)=gsn_csm_contour(wks,HGT_clim,res3)
  overlay(plot(2*J+1),plot1(J))
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
txres1@txFontHeightF = 0.018 
txres1@txAngleF=90
gsn_text_ndc(wks,"Case1",0.05,0.87,txres1)
gsn_text_ndc(wks,"Case2",0.05,0.65,txres1)
gsn_text_ndc(wks,"Case3",0.05,0.42,txres1)
gsn_text_ndc(wks,"Case4",0.05,0.20,txres1)
gsn_panel(wks,plot,(/4,2/),pres)
frame(wks)

end
