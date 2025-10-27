begin
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/co2/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

; tight time line => 2015-2017

f1=addfile(dir3+"dic_stf_gas.mon.ESM4-PDAF_ODA.weights.2015-2021.1x1.nc","r")
dic_ODA=f1->dic_stf_gas(0:71,:,:)
dic_ODA=dic_ODA*(-1)

f2=addfile(dir4+"dic_stf_gas.mon.ESM4-PDAF_AODA.weights.2010-2021.1x1.nc","r")
dic_AODA=f2->dic_stf_gas(0:131,:,:);"mole/m^2/sec"
lon_aoda0=f2->lon
lon_aoda=dble2flt(lon_aoda0)
lat_aoda0=f2->lat
lat_aoda=dble2flt(lat_aoda0)
dic_AODA@_FillValue=-9e+33
dic_AODA=dic_AODA*(-1)

g1=addfile(dir1+"co2_flux_CSIR_ML6_weights_201001-202012.nc","r")
dic_CSIR0=g1->fgco2 ; "mol/m2/s"
dic_CSIR=dble2flt(dic_CSIR0)
dic_CSIR@_FillValue=-9e+33

g2=addfile(dir1+"CO2_flux_ECCO-Darwin_v05_r360x180_weighted_199501-201712.nc","r")
dic_Darwin0=g2->CO2_flux(180:275,:,:) ;1995-2017
dic_Darwin=where(dic_Darwin0 .eq. 0,-999,dic_Darwin0)
copy_VarMeta(dic_Darwin0,dic_Darwin)
dic_Darwin@_FillValue=-999 ; "mol C m^-2 s^-1"

g3=addfile(dir1+"co2_flux_JMA_v2020_weights_201001-202012.nc","r")
dic_JMA=g3->flux ; "mol/m2/yr"
dic_JMA@_FillValue=-9e+33

g4=addfile(dir1+"co2_flux_Jena-MLS_v2022_201001-202012.nc","r")
dic_Jena=g4->co2flux_ocean ; "PgC/yr"
dic_Jena1=dim_avg_n_Wrap(dic_Jena,0)
dic_Jena2=where(dic_Jena1 .eq. 0,-999,dic_Jena1)
copy_VarMeta(dic_Jena1,dic_Jena2)
dic_Jena2@_FillValue=-999

g5=addfile(dir1+"co2_flux_LDEO-HPD_v2021_weights_201001-201812.nc","r")
dic_LDEO0=g5->fgco2 ; "mol/m2/s"
dic_LDEO=dble2flt(dic_LDEO0)
dic_LDEO@_FillValue=-9e+33

g6=addfile(dir1+"co2_flux_MPI_SOM_FFN_v2022_weights_201001-202012.nc","r")
dic_MPI=g6->fgco2_smoothed ; "mol/m2/yr" ;
dic_MPI@_FillValue=-9e+33

