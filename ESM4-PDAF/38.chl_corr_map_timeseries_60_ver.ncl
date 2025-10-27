begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"

dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"

;--------- North Pacific -------
np_lat_1=10
np_lat_2=35
np_lon_1=140
np_lon_2=220
;----------- Equatorial Pacific ----
sp_lat_1=-20
sp_lat_2=5
sp_lon_1=160
;--- version 2
sp_lon_2=220 ; version 2
;----------------------------------------
g=addfile(dir3+"CHL_masking_60_80_lonflip_percent_201501-202112.nc","r")
chl_60=g->chl_60
chl_lon=g->lon
chl_lat=g->lat
chl_80=g->chl_80
;----------------------------------------
f1=addfile(dir3+"chl_satellite_2_3moving_ano_2010-2021.nc","r")
sat_np=f1->chl_sa_mv3(:,{np_lat_1:np_lat_2},{np_lon_1:np_lon_2})
sat_sp=f1->chl_sa_mv3(:,{sp_lat_1:sp_lat_2},{sp_lon_1:sp_lon_2})

f2=addfile(dir3+"chl_ODA_3moving_ano_2015-2021.nc","r")
oda_np=f2->chl_oda_mv3(:,{np_lat_1:np_lat_2},{np_lon_1:np_lon_2})
oda_sp=f2->chl_oda_mv3(:,{sp_lat_1:sp_lat_2},{sp_lon_1:sp_lon_2})
oda_np=oda_np*10^6
oda_sp=oda_sp*10^6
np_lat=f2->lat({np_lat_1:np_lat_2})
sp_lat=f2->lat({sp_lat_1:sp_lat_2})
;-------------------------------------------------------------------
rad    = 4.0*atan(1.0)/180.0
clat_np   = cos(np_lat*rad)
clat_sp   = cos(sp_lat*rad)

sat_np_area = wgt_areaave_Wrap(sat_np, clat_np, 1.0, 1)
oda_np_area = wgt_areaave_Wrap(oda_np, clat_np, 1.0, 1)

sat_sp_area = wgt_areaave_Wrap(sat_sp, clat_sp, 1.0, 1)
oda_sp_area = wgt_areaave_Wrap(oda_sp, clat_sp, 1.0, 1)

NP_ODA=new((/2,82/),"float")
NP_ODA(0,:)=sat_np_area(60:141)
NP_ODA(1,:)=oda_np_area
NP_ODA!0="data"

SP_ODA=new((/2,82/),"float")
SP_ODA(0,:)=sat_sp_area(60:141)
SP_ODA(1,:)=oda_sp_area
SP_ODA!0="data"

np_corr=escorc(NP_ODA(0,:),NP_ODA(1,:))
sp_corr=escorc(SP_ODA(0,:),SP_ODA(1,:))
print(np_corr)
print(sp_corr)
;exit
;system("rm -f "+dir3+"NP_SP_for_V5_corr_201501-202112.nc")
;out=addfile(    dir3+"NP_SP_for_V5_corr_201501-202112.nc","c")
;out->NP_ODA=NP_ODA
;out->SP_ODA=SP_ODA
;exit

y=ispan(1,142,1)
y2=ispan(1,82,1)

;---------------------------------------------------------------------
h=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
lon=h->lon
lat=h->lat

f3=addfile(dir1+"CORR_chl_ODA_2015-2021.nc","r")
corr_oda=f3->corr
pval_oda=f3->pval

b2 = addfile(file11,"r")
lsm_t85  = landsea_mask(b2->LSMASK,lat,lon)

ODA_corr1 = mask(corr_oda,lsm_t85.eq.1,False)
CHL_60 = mask(chl_60,lsm_t85.eq.1,False)
CHL_80 = mask(chl_80,lsm_t85.eq.1,False)
ODA_corr1 := where(ODA_corr1 .eq. "nan", -999,ODA_corr1)
copy_VarCoords(corr_oda,ODA_corr1)
copy_VarCoords(chl_60,CHL_60)
copy_VarCoords(chl_80,CHL_80)
replace_ieeenan(ODA_corr1,-999.,0)
ODA_corr1&lat=lat
ODA_corr1&lon=lon
ODA_corr1@_FillValue=-999
CHL_60@lat=chl_lat
CHL_60@lon=chl_lon
CHL_80@lat=chl_lat
CHL_80@lon=chl_lon

