begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/EN4/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

f1=addfile(dir1+"EN.4.2.2.r360x180.temperature_201001-202112.nc","r")
en4_temp0=f1->temperature(:,{0:300},:,:)
en4_temp0_15=f1->temperature(60:143,{0:300},:,:)

en4_temp1=dim_avg_n_Wrap(en4_temp0,0)
en4_temp1_15=dim_avg_n_Wrap(en4_temp0_15,0)
en4_temp=dim_avg_n_Wrap(en4_temp1,0)
en4_temp_15=dim_avg_n_Wrap(en4_temp1_15,0)

f2=addfile(dir1+"EN.4.2.2.r360x180.salinity_201001-202112.nc","r")
en4_sal0=f2->salinity(:,{0:300},:,:)
en4_sal0_15=f2->salinity(60:143,{0:300},:,:)

en4_sal1=dim_avg_n_Wrap(en4_sal0,0)
en4_sal1_15=dim_avg_n_Wrap(en4_sal0_15,0)
en4_sal=dim_avg_n_Wrap(en4_sal1,0)
en4_sal_15=dim_avg_n_Wrap(en4_sal1_15,0)

g1=addfile(dir2+"thetao.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
thetao_oda0=g1->thetao(:,{0:300},:,:)
thetao_oda1=dim_avg_n_Wrap(thetao_oda0,0)
thetao_oda=dim_avg_n_Wrap(thetao_oda1,0)
diff_thetao_oda=thetao_oda-en4_temp_15
copy_VarCoords(thetao_oda,diff_thetao_oda)

h1=addfile(dir3+"thetao.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
thetao_aoda0=h1->thetao(:,{0:300},:,:)
thetao_aoda1=dim_avg_n_Wrap(thetao_aoda0,0)
thetao_aoda=dim_avg_n_Wrap(thetao_aoda1,0)
diff_thetao_aoda=thetao_aoda-en4_temp
copy_VarCoords(thetao_aoda,diff_thetao_aoda)

g2=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
so_oda0=g2->so(:,{0:300},:,:)
so_oda1=dim_avg_n_Wrap(so_oda0,0)
so_oda=dim_avg_n_Wrap(so_oda1,0)
diff_so_oda=so_oda-en4_sal_15
copy_VarCoords(so_oda,diff_so_oda)

h2=addfile(dir3+"so.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
so_aoda0=h2->so(:,{0:300},:,:)
so_aoda1=dim_avg_n_Wrap(so_aoda0,0)
so_aoda=dim_avg_n_Wrap(so_aoda1,0)
diff_so_aoda=so_aoda-en4_sal
copy_VarCoords(so_aoda,diff_so_aoda)

plot=new(6,graphic)
wks=gsn_open_wks("png",dir0+"EN4_PDAFs_map_subsurface_temp_sau_2010-2021")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn              =       False
res@cnLineLabelsOn         =       False
;----ROBINSION------
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@gsnCenterStringFontHeightF= 0.025
;-------------------------------------------------
res@lbLabelBarOn           = True
res@lbLabelFontHeightF  = 0.018
res@lbLabelStride     =   2   
;res@pmLabelBarWidthF=0.6
;res@pmLabelBarHeightF=0.05
res@lbTitleOn        =  True                ; turn on title
res@lbTitleString    = "~S~o~N~C"                ; title string
res@lbTitlePosition  = "Bottom"              ; title position
res@lbTitleFontHeightF= 0.020     
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       2   
res@tmYLLabelStride     =       2   
res@mpCenterLonF       =       180 
;res@gsnCenterStringOrthogonalPosF=0.1
res@mpLandFillColor    =   "black"
;res@cnMaxLevelValF         =      0.4 
;res@cnMinLevelValF         =      -0.4
;res@cnLevelSpacingF        =       0.05
res@cnFillPalette          =       "cmp_b2r"
res@gsnCenterString        =   "Temperature"
res@gsnLeftString=""
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      30 
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =       2.
plot(0)=gsn_csm_contour_map(wks,en4_temp,res)
res@lbTitleString    = "psu"                ; title string
res@gsnCenterString        =   "Salinity"
res@cnMaxLevelValF         =      38 
res@cnMinLevelValF         =      30
res@cnLevelSpacingF        =       0.5
plot(1)=gsn_csm_contour_map(wks,en4_sal,res)
res@lbTitleString    = "~S~o~N~C"                ; title string
res@cnFillPalette          =       "temp_19lev"
res@gsnCenterString        =   ""
res@cnMaxLevelValF         =      3 
res@cnMinLevelValF         =      -3
res@cnLevelSpacingF        =       0.5
plot(2)=gsn_csm_contour_map(wks,diff_thetao_oda,res)
res@lbTitleString    = "psu"                ; title string
res@cnMaxLevelValF         =      3 
res@cnMinLevelValF         =      -3
res@cnLevelSpacingF        =       0.5
plot(3)=gsn_csm_contour_map(wks,diff_so_oda,res)
res@lbTitleString    = "~S~o~N~C"                ; title string
res@cnMaxLevelValF         =      3 
res@cnMinLevelValF         =      -3
res@cnLevelSpacingF        =       0.5
plot(4)=gsn_csm_contour_map(wks,diff_thetao_aoda,res)
res@lbTitleString    = "psu"                ; title string
res@cnMaxLevelValF         =      3 
res@cnMinLevelValF         =      -3
res@cnLevelSpacingF        =       0.5
plot(5)=gsn_csm_contour_map(wks,diff_so_aoda,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 5 
pres@gsnPanelMainString="Subsurface (2010-2021)"
pres@gsnPanelMainFontHeightF=0.023
pres@gsnPanelTop       = 0.9 
pres@gsnPanelBottom       = 0.05
pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/3,2/),pres)
txres1               = True
txres1@txFontHeightF = 0.014
txres1@txAngleF      = 90. 
gsn_text_ndc(wks, "EN4",0.15, 0.77, txres1)
gsn_text_ndc(wks, "ESM4-PDAF_ocean",0.15, 0.48, txres1)
gsn_text_ndc(wks, "ESM4-PDAF_coupled",0.15, 0.20, txres1)

frame(wks)

end
