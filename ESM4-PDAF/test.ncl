begin

dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/co2/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

; tight time line => 2015-2017

f1=addfile(dir3+"dic_stf_gas.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
dic_ODA=f1->dic_stf_gas(0:71,:,:)
dic_ODA=dic_ODA*(-1)
dic_ODA1=dim_avg_n_Wrap(dic_ODA,0)

f2=addfile(dir4+"dic_stf_gas.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
dic_AODA=f2->dic_stf_gas(0:131,:,:);"mole/m^2/sec"
dic_AODA=dic_AODA*(-1)
dic_AODA1=dim_avg_n_Wrap(dic_AODA,0)

g1=addfile(dir1+"co2_flux_CSIR_ML6_201001-202012.nc","r")
dic_CSIR0=g1->fgco2 ; "mol/m2/s"
dic_CSIR1=dble2flt(dic_CSIR0)
dic_CSIR2=dim_avg_n_Wrap(dic_CSIR1,0)
dic_CSIR2@_FillValue=9.96921e+36
	

plot=new(2,graphic)

wks=gsn_open_wks("png",dir2+"test")
 res                                            =       True
 res@gsnFrame                           =       False
 res@gsnRightString=""
 res@gsnLeftString=""
 res@gsnDraw                            =       False
 res@cnFillOn                           =       True
 res@cnInfoLabelOn                      =       False
 res@cnLinesOn                          =       False
 res@cnLineLabelsOn                     =       False
 res@lbLabelBarOn                       =          False
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@lbLabelBarOn                       = True
 res@lbLabelFontHeightF  = 0.016
 res@lbLabelStride     =   2
 res@tmXBLabelFontHeightF       =       0.025
 res@tmYLLabelFontHeightF       =               0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF               =               180
 res@mpLandFillColor    =       "black"
 res@cnLevelSelectionMode       =       "ManualLevels"
 res@cnMaxLevelValF                     =     2e-07 
 res@cnMinLevelValF                     =      -2e-07
; res@cnLevelSpacingF            =               0.0005
 res@cnFillPalette                      =               "temp_19lev"
 res@gsnCenterString            =       "ESM4-PDAF_ocean"
 plot(0)=gsn_csm_contour_map(wks,dic_ODA1,res)
 res@gsnCenterString            =       "ESM4-PDAF_coupled"
 plot(1)=gsn_csm_contour_map(wks,dic_AODA1,res)

 pres                               =       True
 pres@gsnFrame         = False
 ;pres@gsnPanelLabelBar          = True
 pres@gsnPanelLabelBar          = False
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5
; pres@lbLabelFontHeightF  = 0.016
; pres@lbLabelStride     =   2
 pres@gsnPanelLeft  =0.05
 pres@gsnPanelBottom  =0.05
 pres@pmLabelBarOrthogonalPosF=0.
 gsn_panel(wks,plot,(/1,2/),pres)
 frame(wks)

end
