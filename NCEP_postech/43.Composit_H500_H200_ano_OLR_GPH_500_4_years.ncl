begin
dir0="/media/cmlws/Data2/hjc/NCEP/data/"
dir1="/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/500/last/"
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
dir3="/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9/"
dir4="/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/200/last/"
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
U=addfile(dir4+"hgt_ano_mv_11_1991-2022.nc","r")          ;; FOR GRAY LINE
HGT_200=U->HGT_ANO ; year(32) x time(112) x lat x lon
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
case=(/1995,2010,2018,2022/)
dim0=dimsizes(case)
OLR_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
hgt_200_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
HGT_case=new((/dim0(0),dim00(2),dim00(3)/),"float")
HGT_abs_case=new((/dim0(0),dim00(2),dim00(3)/),"float")
HGT_clim=new((/dim0(0),dim00(2),dim00(3)/),"float")

 do j=0,dim0(0)-1
  L=maxind(hgt_mv_area_CLIM_2(case(j)-1991,:))
  OLR_case(j,0,:,:)=olr(case(j)-1991,L-15,:,:)
  OLR_case(j,1,:,:)=olr(case(j)-1991,L-10,:,:)
  OLR_case(j,2,:,:)=olr(case(j)-1991,L-5,:,:)
  OLR_case(j,3,:,:)=olr(case(j)-1991,L,:,:)

  hgt_200_case(j,0,:,:)=HGT_200(case(j)-1991,L-15,:,:)
  hgt_200_case(j,1,:,:)=HGT_200(case(j)-1991,L-10,:,:)
  hgt_200_case(j,2,:,:)=HGT_200(case(j)-1991,L-5,:,:)
  hgt_200_case(j,3,:,:)=HGT_200(case(j)-1991,L,:,:)

  HGT_case(j,:,:)=HGT_ANO(case(j)-1991,L,:,:)
  HGT_abs_case(j,:,:)=HGT_mv_11(case(j)-1991,L,:,:)
  HGT_clim(j,:,:)=HGT_clim1(L,:,:)
 end do
 OLR_case!0="year"
 OLR_case!1="case"
 OLR_case2=dim_avg_n_Wrap(OLR_case,0)
 hgt_200_case!0="year"
 hgt_200_case!1="case"
 hgt_200_case2=dim_avg_n_Wrap(hgt_200_case,0)
 HGT_case_500=dim_avg_n_Wrap(HGT_case,0)
 HGT_abs_case_500=dim_avg_n_Wrap(HGT_abs_case,0)
 HGT_clim_500=dim_avg_n_Wrap(HGT_clim,0)

 M=addfile(dir0+"H200_case_abs_clim_4_years.nc","r")
 HGT_case_200=M->HGT_case_200
 HGT_abs_case_200=M->HGT_abs_case_200
 HGT_clim_200=M->HGT_clim_200

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

wks = gsn_open_wks("pdf",dir2+"Composite_H500_H200_ano_OLR_delay_MAP_4_years")

plot=new(6,"graphic")
plot1=new(2,"graphic")
plot2=new(2,"graphic")
plot3=new(4,"graphic")
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
res@mpMaxLonF=220
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
res2@mpMaxLatF=50
res2@mpMinLatF=10
res2@mpMinLonF=80
res2@mpMaxLonF=180
res2@mpCenterLonF=180
res2@gsnLeftString=""
res@gsnCenterString=""
res@gsnLeftString="-15 days"
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I4(0))+", C:"+sprintf(fmt,OLR_case_C4(0))
plot(0)=gsn_csm_contour_map(wks,OLR_case2(0,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I4(1))+", C:"+sprintf(fmt,OLR_case_C4(1))
res@gsnLeftString="-10 days"
plot(1)=gsn_csm_contour_map(wks,OLR_case2(1,:,:),res)
res@gsnLeftString="-5 days"
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I4(2))+", C:"+sprintf(fmt,OLR_case_C4(2))
plot(2)=gsn_csm_contour_map(wks,OLR_case2(2,:,:),res)
res@gsnLeftString="0 day"
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I4(3))+", C:"+sprintf(fmt,OLR_case_C4(3))
plot(3)=gsn_csm_contour_map(wks,OLR_case2(3,:,:),res)
res2@gsnLeftString=""
res@gsnLeftString=""
res2@gsnCenterString="H500"
res2@cnLevelSelectionMode   =       "ManualLevels"
res22=res2
res2@cnMaxLevelValF         =      50.
res2@cnMinLevelValF         =      -50.
res2@cnLevelSpacingF        =       10.
plot(4)=gsn_csm_contour_map(wks,HGT_case_500,res2)
res22@gsnCenterString="H200"
res22@cnMaxLevelValF         =      100.
res22@cnMinLevelValF         =      -100.
res22@cnLevelSpacingF        =       20.
plot(5)=gsn_csm_contour_map(wks,HGT_case_200,res22)

