begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"

dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"

h=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
lon=h->lon
lat=h->lat

f1=addfile(dir1+"CORR_chl_ODA_2015-2021.nc","r")
corr_oda=f1->corr
pval_oda=f1->pval
f2=addfile(dir1+"CORR_chl_AODA_2010-2021.nc","r")
corr_aoda=f2->corr
pval_aoda=f2->pval

b2 = addfile(file11,"r")
lsm_t85  = landsea_mask(b2->LSMASK,lat,lon)

ODA_corr1 = mask(corr_oda,lsm_t85.eq.1,False)
AODA_corr1 = mask(corr_aoda,lsm_t85.eq.1,False)

ODA_corr1 := where(ODA_corr1 .eq. "nan", -999,ODA_corr1)
AODA_corr1 := where(AODA_corr1 .eq. "nan", -999,AODA_corr1)
copy_VarCoords(corr_oda,ODA_corr1)
copy_VarCoords(corr_aoda,AODA_corr1)

replace_ieeenan(ODA_corr1,-999.,0)
replace_ieeenan(AODA_corr1,-999.,0)

ODA_corr1&lat=lat
ODA_corr1&lon=lon
AODA_corr1&lon=lon
AODA_corr1&lat=lat
ODA_corr1@_FillValue=-999
AODA_corr1@_FillValue=-999

pval_oda@_FillValue=-999
pval_aoda@_FillValue=-999
ODA_pval1 = mask(pval_oda,lsm_t85.eq.1,False)
AODA_pval1 = mask(pval_aoda,lsm_t85.eq.1,False)
copy_VarCoords(pval_oda,ODA_pval1)
copy_VarCoords(pval_aoda,AODA_pval1)
dim0=dimsizes(pval_oda)

S0=new((/dim0(0),dim0(1)/),"double")
copy_VarCoords(pval_oda,S0)
S1=new((/dim0(0),dim0(1)/),"double")
copy_VarCoords(pval_aoda,S1)
siglvl=0.05 ; 95%
S0=where(ODA_pval1 .le. siglvl,2,-1); significance of correlation
S1=where(AODA_pval1 .le. siglvl,2,-1); significance of correlation
S0&lat=lat
S0&lon=lon
S1&lat=lat
S1&lon=lon

plot=new(2,graphic)
 plot1=new(2,graphic)
 wks=gsn_open_wks("png",dir0+"Chl_seawifs_ODA_AODA_Corr_map")
 res                                            =       True
 res@gsnFrame                           =       False
 res@gsnDraw                            =       False
 res@cnFillOn                           =       True
 res@cnInfoLabelOn                      =       False
 res@cnLinesOn                          =       False
 res@cnLineLabelsOn                     =       False
 res@lbLabelBarOn                       =          False
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@lbLabelBarOn                       = False
 res@tmXBLabelFontHeightF       =       0.025
 res@tmYLLabelFontHeightF       =               0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 sres                                   =       res
 sres@mpPerimOn = False
 res@mpCenterLonF               =               180
 res@mpLandFillColor    =       "black"
 res@cnLevelSelectionMode       =       "ManualLevels"
 res@cnMaxLevelValF                     =      1.0
 res@cnMinLevelValF                     =      -1.0
 res@cnLevelSpacingF            =               0.1
 res@cnFillPalette                      =               "temp_19lev"

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
 sres@tiMainOn = False
 sres@gsnCenterString   = ""
 sres@lbLabelBarOn              =       False
 sres@cnFillDotSizeF=0.0025
 sres@cnConstFLabelOn=False
 sres@trGridType="TriangularMesh"

 res@gsnCenterString            =      "" 
 plot(0)=gsn_csm_contour_map(wks,ODA_corr1,res)
 plot1(0)=gsn_csm_contour(wks,S0,sres);ODA
 plot1(0)=ShadeGtContour(plot1(0),2,17)

 plot(1)=gsn_csm_contour_map(wks,AODA_corr1,res)
 plot1(1)=gsn_csm_contour(wks,S1,sres);AODA
 plot1(1)=ShadeGtContour(plot1(1),2,17)

 overlay(plot(0),plot1(0))
 overlay(plot(1),plot1(1))
 ypts = (/10,10, 35,35,10/)
 xpts = (/140,220,220,140,140/)
 resp                  = True                      ; polyline mods desired
 resp@gsLineColor      = "black"                     ; color of lines
 resp@gsLineThicknessF = 6.0                       ; thickness of lines
 resp@gsLineDashPattern= 0
 ;resp@tfPolyDrawOrder   =   "PostDraw"
 dum2 = new(2,graphic)
 dum2(0)=gsn_add_polyline(wks,plot(0),xpts,ypts,resp)
 dum2(1)=gsn_add_polyline(wks,plot(1),xpts,ypts,resp)

 ypts = (/-20,-20,0 ,0,-20/)
 xpts = (/160,210,210,160,160/)
 dum3 = new(2,graphic)
 dum3(0)=gsn_add_polyline(wks,plot(0),xpts,ypts,resp)
 dum3(1)=gsn_add_polyline(wks,plot(1),xpts,ypts,resp)

 pres                                           =       True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar          = True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.010
 pres@lbLabelStride             =       2
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.018
 pres@lbLabelStride     =   2
 pres@gsnPanelLeft  =0.05
 pres@gsnPanelBottom  =0.05
 pres@pmLabelBarOrthogonalPosF=0.
 pres@pmLabelBarWidthF=0.75
 pres@pmLabelBarHeightF=0.06
 pres@gsnPanelMainString = ""
 pres@gsnPanelMainFontHeightF=0.025
 pres@gsnPanelMainPosYF=0.96

 txres1               = True
 txres1@txFontHeightF = 0.020
 txres1@txAngleF=90
 gsn_text_ndc(wks,"ESM4-PDAF_ocean",0.08,0.8,txres1)
 gsn_text_ndc(wks,"(2015-2021)",0.11,0.79,txres1)
 gsn_text_ndc(wks,"ESM4-PDAF_coupled",0.08,0.35,txres1)
 gsn_text_ndc(wks,"(2010-2021)",0.11,0.34,txres1)

 gsn_panel(wks,plot,(/2,1/),pres)

 frame(wks)



end
