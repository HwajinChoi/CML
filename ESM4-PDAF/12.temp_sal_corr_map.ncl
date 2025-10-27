begin

file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"

dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"

h=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
lon=h->lon
lat=h->lat

f1=addfile(dir1+"CORR_temp_surf_EN4_AODA_2010-2021.nc","r")
corr_temp_surf_AODA=f1->corr
pval_temp_surf_AODA=f1->pval
f2=addfile(dir1+"CORR_temp_surf_EN4_ODA_2015-2021.nc","r")
corr_temp_surf_ODA=f2->corr
pval_temp_surf_ODA=f2->pval
f3=addfile(dir1+"CORR_temp_sub_EN4_AODA_2010-2021.nc","r")
corr_temp_sub_AODA=f3->corr
pval_temp_sub_AODA=f3->pval
f4=addfile(dir1+"CORR_temp_sub_EN4_ODA_2015-2021.nc","r")
corr_temp_sub_ODA=f4->corr
pval_temp_sub_ODA=f4->pval

g1=addfile(dir1+"CORR_so_surf_EN4_AODA_2010-2021.nc","r")
corr_so_surf_AODA=g1->corr
pval_so_surf_AODA=g1->pval
g2=addfile(dir1+"CORR_so_sub_EN4_AODA_2010-2021.nc","r")
corr_so_sub_AODA=g2->corr
pval_so_sub_AODA=g2->pval
g3=addfile(dir1+"CORR_so_surf_EN4_ODA_2015-2021.nc","r")
corr_so_surf_ODA=g3->corr
pval_so_surf_ODA=g3->pval
g4=addfile(dir1+"CORR_so_sub_EN4_ODA_2015-2021.nc","r")
corr_so_sub_ODA=g4->corr
pval_so_sub_ODA=g4->pval

ODA_corr=new((/4,180,360/),"double")
ODA_corr(0,:,:)=corr_temp_surf_ODA
ODA_corr(1,:,:)=corr_so_surf_ODA
ODA_corr(2,:,:)=corr_temp_sub_ODA
ODA_corr(3,:,:)=corr_so_sub_ODA
ODA_corr!0="data"

AODA_corr=new((/4,180,360/),"double")
AODA_corr(0,:,:)=corr_temp_surf_AODA
AODA_corr(1,:,:)=corr_so_surf_AODA
AODA_corr(2,:,:)=corr_temp_sub_AODA
AODA_corr(3,:,:)=corr_so_sub_AODA
AODA_corr!0="data"

ODA_pval=new((/4,180,360/),"double")
ODA_pval(0,:,:)=pval_temp_surf_ODA
ODA_pval(1,:,:)=pval_so_surf_ODA
ODA_pval(2,:,:)=pval_temp_sub_ODA
ODA_pval(3,:,:)=pval_so_sub_ODA
ODA_pval!0="data"

AODA_pval=new((/4,180,360/),"double")
AODA_pval(0,:,:)=pval_temp_surf_AODA
AODA_pval(1,:,:)=pval_so_surf_AODA
AODA_pval(2,:,:)=pval_temp_sub_AODA
AODA_pval(3,:,:)=pval_so_sub_AODA
AODA_pval!0="data"

b2 = addfile(file11,"r")
lsm_t85  = landsea_mask(b2->LSMASK,lat,lon)

ODA_corr1 = mask(ODA_corr,lsm_t85.eq.1,False)
AODA_corr1 = mask(AODA_corr,lsm_t85.eq.1,False)

ODA_corr1 := where(ODA_corr1 .eq. "nan", -999,ODA_corr1)
AODA_corr1 := where(AODA_corr1 .eq. "nan", -999,AODA_corr1)
copy_VarCoords(ODA_corr,ODA_corr1)
copy_VarCoords(AODA_corr,AODA_corr1)

replace_ieeenan(ODA_corr1,-999.,0)
replace_ieeenan(AODA_corr1,-999.,0)

ODA_corr1&lat=lat
ODA_corr1&lon=lon
AODA_corr1&lon=lon
AODA_corr1&lat=lat
ODA_corr1@_FillValue=-999
AODA_corr1@_FillValue=-999