pval_oda@_FillValue=-999
ODA_pval1 = mask(pval_oda,lsm_t85.eq.1,False)
copy_VarCoords(pval_oda,ODA_pval1)
dim0=dimsizes(pval_oda)

S0=new((/dim0(0),dim0(1)/),"double")
copy_VarCoords(pval_oda,S0)
siglvl=0.05 ; 95%
S0=where(ODA_pval1 .le. siglvl,2,-1); significance of correlation
S0&lat=lat
S0&lon=lon

plot=new(1,graphic);map
plot1=new(1,graphic);sig
plot3=new(1,graphic);missing value
plot2=new(2,graphic);timeseries
 wks=gsn_open_wks("pdf",dir0+"figure13_Chl_seawifs_ODA_Corr_map_timeseries_missing_60_final")
 res                                            =       True
 res@gsnFrame                           =       False
 res@gsnDraw                            =       False
 res@cnFillOn                           =       True
 res@cnInfoLabelOn                      =       False
 res@cnLinesOn                          =       False
 res@cnLineLabelsOn                     =       False
 res@gsnCenterStringFontHeightF= 0.016
 ;res@gsnCenterStringOrthogonalPosF=0.1
 res@lbLabelBarOn                       = False
 res@tmXBLabelFontHeightF       =       0.025
 res@tmYLLabelFontHeightF       =               0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res3					=	res
 res3@cnConstFEnableFill        =       True
 res3@cnMonoFillColor   =       True
 res3@gsnCenterString=""
 res3@gsnRightString=""
 res3@gsnLeftString=""
 res3@mpPerimOn = False
 sres                                   =       res
 sres@mpPerimOn = False
 res@mpCenterLonF               =               180
 res@mpLandFillColor    =       "black"
 res3@mpLandFillColor    =       "black"
 sres@mpLandFillColor    =       "black"
 res@cnLevelSelectionMode       =       "ManualLevels"
 res@cnMaxLevelValF                     =      1.0
 res@cnMinLevelValF                     =      -1.0
 res@cnLevelSpacingF            =               0.1
 res@cnFillPalette                      =               "temp_19lev"
 res3@cnLevelSelectionMode = "ExplicitLevels"
 res3@cnLevels = (/0.,3/)
 res3@cnLinesOn                         =       False
 res3@cnMonoFillPattern=True
 res3@cnFillPattern="SolidFill"
 res3@cnFillColor               =       "gray"
 res3@cnFillOn                          =       True
 res3@cnLinesOn                         =       False
 sres@cnConstFEnableFill        =       True
 sres@cnMonoFillColor   =       True
 sres@cnFillColor               =       "black"
 sres@cnFillOn                          =       True
 sres@cnMonoFillPattern =       True
 sres@cnFillScaleF              =       1
 sres@cnFillPattern             =       17
 sres@cnLinesOn                         =       False
 sres@cnLevelSelectionMode = "ExplicitLevels"
 sres@cnLevels = (/0.,3/)
 sres@cnInfoLabelOn = False
 res3@cnInfoLabelOn = False
 res3@cnConstFLabelString = ""
 res3@cnConstFLabelFontHeightF = 0.0
 ;res3@tfPolyDrawOrder="PostDraw"
 sres@tiMainOn = False
 sres@gsnCenterString   = ""
 sres@lbLabelBarOn              =       False
 sres@cnFillDotSizeF=0.0025
 sres@cnConstFLabelOn=False
 sres@trGridType="TriangularMesh"
 res@gsnCenterString            =      "(a) Corr | Chlorophyll~B~sfc~N~" 
 plot(0)=gsn_csm_contour_map(wks,ODA_corr1,res)
 plot1(0)=gsn_csm_contour(wks,S0,sres);ODA
 plot3(0)=gsn_csm_contour(wks,CHL_60,res3)
 plot1(0)=ShadeGtContour(plot1(0),2,17)

 overlay(plot(0),plot3(0))
 overlay(plot(0),plot1(0))
 ypts = (/np_lat_1,np_lat_1, np_lat_2,np_lat_2,np_lat_1/)
 xpts = (/np_lon_1,np_lon_2,np_lon_2,np_lon_1,np_lon_1/)
 resp                  = True                      ; polyline mods desired
 resp@gsLineColor      = "black"                     ; color of lines
 resp@gsLineThicknessF = 4.0                       ; thickness of lines
 resp@gsLineDashPattern= 0
 ;resp@tfPolyDrawOrder   =   "PostDraw"
 dum2 = new(1,graphic)
 dum2(0)=gsn_add_polyline(wks,plot(0),xpts,ypts,resp)

 ypts = (/sp_lat_1,sp_lat_1, sp_lat_2,sp_lat_2,sp_lat_1/)
 xpts = (/sp_lon_1,sp_lon_2,sp_lon_2,sp_lon_1,sp_lon_1/)
 dum3 = new(1,graphic)
 dum3(0)=gsn_add_polyline(wks,plot(0),xpts,ypts,resp)
