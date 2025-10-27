begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/EN4/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

f1=addfile(dir1+"EN.4.2.2.r360x180.temperature_201001-202112.nc","r")
en4_temp0=f1->temperature(:,{0:650},:,:)
depth_en4=f1->depth({0:650})

en4_temp0_15=f1->temperature(60:143,{0:650},:,:)

en4_temp1=dim_avg_n_Wrap(en4_temp0,3)
en4_temp2=dim_avg_n_Wrap(en4_temp1,0) ; depth x lat

en4_temp1_15=dim_avg_n_Wrap(en4_temp0_15,3)
en4_temp2_15=dim_avg_n_Wrap(en4_temp1_15,0) ; depth x lat

en4_temp2 := en4_temp2(lat|:,depth|:)
en4_temp2_15 := en4_temp2_15(lat|:,depth|:)

f2=addfile(dir1+"EN.4.2.2.r360x180.salinity_201001-202112.nc","r")
en4_sal0=f2->salinity(:,{0:650},:,:)
en4_sal0_15=f2->salinity(60:143,{0:650},:,:)

en4_sal1=dim_avg_n_Wrap(en4_sal0,3)
en4_sal2=dim_avg_n_Wrap(en4_sal1,0)

en4_sal1_15=dim_avg_n_Wrap(en4_sal0_15,3)
en4_sal2_15=dim_avg_n_Wrap(en4_sal1_15,0)

en4_sal2 := en4_sal2(lat|:,depth|:)
en4_sal2_15 := en4_sal2_15(lat|:,depth|:)

