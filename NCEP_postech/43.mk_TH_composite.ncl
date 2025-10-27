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
files=systemfunc("ls "+dir4+"hgt.*.nc") ; 1991-2022        ;; FOR A RIGHTEST PLOT 
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
;case=(/1995,2006,2010,2012,2013,2016,2018,2019,2020,2022/)
;case=(/1995,2006,2010,2013,2018,2020,2022/)
case=(/1994,1995,2006,2010,2012,2018,2020/)

dim0=dimsizes(case)
OLR_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
hgt_200_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
HGT_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
HGT_abs_case=new((/dim0(0),4,dim00(2),dim00(3)/),"float")
HGT_clim=new((/dim0(0),4,dim00(2),dim00(3)/),"float")

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
 hgt_200_case!0="year"
 hgt_200_case!1="case"
 HGT_case!0="year"
 HGT_case!1="case"
 HGT_abs_case!0="year"
 HGT_abs_case!1="case"
 HGT_clim!0="year"
 HGT_clim!1="case"

 HGT_case2=dim_avg_n_Wrap(HGT_case,0)
 HGT_abs_case2=dim_avg_n_Wrap(HGT_abs_case,0)
 HGT_clim2=dim_avg_n_Wrap(HGT_clim,0)

 system("rm -f "+dir0+"H200_NW_standard_4_case_abs_clim_7_years.nc")
 out=addfile(    dir0+"H200_NW_standard_4_case_abs_clim_7_years.nc","c")
 out->HGT_case_200=HGT_case2
 out->HGT_abs_case_200=HGT_abs_case2
 out->HGT_clim_200=HGT_clim2
exit

test2=new(20,"string")
test2(0:9)="LineOnly"
test2(10:19)="LineAndLabel"
OLR_case_I=OLR_case(:,:,{I_lat_s:I_lat_f},{I_lon_s:I_lon_f})
OLR_case_I2=dim_avg_n_Wrap(OLR_case_I,2)
OLR_case_I3=dim_avg_n_Wrap(OLR_case_I2,2)

OLR_case_C=OLR_case(:,:,{C_lat_s:C_lat_f},{C_lon_s:C_lon_f})
OLR_case_C2=dim_avg_n_Wrap(OLR_case_C,2)
OLR_case_C3=dim_avg_n_Wrap(OLR_case_C2,2)

day=(/"7.23 - 8.2","8.11 - 8.21","7.27 - 8.6","7.24 - 8.3","7.28 - 8.7","7.19 - 7.29","7.15 - 7.25","7.26 - 8.5","8.8 - 8.18","7.25 - 8.6"/)

