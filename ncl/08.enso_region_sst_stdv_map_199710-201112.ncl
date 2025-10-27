begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/OUTPUT/chl_clim_196001-199709/"
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
dir4=""
;-------------------------------------------OISST-------------------------------------------
f=addfile(dir1+"oisst-avhrr-v02r01.r180x90.198109-201912.nc","r")
sst=f->sst(0:363,0,:,:)
sst := short2flt(sst)
sst_clim2=sst(193:363,:,:) ;1997.10~ 2011.12
sst_clim=dim_avg_n_Wrap(sst_clim2,0)
sst_stdv=dim_stddev_n_Wrap(sst_clim2,0)
;--------------------------------------------------------------------------------------------
;    Masking Land area
;--------------------------------------------------------------------------------------------
a = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
lsdata = a->LSMASK
;---------CHL_clim----------------------------------------------------------------------------
g2=addfile(dir3+"tos_regrid_clim_199710-201112.nc","r")
tos_clim=g2->tos
;tos_clim_annual=month_to_annual(tos_clim,1)
;-------------------------------------------------------------------------------------------------
lsm_tos  = landsea_mask(a->LSMASK,tos_clim&lat,tos_clim&lon)
;-------------------------------------------------------------------------------------------------
tos_clim_clm=dim_avg_n_Wrap(tos_clim,0)
tos_clim_stdv=dim_stddev_n_Wrap(tos_clim,0)
tos_clim_clm=mask(tos_clim_clm,lsm_tos.ge.1,False)
tos_clim_stdv=mask(tos_clim_stdv,lsm_tos.ge.1,False)
;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir3+"tos_regrid_const_199710-201112.nc","r")
tos_const=h1->tos
;tos_const_annual=month_to_annual(tos_const,1)

tos_const_clm=dim_avg_n_Wrap(tos_const,0)
tos_const_stdv=dim_stddev_n_Wrap(tos_const,0)
tos_const_clm=mask(tos_const_clm,lsm_tos.ge.1,False)
tos_const_stdv=mask(tos_const_stdv,lsm_tos.ge.1,False)
;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir3+"tos_regrid_inter_199710-201112.nc","r")
tos_inter=h2->tos
;tos_inter_annual=month_to_annual(tos_inter,1)

tos_inter_clm=dim_avg_n_Wrap(tos_inter,0)
tos_inter_stdv=dim_stddev_n_Wrap(tos_inter,0)
tos_inter_clm=mask(tos_inter_clm,lsm_tos.ge.1,False)
tos_inter_stdv=mask(tos_inter_stdv,lsm_tos.ge.1,False)
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------

 plot=new(8,graphic)
 wks  = gsn_open_wks("png","./map_enso_region_sst_stdv_199710-201112")    ; send graphics to PNG file
 res			=	True
 res@lbLabelBarOn               = False
 ; Set resources for when we turn on labelbar later
 res@lbTitleFontHeightF         = .03                 ; make title smaller
 res@pmLabelBarWidthF		=  0.8
 res@lbTitleString              = " C~S~o~N~ "            ; title string
 res@lbTitlePosition            = "Bottom"            ; title position
 res@lbTitleDirection           = "Across"            ; title direction
 res@lbLabelStride              = 2
 res@lbLabelFontHeightF         = 0.025
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
 res2				=	res
 res@cnMaxLevelValF         =      30 
 res@cnMinLevelValF         =      15 
 res@cnLevelSpacingF        =       1
 res@cnFillPalette          =       "MPL_Reds"
 res@gsnCenterString        = "MEAN"
 plot(0) = gsn_csm_contour_map(wks,sst_clim,res)        ; draw global map
 res@gsnCenterString        = ""
 plot(2) = gsn_csm_contour_map(wks,tos_clim_clm,res)        ; draw global map
 plot(4) = gsn_csm_contour_map(wks,tos_const_clm,res)        ; draw global map
 res@lbLabelBarOn           = True
 plot(6) = gsn_csm_contour_map(wks,tos_inter_clm,res)        ; draw global map
 res2@lbLabelStride              = 2
 res2@cnFillPalette          =       "cmocean_amp"
 res2@cnMaxLevelValF         =      5 
 res2@cnMinLevelValF         =      0 
 res2@cnLevelSpacingF        =      0.5 
 res2@gsnCenterString        = "STDV (monthly)"
 plot(1) = gsn_csm_contour_map(wks,sst_stdv,res2)        ; draw global map
 res2@gsnCenterString        = ""
 plot(3) = gsn_csm_contour_map(wks,tos_clim_stdv,res2)        ; draw global map
 plot(5) = gsn_csm_contour_map(wks,tos_const_stdv,res2)        ; draw global map
 res2@lbLabelBarOn           = True
 plot(7) = gsn_csm_contour_map(wks,tos_inter_stdv,res2)        ; draw global map

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Sea Surface Temperature (199710 - 201112)"
 pres@gsnPanelBottom=0.1
 pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@pmLabelBarWidthF = 0.8 ; label bar width
 pres@pmLabelBarHeightF = 0.05
 gsn_panel(wks,plot,(/4,2/),pres)
 txres               = True
 txres@txFontHeightF = 0.014
; txres@txAngleF      = 90.
 gsn_text_ndc(wks, "OISST",  0.1, 0.83, txres)
 gsn_text_ndc(wks, "CLIM",  0.105, 0.628, txres)
 gsn_text_ndc(wks, "CONST", 0.1, 0.41, txres)
 gsn_text_ndc(wks, "INTER", 0.105, 0.205, txres)
 
 frame(wks)

end