g1=addfile(dir2+"thetao.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
thetao_oda0=g1->thetao(:,{0:650},:,:)
z=g1->z_l({0:650})
lat=g1->lat
thetao_oda1=dim_avg_n_Wrap(thetao_oda0,3)
thetao_oda2=dim_avg_n_Wrap(thetao_oda1,0)

h1=addfile(dir3+"thetao.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
thetao_aoda0=h1->thetao(:,{0:650},:,:)
thetao_aoda1=dim_avg_n_Wrap(thetao_aoda0,3)
thetao_aoda2=dim_avg_n_Wrap(thetao_aoda1,0)

g2=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
so_oda0=g2->so(:,{0:650},:,:)
so_oda1=dim_avg_n_Wrap(so_oda0,3)
so_oda2=dim_avg_n_Wrap(so_oda1,0)

h2=addfile(dir3+"so.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
so_aoda0=h2->so(:,{0:650},:,:)
so_aoda1=dim_avg_n_Wrap(so_aoda0,3)
so_aoda2=dim_avg_n_Wrap(so_aoda1,0)
;-----For depth interporation-------------
en4_temp3=int2p_n_Wrap(depth_en4,en4_temp2,z,-1,1)
en4_temp3_15=int2p_n_Wrap(depth_en4,en4_temp2_15,z,-1,1)

en4_sal3=int2p_n_Wrap(depth_en4,en4_sal2,z,-1,1)
en4_sal3_15=int2p_n_Wrap(depth_en4,en4_sal2_15,z,-1,1)

en4_temp3 := en4_temp3(z_l|:,lat|:)
en4_temp3_15 := en4_temp3_15(z_l|:,lat|:)

en4_sal3 := en4_sal3(z_l|:,lat|:)
en4_sal3_15 := en4_sal3_15(z_l|:,lat|:)
;--------------------------------------
diff_thetao_oda=thetao_oda2-en4_temp3_15
copy_VarCoords(thetao_oda2,diff_thetao_oda)

diff_thetao_aoda=thetao_aoda2-en4_temp3
copy_VarCoords(thetao_aoda2,diff_thetao_aoda)

diff_so_oda=so_oda2-en4_sal3_15
copy_VarCoords(so_oda2,diff_so_oda)

diff_so_aoda=so_aoda2-en4_sal3
copy_VarCoords(so_aoda2,diff_so_aoda)

plot=new(6,graphic)
wks=gsn_open_wks("png",dir0+"EN4_PDAFs_Vertical_Zonal_global_map_temp_sau_2010-2021")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn              =       False
res@cnLineLabelsOn         =       False
res@lbLabelBarOn           = True
res@lbLabelFontHeightF  = 0.018
res@lbLabelStride     =   2   
;res@pmLabelBarWidthF=0.6
;res@pmLabelBarHeightF=0.5
res@lbTitleOn        =  False                ; turn on title
res@vpHeightF          = 0.4               ; change aspect ratio of plot
res@vpWidthF           = 0.6
res@lbTitleString    = "~S~o~N~C"                ; title string
res@lbTitlePosition  = "Bottom"              ; title position
res@lbOrientation        = "vertical" ; vertical label bar
res@tmYLMode="Manual"
res@tmYLTickStartF=0
res@tmYLTickSpacingF=100
res@tmYLMinorPerMajor=1
res@gsnCenterStringFontHeightF=0.025
res@lbTitleFontHeightF= 0.020     
res@sfXArray             = lat
res@sfYArray		 = z
res@gsnYAxisIrregular2Linear = True
res@trYReverse               = True   ; reverses y-axis
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       1   
res@tmYLLabelStride     =       2   
;res@gsnCenterStringOrthogonalPosF=0.1
;res@cnMaxLevelValF         =      0.4 
;res@cnMinLevelValF         =      -0.4
;res@cnLevelSpacingF        =       0.05
res@cnFillPalette          =       "MPL_jet"
res@gsnCenterString        =   "Temperature"
res@gsnLeftString=""
res@gsnCenterStringFontHeightF=0.025
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      26. 
res@cnMinLevelValF         =      6.
res@cnLevelSpacingF        =       1.
res@tiXAxisString =""
res@tiYAxisString =""
plot(0)=gsn_csm_contour(wks,en4_temp3,res)
res@lbTitleString    = "psu"                ; title string
res@gsnCenterString        =   "Salinity"
res@cnMaxLevelValF         =      36.
res@cnMinLevelValF         =      33.
res@cnLevelSpacingF        =       0.2
plot(1)=gsn_csm_contour(wks,en4_sal3,res)
res@cnFillPalette          =       "BlueDarkRed18"
res@lbTitleString    = "~S~o~N~C"                ; title string
res@gsnCenterString        =   ""
res@cnMaxLevelValF         =      3. 
res@cnMinLevelValF         =      -3.
res@cnLevelSpacingF        =       0.5
plot(2)=gsn_csm_contour(wks,diff_thetao_oda,res)
plot(4)=gsn_csm_contour(wks,diff_thetao_aoda,res)
res@lbTitleString    = "psu"                ; title string
res@cnMaxLevelValF         =      1. 
res@cnMinLevelValF         =      -1.
res@cnLevelSpacingF        =       0.1
plot(3)=gsn_csm_contour(wks,diff_so_oda,res)
plot(5)=gsn_csm_contour(wks,diff_so_aoda,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 1 
pres@gsnPanelMainString="Zonal mean (2010-2021)"
pres@gsnPanelMainFontHeightF=0.023
pres@gsnPanelTop       = 0.9 
pres@gsnPanelBottom       = 0.05
pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/3,2/),pres)
txres1               = True
txres1@txFontHeightF = 0.014
txres1@txAngleF      = 90. 
gsn_text_ndc(wks, "EN4",0.055, 0.77, txres1)
gsn_text_ndc(wks, "ESM4-PDAF_ocean",0.055, 0.48, txres1)
gsn_text_ndc(wks, "ESM4-PDAF_coupled",0.055, 0.20, txres1)

txres2               = True
txres2@txFontHeightF = 0.010
txres2@txAngleF      = 0. 
gsn_text_ndc(wks, "(m)",0.105, 0.87, txres2)
gsn_text_ndc(wks, "(m)",0.105, 0.587, txres2)
gsn_text_ndc(wks, "(m)",0.105, 0.305, txres2)

gsn_text_ndc(wks, "(m)",0.56, 0.87, txres2)
gsn_text_ndc(wks, "(m)",0.56, 0.587, txres2)
gsn_text_ndc(wks, "(m)",0.56, 0.305, txres2)

gsn_text_ndc(wks, "~S~o~N~C",0.48, 0.66, txres2)
gsn_text_ndc(wks, "~S~o~N~C",0.48, 0.375, txres2)
gsn_text_ndc(wks, "~S~o~N~C",0.48, 0.09, txres2)

gsn_text_ndc(wks, "psu",0.935, 0.66, txres2)
gsn_text_ndc(wks, "psu",0.935, 0.375, txres2)
gsn_text_ndc(wks, "psu",0.935, 0.09, txres2)

frame(wks)

end
