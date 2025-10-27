begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/OUTPUT/chl_clim_196001-199709/"
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
dir4=""
;--------------------------------------------------------------------------------------------
;---------CHL_clim----------------------------------------------------------------------------
f=addfile(dir1+"oisst-avhrr-v02r01.r180x90.198109-201912.nc","r")
sst=f->sst(0:363,0,:,:)
sst := short2flt(sst)

sst_clim1=sst(0:192,:,:) ;1981.09 ~ 1997.09
sst_clim2=sst(193:363,:,:) ;1997.10~ 2011.12

g1=addfile(dir3+"tos_regrid_clim_196101-199709.nc","r")
tos_clim1=g1->tos(248:440,:,:)
g2=addfile(dir3+"tos_regrid_clim_199710-201112.nc","r")
tos_clim2=g2->tos

corr_clim1=escorc(sst_clim1(lat|:,lon|:,time|:),tos_clim1(lat|:,lon|:,time_counter|:))
copy_VarCoords(sst(0,:,:),corr_clim1)
corr_clim2=escorc(sst_clim2(lat|:,lon|:,time|:),tos_clim2(lat|:,lon|:,time_counter|:))
copy_VarCoords(sst(0,:,:),corr_clim2)
;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir3+"tos_regrid_const_199710-201112.nc","r")
tos_const=h1->tos
corr_const=escorc(sst_clim2(lat|:,lon|:,time|:),tos_const(lat|:,lon|:,time_counter|:))
copy_VarCoords(sst(0,:,:),corr_const)
;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir3+"tos_regrid_inter_199710-201112.nc","r")
tos_inter=h2->tos
corr_inter=escorc(sst_clim2(lat|:,lon|:,time|:),tos_inter(lat|:,lon|:,time_counter|:))
copy_VarCoords(sst(0,:,:),corr_inter)
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------

 plot=new(4,graphic)
 wks  = gsn_open_wks("png","./corr_NEMO_OISST_EN4")    ; send graphics to PNG file
 res			=	True
;res@cnFillPalette    	=	"BlueDarkRed18"
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 res@cnFillMode             =   "AreaFill"
 res@lbLabelBarOn           =      False
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      1.0 
 res@cnMinLevelValF         =      -1.0 
 res@cnLevelSpacingF        =       0.1
 res@cnFillPalette          =       "temp_19lev"
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@lbLabelBarOn           = False
 res@tmXBLabelFontHeightF   =       0.025
 res@tmYLLabelFontHeightF   =       0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpCenterLonF       =       180
 res@mpLandFillColor    =   "white"
 res@gsnCenterString        = "chl_clim and OISST (198109-199709)"
 plot(0) = gsn_csm_contour_map(wks,corr_clim1,res)        ; draw global map
 res@gsnCenterString        = "chl_clim and OISST (199710-201112)"
 plot(1) = gsn_csm_contour_map(wks,corr_clim2,res)        ; draw global map
 res@gsnCenterString        = "chl_const and OISST (199710-201112)"
 plot(2) = gsn_csm_contour_map(wks,corr_const,res)        ; draw global map
 res@gsnCenterString        = "chl_inter and OISST (199710-201112)"
 plot(3) = gsn_csm_contour_map(wks,corr_inter,res)        ; draw global map

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.010
 pres@lbLabelStride     =   2
 pres@lbLabelFontHeightF = 0.02
 pres@pmLabelBarWidthF = 0.8 ; label bar width
 pres@pmLabelBarHeightF = 0.05
 gsn_panel(wks,plot,(/2,2/),pres)
 frame(wks)

end
