begin
dir0="/media/cmlws/Data2/hjc/NCEP/data/"
dir1="/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/500/last/"
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
dir3="/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9/"
dir4="/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/200/last/"
dir5="/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/850/last/"
fmt="%5.2f"
;------------India-------------
I_lon_s=55
I_lon_f=80
I_lat_s=20
I_lat_f=30
I_ypts = (/I_lat_s,I_lat_s,I_lat_f,I_lat_f,I_lat_s/)
I_xpts = (/I_lon_s,I_lon_f,I_lon_f,I_lon_s,I_lon_s/) ; 70 -> 55
;-------------China--------------
C_lon_s=105
C_lon_f=130
C_lat_s=15
C_lat_f=25
C_ypts = (/C_lat_s,C_lat_s,C_lat_f,C_lat_f,C_lat_s/)
C_xpts = (/C_lon_s,C_lon_f,C_lon_f,C_lon_s,C_lon_s/)
;-----------------------------------------------------------------------------------------------
U=addfile(dir5+"hgt_ano_mv_11_1991-2022.nc","r")          ;; FOR GRAY LINE
HGT_850=U->HGT_ANO ; year(32) x time(112) x lat x lon
V=addfile(dir1+"hgt_ano_mv_11_1991-2022.nc","r")
HGT_500=V->HGT_ANO
g=addfile(dir3+"OLR_11moving_199106-202209.nc","r") ; 6-9
olr0=g->orl ; year(32) x time(112) x lat x lon
olr_clim=dim_avg_n_Wrap(olr0,0)
dim00=dimsizes(olr0)
olr=new((/32,112,dim00(2),dim00(3)/),"float")
 do i=0,dim00(0)-1
  olr(i,:,:,:)=olr0(i,:,:,:)-olr_clim
 end do
copy_VarCoords(olr0,olr)
;-----------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------
files=systemfunc("ls "+dir1+"hgt.*.nc") ; 1991-2022        ;; FOR A RIGHTEST PLOT 
f=addfiles(files,"r")
ListSetType(f,"join")
hgt_1=f[:]->hgt ; time -> 153 (5-9)
hgt=hgt_1(:,:,0,:,:); year(32) x time(153) x level x lat x lon (117-137°E, 31-43°N)
hgt!0="year"
dim=dimsizes(hgt)
;----- 11 days moving-------------------------------------------------------------
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
HGT_mv_11=hgt_mv_11(:,31:142,:,:)

HGT_clim1=dim_avg_n_Wrap(HGT_mv_11,0)
HGT_ano=dim_avg_n_Wrap(HGT_mv_11,0)
HGT_ANO=new((/32,112,dim(2),dim(3)/),"float")
 do i=0,31
 HGT_ANO(i,:,:,:)=HGT_mv_11(i,:,:,:)-HGT_ano ; HGT_ANO => 7-8, anomalous masked HGT, for color conture 
 end do
