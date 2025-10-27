begin
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

f=addfile(dir1+"pco2_SOCAT_2010-2021.nc","r")
p_co2=f->fco2_ave_weighted
co2=dim_avg_n_Wrap(p_co2,0)

g1=addfile(dir3+"pco2surf.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
pco2_oda=g1->pco2surf
co2_oda=dim_avg_n_Wrap(pco2_oda,0)
g2=addfile(dir4+"pco2surf.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
pco2_aoda=g2->pco2surf
co2_aoda=dim_avg_n_Wrap(pco2_aoda,0)

plot1=new(3,graphic)
 wks=gsn_open_wks("png",dir2+"SOCAT_ODA_AODA_2010-2021")
 res                                            =       True
 res@gsnMaximize        =       True
 res@gsnFrame                           =       False
 res@gsnDraw                            =       False
 res@cnFillOn                           =       True
 res@cnInfoLabelOn                      =       False
 res@cnLinesOn                          =       False
 res@cnLineLabelsOn                     =       False
 res@lbLabelBarOn                       =          False
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@gsnRightString=""
 res@gsnLeftString=""
 res@tmXBLabelFontHeightF       =       0.025
 res@tmYLLabelFontHeightF       =               0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF               =               180
 res@mpLandFillColor    =       "black"
 res@cnLevelSelectionMode       =       "ManualLevels"
 res@cnMaxLevelValF                     =      450
 res@cnMinLevelValF                     =      260
 res@cnLevelSpacingF            =               10
 res@cnFillPalette                      =               "BlAqGrYeOrReVi200"
 res@gsnCenterString            =       ""

 plot1(0)=gsn_csm_contour_map(wks,co2,res)
 plot1(1)=gsn_csm_contour_map(wks,co2_oda,res)
 plot1(2)=gsn_csm_contour_map(wks,co2_aoda,res)

 ypts = (/10,10, 50,50,10/)
 xpts = (/140,250,250,140,140/)
 resp                  = True                      ; polyline mods desired
 resp@gsLineColor      = "black"                     ; color of lines
 resp@gsLineThicknessF = 6.0                       ; thickness of lines
 resp@gsLineDashPattern= 0
 ;resp@tfPolyDrawOrder   =   "PostDraw"
 dum2 = new(1,graphic)
 dum2(0)=gsn_add_polyline(wks,plot1(0),xpts,ypts,resp)

 ypts = (/10,10, 60,60,10/)
 xpts = (/300,350,350,300,300/)
 dum3 = new(1,graphic)
 dum3(0)=gsn_add_polyline(wks,plot1(0),xpts,ypts,resp)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@lbLabelStride             =       2
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 1
pres@gsnPanelMainString="pCO2"
pres@gsnPanelMainFontHeightF=0.023
pres@gsnPanelTop       = 0.9
pres@gsnPanelBottom       = 0.05
pres@gsnPanelLeft=0.05
pres@gsnPanelLabelBar    = True         ; add common colorbar
pres@lbLabelFontHeightF  = 0.012
pres@gsnPanelYWhiteSpacePercent = 7
pres@pmLabelBarWidthF=0.5

gsn_panel(wks,plot1,(/3,1/),pres)
txres1               = True
txres1@txFontHeightF = 0.014
txres1@txAngleF      = 90.
gsn_text_ndc(wks, "OBS (SOCAT)",0.25, 0.77, txres1)
gsn_text_ndc(wks, "ESM4-PDAF_ocean",0.25, 0.53, txres1)
gsn_text_ndc(wks, "ESM4-PDAF_coupled",0.255, 0.25, txres1)

 txres2               = True
 txres2@txFontHeightF = 0.015
 txres2@txFuncCode    = ":"
 gsn_text_ndc(wks,":F8:m",0.815,0.098,txres2)
 gsn_text_ndc(wks,"(   atm)",0.83,0.1,txres2)

 frame(wks)

end