do K=0,1
wks = gsn_open_wks("pdf",dir2+"TH_10_years_ano_OLR_ano_GPH_delay_MAP_"+K)
plot=new(25,"graphic")
plot1=new(5,"graphic")
plot2=new(5,"graphic")
plot3=new(20,"graphic")
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
res@gsnLeftStringFontHeightF=0.038
res@gsnMaximize        =       False
res@lbLabelFontHeightF  = 0.025
res@lbLabelStride     =   2
res@pmLabelBarWidthF=0.7
res@pmLabelBarHeightF=0.10
res2=res
res2@gsnRightStringFontHeightF=0.03
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      30.
res@cnMinLevelValF         =      -30.
res@cnLevelSpacingF        =       5.
res@cnFillPalette          =       "BlueDarkOrange18"
;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
res2@cnLevelSelectionMode   =       "ManualLevels"
res2@cnMaxLevelValF         =      100.
res2@cnMinLevelValF         =      -100.
res2@cnLevelSpacingF        =       20.
res2@cnFillPalette          =       "BlueDarkRed18"
res2@mpMaxLatF=50
res2@mpMinLatF=10
res2@mpMinLonF=80
res2@mpMaxLonF=180
res2@mpCenterLonF=180
res2@gsnLeftString=""
res@gsnLeftString=""
res@gsnLeftString="-15 days"
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K,0))+", C:"+sprintf(fmt,OLR_case_C3(5*K,0))
plot(0)=gsn_csm_contour_map(wks,OLR_case(5*K,0,:,:),res)
res@gsnLeftString="-10 days"
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K,1))+", C:"+sprintf(fmt,OLR_case_C3(5*K,1))
plot(1)=gsn_csm_contour_map(wks,OLR_case(5*K,1,:,:),res)
res@gsnLeftString="-5 days"
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K,2))+", C:"+sprintf(fmt,OLR_case_C3(5*K,2))
plot(2)=gsn_csm_contour_map(wks,OLR_case(5*K,2,:,:),res)
res@gsnLeftString="0 day"
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K,3))+", C:"+sprintf(fmt,OLR_case_C3(5*K,3))
plot(3)=gsn_csm_contour_map(wks,OLR_case(5*K,3,:,:),res)
res2@gsnCenterString=""
res2@gsnRightString=day(5*K)
plot(4)=gsn_csm_contour_map(wks,HGT_case(5*K,:,:),res2)
res@gsnLeftString=""
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+1,0))+", C:"+sprintf(fmt,OLR_case_C3(5*K+1,0))
plot(5)=gsn_csm_contour_map(wks,OLR_case(5*K+1,0,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+1,1))+", C:"+sprintf(fmt,OLR_case_C3(5*K+1,1))
plot(6)=gsn_csm_contour_map(wks,OLR_case(5*K+1,1,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+1,2))+", C:"+sprintf(fmt,OLR_case_C3(5*K+1,2))
plot(7)=gsn_csm_contour_map(wks,OLR_case(5*K+1,2,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+1,3))+", C:"+sprintf(fmt,OLR_case_C3(5*K+1,3))
plot(8)=gsn_csm_contour_map(wks,OLR_case(5*K+1,3,:,:),res)
res2@gsnRightString=day(5*K+1)
plot(9)=gsn_csm_contour_map(wks,HGT_case(5*K+1,:,:),res2)

res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+2,0))+", C:"+sprintf(fmt,OLR_case_C3(5*K+2,0))
plot(10)=gsn_csm_contour_map(wks,OLR_case(5*K+2,0,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+2,1))+", C:"+sprintf(fmt,OLR_case_C3(5*K+2,1))
plot(11)=gsn_csm_contour_map(wks,OLR_case(5*K+2,1,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+2,2))+", C:"+sprintf(fmt,OLR_case_C3(5*K+2,2))
plot(12)=gsn_csm_contour_map(wks,OLR_case(5*K+2,2,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+2,3))+", C:"+sprintf(fmt,OLR_case_C3(5*K+2,3))
plot(13)=gsn_csm_contour_map(wks,OLR_case(5*K+2,3,:,:),res)
res2@gsnRightString=day(5*K+2)
plot(14)=gsn_csm_contour_map(wks,HGT_case(5*K+2,:,:),res2)

res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+3,0))+", C:"+sprintf(fmt,OLR_case_C3(5*K+3,0))
plot(15)=gsn_csm_contour_map(wks,OLR_case(5*K+3,0,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+3,1))+", C:"+sprintf(fmt,OLR_case_C3(5*K+3,1))
plot(16)=gsn_csm_contour_map(wks,OLR_case(5*K+3,1,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+3,2))+", C:"+sprintf(fmt,OLR_case_C3(5*K+3,2))
plot(17)=gsn_csm_contour_map(wks,OLR_case(5*K+3,2,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+3,3))+", C:"+sprintf(fmt,OLR_case_C3(5*K+3,3))
plot(18)=gsn_csm_contour_map(wks,OLR_case(5*K+3,3,:,:),res)
res2@gsnRightString=day(5*K+3)
plot(19)=gsn_csm_contour_map(wks,HGT_case(5*K+3,:,:),res2)

