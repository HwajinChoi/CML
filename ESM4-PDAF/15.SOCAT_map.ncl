begin
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"

f=addfile(dir1+"pco2_SOCAT_2010-2021.nc","r")
p_co2=f->fco2_ave_weighted
co2=dim_avg_n_Wrap(p_co2,0)

plot1=new(1,graphic)
 wks=gsn_open_wks("png",dir2+"SOCAT_2010-2021")
 res                                            =       True
 res@gsnMaximize        =       True
 res@gsnFrame                           =       False
 res@gsnDraw                            =       False
 res@cnFillOn                           =       True
 res@cnInfoLabelOn                      =       False
 res@cnLinesOn                          =       False
 res@cnLineLabelsOn                     =       False
 res@lbLabelBarOn                       =          True
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
 res@lbLabelFontHeightF  = 0.010
 res@lbLabelStride             =       2
 res@mpCenterLonF               =               180
 res@mpLandFillColor    =       "black"
 res@cnLevelSelectionMode       =       "ManualLevels"
 res@cnMaxLevelValF                     =      460
 res@cnMinLevelValF                     =      260
 res@cnLevelSpacingF            =               10
 res@cnFillPalette                      =               "grads_rainbow"
 res@gsnCenterString            =       ""

 plot=gsn_csm_contour_map(wks,co2,res)

 txres1               = True
 txres1@txFontHeightF = 0.02
 txres1@txFuncCode    = ":"
 gsn_text_ndc(wks,":F8:m",0.478,0.168,txres1)
 gsn_text_ndc(wks,"(   atm)",0.5,0.17,txres1)

 draw(plot)
 frame(wks)

end