;------------India-------------
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 2.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(4,graphic)
do i=0,3
dum2(i)=gsn_add_polyline(wks,plot(i),I_xpts,I_ypts,resp)
end do
;-------------China--------------
dum3 = new(4,graphic)
 do I=0,3
  dum3(I)=gsn_add_polyline(wks,plot(I),C_xpts,C_ypts,resp)
 end do
;----- KOREA ------------
ypts = (/31,31, 43,43,31/)
xpts = (/117,137,137,117,117/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 2.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum4 = new(2,graphic)
dum4(0)=gsn_add_polyline(wks,plot(4),xpts,ypts,resp)
dum4(1)=gsn_add_polyline(wks,plot(5),xpts,ypts,resp)
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
res6=res3
res3@cnLineLabelStrings="5880"
res3@cnLevels = 5880.
res6@cnLineLabelStrings="12480"
res6@cnLevels = 12480.
res4=res3
res7=res6
res4@cnLineColor="green" ; GREEN LINE
res7@cnLineColor="green" ; GREEN LINE
res5@cnFillOn            = False
res5@cnLinesOn              =True
res5@cnLineColor="gray40"
res5@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
res5@cnMinLevelValF       = -180.              ; set min contour level
res5@cnMaxLevelValF       =  180.              ; set max contour level
res5@cnLevelSpacingF      =  20.              ; set contour spacing
;res5@cnLineLabelInterval = 20
;res5@cnLevelFlags=test2

res5@gsnContourZeroLineThicknessF = 2.  ; doubles thickness of zero contour
res5@gsnContourNegLineDashPattern = 1   ; sets negative contours to dash pattern 1
res5@cnLineThicknessF=1
res5@cnLineLabelsOn         =       True

 do i=0,3
 plot3(i)=gsn_csm_contour(wks,hgt_200_case2(i,:,:),res5)
 overlay(plot(i),plot3(i))
 end do

 plot2(0)=gsn_csm_contour(wks,HGT_abs_case_500,res4); Green line
 plot1(0)=gsn_csm_contour(wks,HGT_clim_500,res3)

 plot2(1)=gsn_csm_contour(wks,HGT_abs_case_200,res7); Green line
 plot1(1)=gsn_csm_contour(wks,HGT_clim_200,res6)
 overlay(plot(4),plot1(0))
 overlay(plot(4),plot2(0))
 overlay(plot(5),plot1(1))
 overlay(plot(5),plot2(1))

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =      False
pres@gsnPanelYWhiteSpacePercent = 7
pres@gsnPanelXWhiteSpacePercent = 3
pres@lbLabelFontHeightF  = 0.005
pres@lbLabelStride     =   2
pres@gsnPanelLeft  =0.05
pres@pmLabelBarHeightF=0.04
pres@gsnPanelMainString        =   ""
pres@pmLabelBarWidthF=0.7
pres@pmLabelBarOrthogonalPosF=0.7
pres@gsnPanelRowSpec = True
;pres@pmLabelBarParallelPosF=-0.1

;gsn_text_ndc(wks,"OLR",0.44,0.78,txres1)
;gsn_text_ndc(wks,"H500",0.91,0.78,txres1)
gsn_panel(wks,plot,(/4,2/),pres)
frame(wks)

end