copy_VarCoords(HGT_mv_11,HGT_ANO)
;-----------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------
P=0.4
A=addfile(dir1+"hgt_count_mv_11_1991-2022.nc","r")          ;; FOR FINDING HIGHEST DAY
hgt_mv_11_CLIM=A->hgt_mv_11; year (32) x time (143)
hgt_mv_area_CLIM=where(hgt_mv_11_CLIM .ge. P,hgt_mv_11_CLIM,hgt_mv_11_CLIM@_FillValue)
copy_VarMeta(hgt_mv_11_CLIM,hgt_mv_area_CLIM)
hgt_mv_area_CLIM_2=hgt_mv_area_CLIM(:,31:142)
;---------------------------------------------------
;        CASE 
;---------------------------------------------------
;case=(/1994,1995,2001,2006,2010,2012,2016,2018,2020,2022/)
case=(/1994,1995,2006,2010,2012,2018,2020/)
dim0=dimsizes(case)
OLR_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
hgt_850_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
hgt_500_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
HGT_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
HGT_abs_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
HGT_clim=new((/dim0(0),4,dim00(2),dim00(3)/),"float")

 do j=0,dim0(0)-1
  L=maxind(hgt_mv_area_CLIM_2(case(j)-1991,:))
  OLR_case(j,0,:,:)=olr(case(j)-1991,L-15,:,:)
  OLR_case(j,1,:,:)=olr(case(j)-1991,L-10,:,:)
  OLR_case(j,2,:,:)=olr(case(j)-1991,L-5,:,:)
  OLR_case(j,3,:,:)=olr(case(j)-1991,L,:,:)

  hgt_850_case(j,0,:,:)=HGT_850(case(j)-1991,L-15,:,:)
  hgt_850_case(j,1,:,:)=HGT_850(case(j)-1991,L-10,:,:)
  hgt_850_case(j,2,:,:)=HGT_850(case(j)-1991,L-5,:,:)
  hgt_850_case(j,3,:,:)=HGT_850(case(j)-1991,L,:,:)

  hgt_500_case(j,0,:,:)=HGT_500(case(j)-1991,L-15,:,:)
  hgt_500_case(j,1,:,:)=HGT_500(case(j)-1991,L-10,:,:)
  hgt_500_case(j,2,:,:)=HGT_500(case(j)-1991,L-5,:,:)
  hgt_500_case(j,3,:,:)=HGT_500(case(j)-1991,L,:,:)

  HGT_case(j,0,:,:)=HGT_ANO(case(j)-1991,L-15,:,:)
  HGT_case(j,1,:,:)=HGT_ANO(case(j)-1991,L-10,:,:)
  HGT_case(j,2,:,:)=HGT_ANO(case(j)-1991,L-5,:,:)
  HGT_case(j,3,:,:)=HGT_ANO(case(j)-1991,L,:,:)

  HGT_abs_case(j,0,:,:)=HGT_mv_11(case(j)-1991,L-15,:,:)
  HGT_abs_case(j,1,:,:)=HGT_mv_11(case(j)-1991,L-10,:,:)
  HGT_abs_case(j,2,:,:)=HGT_mv_11(case(j)-1991,L-5,:,:)
  HGT_abs_case(j,3,:,:)=HGT_mv_11(case(j)-1991,L,:,:)

  HGT_clim(j,0,:,:)=HGT_clim1(L-15,:,:)
  HGT_clim(j,1,:,:)=HGT_clim1(L-10,:,:)
  HGT_clim(j,2,:,:)=HGT_clim1(L-5,:,:)
  HGT_clim(j,3,:,:)=HGT_clim1(L,:,:)
 end do
 OLR_case!0="year"
 OLR_case!1="case"
 OLR_case2=dim_avg_n_Wrap(OLR_case,0)
 hgt_850_case!0="year"
 hgt_850_case!1="case"
 hgt_500_case!0="year"
 hgt_500_case!1="case"
 HGT_case!0="year"
 HGT_case!1="case"
 HGT_abs_case!0="year"
 HGT_abs_case!1="case"
 HGT_clim!0="year"
 HGT_clim!1="case"

 hgt_500_case2=dim_avg_n_Wrap(hgt_500_case,0)
 HGT_case_500=dim_avg_n_Wrap(HGT_case,0)
 HGT_abs_case_500=dim_avg_n_Wrap(HGT_abs_case,0)
 HGT_clim_500=dim_avg_n_Wrap(HGT_clim,0)

 HGT_case_850 =dim_avg_n_Wrap(hgt_850_case,0)

OLR_case_I=OLR_case(:,:,{I_lat_s:I_lat_f},{I_lon_s:I_lon_f})
OLR_case_I2=dim_avg_n_Wrap(OLR_case_I,2)
OLR_case_I3=dim_avg_n_Wrap(OLR_case_I2,2)
OLR_case_I4=dim_avg_n_Wrap(OLR_case_I3,0)

OLR_case_C=OLR_case(:,:,{C_lat_s:C_lat_f},{C_lon_s:C_lon_f})
OLR_case_C2=dim_avg_n_Wrap(OLR_case_C,2)
OLR_case_C3=dim_avg_n_Wrap(OLR_case_C2,2)
OLR_case_C4=dim_avg_n_Wrap(OLR_case_C3,0)

;test2=new(dim0(0)*4,"string")
;test2(0:9)="LineOnly"
;test2(10:19)="LineAndLabel"

wks = gsn_open_wks("pdf",dir2+"last_Composite_H850_H500_ano_OLR_7_years")

plot=new(12,"graphic")
plot1=new(4,"graphic"); 5880 black
plot2=new(4,"graphic"); 5880 green
plot3=new(8,"graphic")

