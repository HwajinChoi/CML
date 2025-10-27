begin
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/OUTPUT/chl_clim_196001-199709/"
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
dir4="/media/cmlws/Data2/hjc/image/"
;--------------------------------------------------------------------------------------------
;    Masking Land area
;--------------------------------------------------------------------------------------------
a = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
lsdata = a->LSMASK
;---------CHL_clim----------------------------------------------------------------------------
g2=addfile(dir3+"tos_regrid_clim_199710-201112.nc","r")
tos_clim=g2->tos
;-------------------------------------------------------------------------------------------------
lsm_tos  = landsea_mask(a->LSMASK,tos_clim&lat,tos_clim&lon)
;-------------------------------------------------------------------------------------------------
tos_clim_clm=dim_avg_n_Wrap(tos_clim,0)
tos_clim_clm=mask(tos_clim_clm,lsm_tos.ge.1,False)

;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir3+"tos_regrid_const_199710-201112.nc","r")
tos_const=h1->tos
tos_const_clm=dim_avg_n_Wrap(tos_const,0)
tos_const_clm=mask(tos_const_clm,lsm_tos.ge.1,False)

;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir3+"tos_regrid_inter_199710-201112.nc","r")
tos_inter=h2->tos
tos_inter_clm=dim_avg_n_Wrap(tos_inter,0)
tos_inter_clm=mask(tos_inter_clm,lsm_tos.ge.1,False)

;--------------------------------------------------------------------------------------------
inter_clim=tos_inter_clm-tos_clim_clm
copy_VarMeta(tos_clim_clm,inter_clim)
inter_const=tos_inter_clm-tos_const_clm
copy_VarMeta(tos_clim_clm,inter_const)
clim_const=tos_clim_clm-tos_const_clm
copy_VarMeta(tos_clim_clm,clim_const)

;--------------------------------------------------------------------------------------------

 plot=new(3,graphic)
 wks  = gsn_open_wks("png",dir4+"map_DIFF_enso_region_sst_199710-201112")    ; send graphics to PNG file
 res			=	True
 res@lbLabelBarOn               = False
 ; Set resources for when we turn on labelbar later
 res@lbTitleFontHeightF         = .03                 ; make title smaller
 res@pmLabelBarWidthF		=  0.8
 res@lbTitleString              = " "            ; title string
 res@lbTitlePosition            = "Bottom"            ; title position
 res@lbTitleDirection           = "Across"            ; title direction
 res@lbLabelStride              = 2
; res@lbLabelFontHeightF         = 0.01
 res@pmLabelBarHeightF          = 0.1
 res@pmLabelBarOrthogonalPosF=0.3
 ;res@cnFillDrawOrder = "PostDraw"
 res@mpMinLonF=105
 res@mpMaxLonF=300
 res@mpMinLatF=-40
 res@mpMaxLatF=40
 res@mpPerimOn              = False
 res@lbBoxEndCapStyle           = "TriangleBothEnds"
 res@lbOrientation              = "Horizontal"        ; orientation
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =	False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 res@gsnLeftString=""
 res@mpLandFillColor    =   "white"
 res@gsnRightString=""
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@tmXBLabelFontHeightF   =       0.025
 res@tmYLLabelFontHeightF   =       0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpCenterLonF       =       150
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.7
 res@cnMinLevelValF         =      -0.7 
 res@cnLevelSpacingF        =       0.05
 res@cnFillPalette          =       "ncl_default"
 res@gsnCenterString        = "INTER - CLIM"
 plot(0) = gsn_csm_contour_map(wks,inter_clim,res)        ; draw global map
 res@gsnCenterString        = "INTER - CONST"
 plot(1) = gsn_csm_contour_map(wks,inter_const,res)        ; draw global map
 res@lbLabelBarOn           = False
 res@gsnCenterString        = "CLIM - CONST"
 plot(2) = gsn_csm_contour_map(wks,clim_const,res)        ; draw global map

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Mean difference of SST (199710 - 201112)"
 pres@gsnPanelBottom=0.1
 pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@pmLabelBarWidthF = 0.45 ; label bar width
 pres@pmLabelBarHeightF = 0.05
 pres@lbLabelFontHeightF=0.015
 pres@lbLabelStride              = 2

 gsn_panel(wks,plot,(/3,1/),pres)
 txres               = True
 txres@txFontHeightF = 0.014
; txres@txAngleF      = 90.
; gsn_text_ndc(wks, "OISST",  0.1, 0.83, txres)
; gsn_text_ndc(wks, "CLIM",  0.105, 0.628, txres)
; gsn_text_ndc(wks, "CONST", 0.1, 0.41, txres)
; gsn_text_ndc(wks, "INTER", 0.105, 0.205, txres)
 
 frame(wks)

end
