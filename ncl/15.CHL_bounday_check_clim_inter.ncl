begin
dir1="/media/cmlws/Data2/hjc/satellite/seawifs_modis/"
dir4="/media/cmlws/Data2/hjc/image/"

f=addfile(dir1+"chl_clim_seawifs_modis_regrid_199710-202112.nc","r")
g=addfile(dir1+"chl_regrid_1997-2011.nc","r")
chl_clim_month=f->chlor_a
chl_inter_year=g->chlor_a


chl_clim=dim_avg_n_Wrap(chl_clim_month,0)
chl_inter=dim_avg_n_Wrap(chl_inter_year,0)
inter_clim=chl_inter-chl_clim
copy_VarMeta(chl_clim,inter_clim)

plot=new(3,graphic)
 wks  = gsn_open_wks("png",dir4+"CHL_map_trophic_199710-201112")    ; send graphics to PNG file
 res                    =       True
 res@lbLabelBarOn               = False
 ; Set resources for when we turn on labelbar later
 res@lbTitleFontHeightF         = .03                 ; make title smaller
 res@pmLabelBarWidthF           =  0.8
 res@lbTitleString              = "mg m~S~3~N~"            ; title string
 res@lbTitlePosition            = "Bottom"            ; title position
 res@lbTitleDirection           = "Across"            ; title direction
 res@lbLabelStride              = 2
 res@lbLabelFontHeightF         = 0.025
 res@pmLabelBarHeightF          = 0.1
 res@pmLabelBarOrthogonalPosF=0.3
 res@mpMinLonF                  =       105
 res@mpMaxLonF                  =300
 res@mpMinLatF                  =-40
 res@mpMaxLatF                  =40
 res@mpPerimOn              = False
 res@lbBoxEndCapStyle           = "TriangleBothEnds"
 res@lbOrientation              = "Horizontal"        ; orientation
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 res@gsnLeftString              =""
 res@mpLandFillColor            =   "white"
 res@gsnRightString             =""
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@tmXBLabelFontHeightF   =       0.025
 res@tmYLLabelFontHeightF   =       0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpCenterLonF       =       150
 res2=res
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnLevelSpacingF        =       0.05
 res@cnMaxLevelValF         =      0.5
 res@cnMinLevelValF         =      0
 res@cnFillPalette          =       "cmocean_algae"
 res@gsnCenterString        = "MEAN"
 plot(0) = gsn_csm_contour_map(wks,chl_clim,res)        ; draw global map
 res@gsnCenterString        = ""
 res@lbLabelBarOn           = True
 plot(1) = gsn_csm_contour_map(wks,chl_inter,res)        ; draw global map
 res2@cnFillPalette          =       "GMT_polar"
 res2@cnLevelSelectionMode   =       "ManualLevels"
 res2@cnLevelSpacingF        =       0.005
 res2@cnMaxLevelValF         =      0.04
 res2@cnMinLevelValF         =      -0.04
 res2@gsnCenterString        = ""
 res2@lbLabelBarOn           = True
 plot(2) = gsn_csm_contour_map(wks,inter_clim,res2)        ; draw global map

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="CHL (199710 - 201112)"
 pres@gsnPanelBottom=0.1
 pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 6
 pres@pmLabelBarWidthF = 0.8 ; label bar width
 pres@pmLabelBarHeightF = 0.05
 gsn_panel(wks,plot,(/3,1/),pres)
 txres               = True
 txres@txFontHeightF = 0.018
; txres@txAngleF      = 90.
 gsn_text_ndc(wks, "CLIM",  0.205, 0.8, txres)
 gsn_text_ndc(wks, "INTER", 0.20, 0.52, txres)
 gsn_text_ndc(wks, "Diff", 0.205, 0.24, txres)
 gsn_text_ndc(wks, "(INTER-CLIM)", 0.203, 0.21, txres)

 frame(wks)
end