;--------Unit Change => "PgC/yr" --------------
c_molar=44.01 ; g/mol
ocean_are=3.61*(10^8);km2
;--------------------------------------------
dic_CSIR=(dic_CSIR*60*60*24*365*c_molar)/(10^(15))
dic_CSIR@unit="PgC/yr"
dic_CSIR1=dim_avg_n_Wrap(dic_CSIR,0)
printMinMax(dic_CSIR1,0)
;--------------------------------------------
dic_Darwin=(dic_Darwin*60*60*24*365*c_molar)/(10^(15))
dic_Darwin@unit="PgC/yr"
dic_Darwin1=dim_avg_n_Wrap(dic_Darwin,0)
dic_Darwin1=(dic_Darwin1)/1000
printMinMax(dic_Darwin1,0)
;--------------------------------------------
dic_JMA = (dic_JMA*c_molar)/(10^(15))
dic_JMA@unit="PgC/yr"
dic_JMA1=dim_avg_n_Wrap(dic_JMA,0)
dic_JMA1&lon=lon_aoda
dic_JMA1&lat=lat_aoda
printMinMax(dic_JMA1,0)
;------------------------------------------------
dic_ODA = (dic_ODA*60*60*24*365*c_molar)/(10^(15))   ; yr and mass 
dic_ODA@unit="PgC/yr"
dic_ODA1=dim_avg_n_Wrap(dic_ODA,0)
printMinMax(dic_ODA1,0)
;------------------------------------------------
dic_AODA = (dic_AODA*60*60*24*365*c_molar)/(10^(15))   ; yr and mass 
dic_AODA@unit="PgC/yr"
dic_AODA1=dim_avg_n_Wrap(dic_AODA,0)
printMinMax(dic_AODA1,0)
;------------------------------------------------
dic_LDEO=(dic_LDEO*60*60*24*365*c_molar)/(10^(15)) 
dic_LDEO@unit="PgC/yr"
dic_LDEO1=dim_avg_n_Wrap(dic_LDEO,0)
printMinMax(dic_LDEO1,0)
;------------------------------------------------
dic_MPI=(dic_MPI*c_molar)/(10^(15))
dic_MPI@unit="PgC/yr"
dic_MPI1=dim_avg_n_Wrap(dic_MPI,0)
printMinMax(dic_MPI1,0)
;exit
printMinMax(dic_Jena,0)
;exit
;dic_JMA1=dic_JMA1*5
;dic_ODA1=dic_ODA1*5
;dic_AODA1=dic_AODA1*5
;dic_LDEO1=dic_LDEO1*5
;dic_MPI1=dic_MPI1*5
;dic_Darwin1=dic_Darwin1*5
;dic_CSIR1=dic_CSIR1*5

plot=new(8,graphic)
 plot1=new(8,graphic)
 wks=gsn_open_wks("png",dir2+"CO2_flux_PDAFs_six_reanalysis")
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
 res@cnMaxLevelValF                     =      0.003
 res@cnMinLevelValF                     =      -0.003
 res@cnLevelSpacingF            =               0.0005
 res@cnFillPalette                      =               "temp_19lev"
 res@gsnCenterString            =       "ESM4-PDAF_ocean"
 plot(0)=gsn_csm_contour_map(wks,dic_ODA1,res)
;delete([/res@cnLevelSelectionMode,res@cnMaxLevelValF,res@cnMinLevelValF,res@cnLevelSpacingF/])
 res@gsnCenterString            =       "ESM4-PDAF_coupled"
 plot(1)=gsn_csm_contour_map(wks,dic_AODA1,res)
 res@cnLevelSelectionMode       =       "ManualLevels"
 res@cnMaxLevelValF                     =      0.003
 res@cnMinLevelValF                     =      -0.003
 res@cnLevelSpacingF            =               0.0005
 res@gsnCenterString            =       "CSIR_ML6"
 plot(2)=gsn_csm_contour_map(wks,dic_CSIR1,res)
 res@gsnCenterString            =       "ECCO-Darwin"
 plot(3)=gsn_csm_contour_map(wks,dic_Darwin1,res)
 res@gsnCenterString            =       "JMA"
 plot(4)=gsn_csm_contour_map(wks,dic_JMA1,res)
 res@gsnCenterString            =       "Jena-MLS"
 plot(5)=gsn_csm_contour_map(wks,dic_Jena2,res)
 res@gsnCenterString            =       "LDEO-HPD"
 plot(6)=gsn_csm_contour_map(wks,dic_LDEO1,res)
 res@gsnCenterString            =       "MPI_SOM_FFN"
 plot(7)=gsn_csm_contour_map(wks,dic_MPI1,res)

 pres                                           =       True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar          = True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.014
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
 txres1@txFontHeightF = 0.012
 gsn_text_ndc(wks,"(PgC / yr)",0.95,0.365,txres1)


 gsn_panel(wks,plot,(/2,4/),pres)
 frame(wks)

end