ODA_pval@_FillValue=-999
AODA_pval@_FillValue=-999
ODA_pval1 = mask(ODA_pval,lsm_t85.eq.1,False)
AODA_pval1 = mask(AODA_pval,lsm_t85.eq.1,False)
copy_VarCoords(ODA_pval,ODA_pval1)
copy_VarCoords(AODA_pval,AODA_pval1)
dim0=dimsizes(ODA_pval)

S0=new((/dim0(0),dim0(1),dim0(2)/),"double")
copy_VarCoords(ODA_pval,S0)
S1=new((/dim0(0),dim0(1),dim0(2)/),"double")
copy_VarCoords(AODA_pval,S1)
siglvl=0.05 ; 95%
S0=where(ODA_pval1 .le. siglvl,2,-1); significance of correlation
S1=where(AODA_pval1 .le. siglvl,2,-1); significance of correlation
S0&lat=lat
S0&lon=lon
S1&lat=lat
S1&lon=lon


 plot=new(8,graphic)
 plot1=new(8,graphic)
 wks=gsn_open_wks("eps",dir0+"Temp_So_EN4_ODA_AODA_Corr_map")
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

 res@gsnCenterString            =       "Temperature surface"
 plot(0)=gsn_csm_contour_map(wks,ODA_corr1(0,:,:),res)
 plot1(0)=gsn_csm_contour(wks,S0(0,:,:),sres);ODA
 plot1(0)=ShadeGtContour(plot1(0),2,17)
 plot(2)=gsn_csm_contour_map(wks,AODA_corr1(0,:,:),res)
 plot1(2)=gsn_csm_contour(wks,S1(0,:,:),sres);AODA
 plot1(2)=ShadeGtContour(plot1(2),2,17)

 res@gsnCenterString            =       "Salinity surface"
 plot(1)=gsn_csm_contour_map(wks,ODA_corr1(1,:,:),res)
 plot1(1)=gsn_csm_contour(wks,S0(1,:,:),sres);ODA
 plot1(1)=ShadeGtContour(plot1(1),2,17)
 plot(3)=gsn_csm_contour_map(wks,AODA_corr1(1,:,:),res)
 plot1(3)=gsn_csm_contour(wks,S1(1,:,:),sres);AODA
 plot1(3)=ShadeGtContour(plot1(3),2,17)

 res@gsnCenterString            =       "Temperature 0-300m"
 plot(4)=gsn_csm_contour_map(wks,ODA_corr1(2,:,:),res)
 plot1(4)=gsn_csm_contour(wks,S0(2,:,:),sres);ODA
 plot1(4)=ShadeGtContour(plot1(4),2,17)
 plot(6)=gsn_csm_contour_map(wks,AODA_corr1(2,:,:),res)
 plot1(6)=gsn_csm_contour(wks,S1(2,:,:),sres);AODA
 plot1(6)=ShadeGtContour(plot1(6),2,17)

 res@gsnCenterString            =       "Salinity 0-300m"
 plot(5)=gsn_csm_contour_map(wks,ODA_corr1(3,:,:),res)
 plot1(5)=gsn_csm_contour(wks,S0(3,:,:),sres);ODA
 plot1(5)=ShadeGtContour(plot1(5),2,17)
 plot(7)=gsn_csm_contour_map(wks,AODA_corr1(3,:,:),res)
 plot1(7)=gsn_csm_contour(wks,S1(3,:,:),sres);AODA
 plot1(7)=ShadeGtContour(plot1(7),2,17)

 do j=0,7
 overlay(plot(j),plot1(j))
 end do

 pres                                           =       True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar          = True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.016
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
 txres1@txFontHeightF = 0.018
 gsn_text_ndc(wks,"ESM4-PDAF_ocean (2015-2021)",0.285,0.75,txres1)
 gsn_text_ndc(wks,"ESM4-PDAF_coupled (2010-2021)",0.755,0.75,txres1)

 gsn_panel(wks,plot,(/2,4/),pres)
 frame(wks)

end