res@lbLabelBarOn           =      True
res2@lbLabelBarOn           =      True
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+4,0))+", C:"+sprintf(fmt,OLR_case_C3(5*K+4,0))
plot(20)=gsn_csm_contour_map(wks,OLR_case(5*K+4,0,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+4,1))+", C:"+sprintf(fmt,OLR_case_C3(5*K+4,1))
plot(21)=gsn_csm_contour_map(wks,OLR_case(5*K+4,1,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+4,2))+", C:"+sprintf(fmt,OLR_case_C3(5*K+4,2))
plot(22)=gsn_csm_contour_map(wks,OLR_case(5*K+4,2,:,:),res)
res@gsnRightString="I:"+sprintf(fmt,OLR_case_I3(5*K+4,3))+", C:"+sprintf(fmt,OLR_case_C3(5*K+4,3))
plot(23)=gsn_csm_contour_map(wks,OLR_case(5*K+4,3,:,:),res)
res2@gsnRightString=day(5*K+4)
plot(24)=gsn_csm_contour_map(wks,HGT_case(5*K+4,:,:),res2)

;------------India-------------
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 2.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(20,graphic)
do i=0,4
dum2(4*i)=gsn_add_polyline(wks,plot(5*i),I_xpts,I_ypts,resp)
dum2(4*i+1)=gsn_add_polyline(wks,plot(5*i+1),I_xpts,I_ypts,resp)
dum2(4*i+2)=gsn_add_polyline(wks,plot(5*i+2),I_xpts,I_ypts,resp)
dum2(4*i+3)=gsn_add_polyline(wks,plot(5*i+3),I_xpts,I_ypts,resp)
end do
;-------------China--------------
dum3 = new(20,graphic)
 do I=0,4
  dum3(4*I)=gsn_add_polyline(wks,plot(5*I),C_xpts,C_ypts,resp)
  dum3(4*I+1)=gsn_add_polyline(wks,plot(5*I+1),C_xpts,C_ypts,resp)
  dum3(4*I+2)=gsn_add_polyline(wks,plot(5*I+2),C_xpts,C_ypts,resp)
  dum3(4*I+3)=gsn_add_polyline(wks,plot(5*I+3),C_xpts,C_ypts,resp)
 end do
