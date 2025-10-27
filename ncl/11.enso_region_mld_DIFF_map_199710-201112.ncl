begin
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
dir4="/media/cmlws/Data2/hjc/image/"
;--------------------------------------------------------------------------------------------
;    Masking Land area
;--------------------------------------------------------------------------------------------
a = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
lsdata = a->LSMASK
;---------CHL_clim----------------------------------------------------------------------------
g2=addfile(dir3+"mld_chl_clim_199710_201112.nc","r")
mld_clim=g2->mldr10_1
;-------------------------------------------------------------------------------------------------
lsm_mld  = landsea_mask(a->LSMASK,mld_clim&lat,mld_clim&lon)
;-------------------------------------------------------------------------------------------------
mld_clim_clm=dim_avg_n_Wrap(mld_clim,0)
mld_clim_clm=mask(mld_clim_clm,lsm_mld.ge.1,False)
;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir3+"mld_chl_const_199710_201112.nc","r")
mld_const=h1->mldr10_1
mld_const_clm=dim_avg_n_Wrap(mld_const,0)
mld_const_clm=mask(mld_const_clm,lsm_mld.ge.1,False)
;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir3+"mld_chl_inter_199710_201112.nc","r")
mld_inter=h2->mldr10_1
mld_inter_clm=dim_avg_n_Wrap(mld_inter,0)
mld_inter_clm=mask(mld_inter_clm,lsm_mld.ge.1,False)
;--------------------------------------------------------------------------------------------
inter_clim=mld_inter_clm-mld_clim_clm
copy_VarMeta(mld_clim_clm,inter_clim)
inter_const=mld_inter_clm-mld_const_clm
copy_VarMeta(mld_clim_clm,inter_const)
clim_const=mld_clim_clm-mld_const_clm
copy_VarMeta(mld_clim_clm,clim_const)

;--------------------------------------------------------------------------------------------

 plot=new(3,graphic)
 wks  = gsn_open_wks("png",dir4+"map_DIFF_enso_region_mld_199710-201112")    ; send graphics to PNG file
 res			=	True
 res@lbLabelBarOn               = False
 ; Set resources for when we turn on labelbar later
 res@lbTitleFontHeightF         = .03                 ; make title smaller
 res@pmLabelBarWidthF		=  0.8
 res@lbTitleString              = "m"            ; title string
 res@lbTitlePosition            = "Bottom"            ; title position
 res@lbTitleDirection           = "Across"            ; title direction
 res@lbLabelStride              = 2
 res@lbLabelFontHeightF         = 0.025
 res@pmLabelBarHeightF          = 0.1
 res@pmLabelBarOrthogonalPosF=0.3
 res@mpMinLonF			=	105
 res@mpMaxLonF			=300
 res@mpMinLatF			=-40
 res@mpMaxLatF			=40
 res@mpPerimOn              = False
 res@lbBoxEndCapStyle           = "TriangleBothEnds"
 res@lbOrientation              = "Horizontal"        ; orientation
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =	False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 res@gsnLeftString		=""
 res@mpLandFillColor    	=   "white"
 res@gsnRightString		=""
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@tmXBLabelFontHeightF   =       0.025
 res@tmYLLabelFontHeightF   =       0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpCenterLonF       =       150
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnLevelSpacingF        =       1
 res@cnMaxLevelValF         =      10
 res@cnMinLevelValF         =      -10
 res@cnFillPalette          =       "BlueDarkRed18"
 res@gsnCenterString        = "INTER - CLIM"
 plot(0) = gsn_csm_contour_map(wks,inter_clim,res)        ; draw global map
 res@gsnCenterString        = "INTER - CONST"
 plot(1) = gsn_csm_contour_map(wks,inter_const,res)        ; draw global map
 res@gsnCenterString        = "CLIM - CONST"
 res@lbLabelBarOn           = True
 plot(2) = gsn_csm_contour_map(wks,clim_const,res)        ; draw global map

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Diff. in MLD (199710 - 201112)"
 pres@gsnPanelBottom=0.1
 pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@pmLabelBarWidthF = 0.8 ; label bar width
 pres@pmLabelBarHeightF = 0.05
 gsn_panel(wks,plot,(/3,1/),pres)
 txres               = True
 txres@txFontHeightF = 0.018
; txres@txAngleF      = 90.
; gsn_text_ndc(wks, "CLIM",  0.205, 0.8, txres)
; gsn_text_ndc(wks, "CONST", 0.20, 0.52, txres)
; gsn_text_ndc(wks, "INTER", 0.205, 0.24, txres)
 
 frame(wks)

end