res   = True
res@gsnDraw            = False             ; don't draw yet
res@gsnFrame           = False             ; don't advance frame yet
res@vpHeightF          = 0.4
res@vpWidthF           = 0.7
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn              =       False
res@cnLineLabelsOn         =       False
res@lbLabelBarOn           =      True
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       2
res@tmYLLabelStride     =       2
res@pmLabelBarOrthogonalPosF=0.3
;res@mpLandFillColor    =   "black"
res3=res
res5=res
res@gsnCenterStringOrthogonalPosF=0.1
res@mpMaxLatF=70
res@mpMinLatF=-10
res@mpMinLonF=40
res@mpMaxLonF=180
res@mpCenterLonF=180
res@gsnLeftStringFontHeightF=0.038
res@gsnMaximize        =       False
res@lbLabelFontHeightF  = 0.025
res@lbLabelStride     =   2
res@pmLabelBarWidthF=0.7
res@pmLabelBarHeightF=0.10
res2=res
res2@gsnCenterStringFontHeightF=0.038
res@gsnRightStringFontHeightF=0.03
res2@gsnRightStringFontHeightF=0.03
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      30.
res@cnMinLevelValF         =      -30.
res@cnLevelSpacingF        =       5.
res@cnFillPalette          =       "BlueDarkOrange18"
;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
res2@cnFillPalette          =       "BlueDarkRed18"
;res2@mpMaxLatF=50
;res2@mpMinLatF=10
;res2@mpMinLonF=80
;res2@mpMaxLonF=180
;res2@mpCenterLonF=180
res2@gsnLeftString=""
res@gsnCenterString=""
res@gsnLeftString="-15 days"
res@gsnRightString="C:"+sprintf(fmt,OLR_case_C4(0))
plot(8)=gsn_csm_contour_map(wks,OLR_case2(0,:,:),res)
res@gsnRightString="C:"+sprintf(fmt,OLR_case_C4(1))
res@gsnLeftString="-10 days"
plot(9)=gsn_csm_contour_map(wks,OLR_case2(1,:,:),res)
res@gsnLeftString="-5 days"
res@gsnRightString="C:"+sprintf(fmt,OLR_case_C4(2))
plot(10)=gsn_csm_contour_map(wks,OLR_case2(2,:,:),res)
res@gsnLeftString="0 day"
res@gsnRightString="C:"+sprintf(fmt,OLR_case_C4(3))
plot(11)=gsn_csm_contour_map(wks,OLR_case2(3,:,:),res)
res2@gsnLeftString=""
res@gsnLeftString=""
res2@gsnCenterString=""
res2@cnLevelSelectionMode   =       "ManualLevels"
res33=res2
res2@cnMaxLevelValF         =      60.
res2@cnMinLevelValF         =      -60.
res2@cnLevelSpacingF        =       10.
;------------ 850 hpa
res33@cnMaxLevelValF         =      40.
res33@cnMinLevelValF         =      -40.
res33@cnLevelSpacingF        =       5.

res2@gsnLeftString="-15 days"
res33@gsnLeftString="-15 days"
plot(0)=gsn_csm_contour_map(wks,HGT_case_500(0,:,:),res2)
plot(4)=gsn_csm_contour_map(wks,HGT_case_850(0,:,:),res33)
res2@gsnLeftString="-10 days"
res33@gsnLeftString="-10 days"
plot(1)=gsn_csm_contour_map(wks,HGT_case_500(1,:,:),res2)
plot(5)=gsn_csm_contour_map(wks,HGT_case_850(1,:,:),res33)
res2@gsnLeftString="-5 days"
res33@gsnLeftString="-5 days"
plot(2)=gsn_csm_contour_map(wks,HGT_case_500(2,:,:),res2)
plot(6)=gsn_csm_contour_map(wks,HGT_case_850(2,:,:),res33)
res2@gsnLeftString="0 days"
res33@gsnLeftString="0 days"
plot(3)=gsn_csm_contour_map(wks,HGT_case_500(3,:,:),res2)
plot(7)=gsn_csm_contour_map(wks,HGT_case_850(3,:,:),res33)
;------------China-------------
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 2.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(4,graphic)
do i=0,3
dum2(i)=gsn_add_polyline(wks,plot(8+i),C_xpts,C_ypts,resp)
end do
;----- KOREA ------------
ypts = (/31,31, 43,43,31/)
xpts = (/117,137,137,117,117/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 2.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum4 = new(8,graphic)
do i=0,7
 dum4(i)=gsn_add_polyline(wks,plot(i),xpts,ypts,resp)
end do
res3@gsnLeftString=""
res3@cnFillOn            = False
res3@cnInfoLabelOn=False
res3@cnLinesOn              =True
res3@cnLevelSelectionMode = "ExplicitLevels"
res3@cnLineColor="black"
res3@cnLineLabelsOn         =       True
res3@cnLineThicknessF=2
res3@cnMonoLevelFlag=True
res3@cnConstFLabelFontHeightF=0.005
res3@cnLineLabelsOn       = True
res3@cnLineLabelStrings="5880"
res3@cnLevels = 5880.
res7=res3
res7@cnLineColor="green" ; GREEN LINE

do i=0,3
 plot2(i)=gsn_csm_contour(wks,HGT_abs_case_500(i,:,:),res7); Green line
 plot1(i)=gsn_csm_contour(wks,HGT_clim_500(i,:,:),res3)
 overlay(plot(i),plot1(i))
 overlay(plot(i),plot2(i))
end do

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =      False
pres@gsnPanelYWhiteSpacePercent = 7
pres@gsnPanelXWhiteSpacePercent = 3
pres@lbLabelFontHeightF  = 0.005
pres@lbLabelStride     =   2
pres@gsnPanelCenter = False
pres@gsnPanelLeft  =0.06
pres@pmLabelBarHeightF=0.04
pres@gsnPanelMainString        =   ""
pres@pmLabelBarWidthF=0.7
pres@pmLabelBarOrthogonalPosF=0.7
;pres@pmLabelBarParallelPosF=-0.1

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.016
gsn_text_ndc(wks,"H500",0.03,0.73,txres1)
gsn_text_ndc(wks,"H850",0.03,0.52,txres1)
gsn_text_ndc(wks,"OLR",0.03,0.305,txres1)
gsn_panel(wks,plot,(/3,4/),pres)
frame(wks)

end