;----- KOREA ------------
ypts = (/31,31, 43,43,31/)
xpts = (/117,137,137,117,117/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 2.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum4 = new(5,graphic)
 do I=0,4
  dum4(I)=gsn_add_polyline(wks,plot(5*I+4),xpts,ypts,resp)
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
res3@cnLineThicknessF=2
res3@cnMonoLevelFlag=True
res3@cnConstFLabelFontHeightF=0.005
res3@cnLineLabelsOn       = True
res4=res3
res4@cnLineColor="green" ; GREEN LINE
res5@cnFillOn            = False
res5@cnLinesOn              =True
res5@cnLineColor="gray40"
res5@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
res5@cnMinLevelValF       = -250.              ; set min contour level
res5@cnMaxLevelValF       =  250.              ; set max contour level
res5@cnLevelSpacingF      =  25.              ; set contour spacing
;res5@cnLineLabelInterval = 20
res5@cnLevelFlags=test2

res5@gsnContourZeroLineThicknessF = 2.  ; doubles thickness of zero contour
res5@gsnContourNegLineDashPattern = 1   ; sets negative contours to dash pattern 1
res5@cnLineThicknessF=1
res5@cnLineLabelsOn         =       True

 plot3(0)=gsn_csm_contour(wks,hgt_200_case(5*K,0,:,:),res5) ;Grey line
 plot3(1)=gsn_csm_contour(wks,hgt_200_case(5*K,1,:,:),res5)
 plot3(2)=gsn_csm_contour(wks,hgt_200_case(5*K,2,:,:),res5)
 plot3(3)=gsn_csm_contour(wks,hgt_200_case(5*K,3,:,:),res5)

 plot3(4)=gsn_csm_contour(wks,hgt_200_case(5*K+1,0,:,:),res5) ;Grey line
 plot3(5)=gsn_csm_contour(wks,hgt_200_case(5*K+1,1,:,:),res5)
 plot3(6)=gsn_csm_contour(wks,hgt_200_case(5*K+1,2,:,:),res5)
 plot3(7)=gsn_csm_contour(wks,hgt_200_case(5*K+1,3,:,:),res5)

 plot3(8)=gsn_csm_contour(wks,hgt_200_case(5*K+2,0,:,:),res5) ;Grey line
 plot3(9)=gsn_csm_contour(wks,hgt_200_case(5*K+2,1,:,:),res5)
 plot3(10)=gsn_csm_contour(wks,hgt_200_case(5*K+2,2,:,:),res5)
 plot3(11)=gsn_csm_contour(wks,hgt_200_case(5*K+2,3,:,:),res5)

 plot3(12)=gsn_csm_contour(wks,hgt_200_case(5*K+3,0,:,:),res5) ;Grey line
 plot3(13)=gsn_csm_contour(wks,hgt_200_case(5*K+3,1,:,:),res5)
 plot3(14)=gsn_csm_contour(wks,hgt_200_case(5*K+3,2,:,:),res5)
 plot3(15)=gsn_csm_contour(wks,hgt_200_case(5*K+3,3,:,:),res5)

 plot3(16)=gsn_csm_contour(wks,hgt_200_case(5*K+4,0,:,:),res5) ;Grey line
 plot3(17)=gsn_csm_contour(wks,hgt_200_case(5*K+4,1,:,:),res5)
 plot3(18)=gsn_csm_contour(wks,hgt_200_case(5*K+4,2,:,:),res5)
 plot3(19)=gsn_csm_contour(wks,hgt_200_case(5*K+4,3,:,:),res5)

 do i=0,4
 overlay(plot(5*i),plot3(4*i))
 overlay(plot(5*i+1),plot3(4*i+1))
 overlay(plot(5*i+2),plot3(4*i+2))
 overlay(plot(5*i+3),plot3(4*i+3))
 end do

plot2(0)=gsn_csm_contour(wks,HGT_abs_case(5*K,:,:),res4); Green line
plot2(1)=gsn_csm_contour(wks,HGT_abs_case(5*K+1,:,:),res4)
plot2(2)=gsn_csm_contour(wks,HGT_abs_case(5*K+2,:,:),res4)
plot2(3)=gsn_csm_contour(wks,HGT_abs_case(5*K+3,:,:),res4)
plot2(4)=gsn_csm_contour(wks,HGT_abs_case(5*K+4,:,:),res4)

plot1(0)=gsn_csm_contour(wks,HGT_clim(5*K,:,:),res3)
plot1(1)=gsn_csm_contour(wks,HGT_clim(5*K+1,:,:),res3)
plot1(2)=gsn_csm_contour(wks,HGT_clim(5*K+2,:,:),res3)
plot1(3)=gsn_csm_contour(wks,HGT_clim(5*K+3,:,:),res3)
plot1(4)=gsn_csm_contour(wks,HGT_clim(5*K+4,:,:),res3)

do J=0,4
  overlay(plot(5*J+4),plot1(J))
  overlay(plot(5*J+4),plot2(J))
 end do

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =      False
pres@gsnPanelYWhiteSpacePercent = 1
pres@gsnPanelXWhiteSpacePercent = 3
pres@lbLabelFontHeightF  = 0.015
pres@lbLabelStride     =   2
pres@gsnPanelLeft  =0.05
pres@pmLabelBarOrthogonalPosF=0.05
pres@pmLabelBarHeightF=0.08
pres@gsnPanelMainString        =   ""
pres@pmLabelBarWidthF=0.7
txres               = True                      ; text mods desired
txres@txFontHeightF = 0.012
;gsn_text_ndc(wks,"W/m~S~2~N~",0.51,0.07,txres)
txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.012
;txres1@txAngleF=90
gsn_text_ndc(wks,case(5*K),0.03,0.7,txres1)
gsn_text_ndc(wks,case(5*K+1),0.03,0.6,txres1)
gsn_text_ndc(wks,case(5*K+2),0.03,0.5,txres1)
gsn_text_ndc(wks,case(5*K+3),0.03,0.4,txres1)
gsn_text_ndc(wks,case(5*K+4),0.03,0.3,txres1)

txres1@txFontHeightF = 0.016
gsn_text_ndc(wks,"OLR",0.44,0.78,txres1)
gsn_text_ndc(wks,"H200",0.91,0.78,txres1)
gsn_panel(wks,plot,(/5,5/),pres)
frame(wks)
end do

end