;-----------------------------------------------
res2                        =   True
res2@gsnFrame               =       False
res2@gsnDraw                =       False
res2@gsnMaximize=False
;res2@tmYLMode="Manual"
;res2@tmYLTickStartF=0
;res2@tmYLTickSpacingF=50
;res2@tmYLMinorPerMajor=3
res2@vpHeightF=0.5
res2@vpWidthF=0.8
res2@gsnYRefLine=0
res2@gsnYRefLineDashPattern=0
res2@gsnYRefLineThicknessF=2
res2@gsnYRefLineColor=(/"black"/)
res2@gsnLeftString=""
res2@gsnRightString=""
res2@tiXAxisString ="Time"
res2@tiXAxisFontHeightF=0.03
res2@tiYAxisFontHeightF=0.03
res2@tiYAxisString ="chl (mg / m~S~3~N~)"
res2@tiMainString=""
res2@tmXBMode="Explicit"
res2@xyMarkLineMode = "MarkLines"
res2@xyMarkers      = (/4,16/)               ; 3 different markers
res2@xyMarkerColors := (/"black","green"/) ; 3 different colors
res2@tmXBLabelFontHeightF=0.03
res2@tmYLLabelFontHeightF=0.03
res2@xyLineThicknesses    = (/3,3/)
res2@xyMarkerThicknesses= (/3,3/)
res2@xyDashPatterns=(/0,0/)
res2@xyLineColors=(/"black","green"/)
res2@gsnCenterStringFontHeightF=0.032
res2@gsnCenterString="(b) Chlorophyll~B~sfc~N~ (North Pacific)"
res2@trXMinF  = 0
res2@trXMaxF=83
res2@tmXBValues=(/0,24,48,72/)
res2@tmXBLabels=(/2015,2017,2019,2021/)
plot2(0)=gsn_csm_xy(wks,y2,NP_ODA,res2)
res2@gsnCenterString="(c) Chlorophyll~B~sfc~N~ (Equatorial Pacific)"
plot2(1)=gsn_csm_xy(wks,y2,SP_ODA,res2)

gres = True
gres@YPosPercent = 95  
gres@XPosPercent = 72 
gres@ItemSpacePercent = 8.
lineres = True
lineres@lgLineColors = (/"black","green"/)
lineres@lgLineThicknesses = 5                        ; line thicknesses
lineres@LineLengthPercent = 5.
textres = True
textres@lgLabelFontHeights = (/0.020,0.020/)
textres@lgLabels = (/"Satellite","ESM4-PDAF"/)
plot2(0) = simple_legend(wks,plot2(0),gres,lineres,textres)
gres@XPosPercent = 5  
plot2(1) = simple_legend(wks,plot2(1),gres,lineres,textres)


 pres                                           =       True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar          = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.008
 pres@lbLabelStride             =       2
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.012
 pres@lbLabelStride     =   2
 pres@gsnPanelLeft  =0.15
 pres@gsnPanelBottom  =0.65
 pres@pmLabelBarOrthogonalPosF=0.
 pres@pmLabelBarWidthF=0.06
 pres@pmLabelBarHeightF=0.3
 pres@gsnPanelMainString = ""
 pres@lbOrientation        = "vertical"

 pres2                                           =       True
 pres2@gsnFrame         = False
 pres2@gsnMaximize        =       False
 pres2@gsnPanelXWhiteSpacePercent = 5
; pres2@gsnPanelLeft  =0.05
 pres2@gsnPanelTop  =0.9
 pres2@gsnPanelMainString = ""

 gsn_panel(wks,plot,(/1,1/),pres)
 gsn_panel(wks,plot2,(/1,2/),pres2)

 txres1               = True
 txres1@txFontHeightF = 0.011
 gsn_text_ndc(wks,"corr = 0.73*",0.41,0.515,txres1)
 gsn_text_ndc(wks,"corr = 0.59*",0.675,0.515,txres1)

 frame(wks)

end
