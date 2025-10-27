begin
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/output_pro/"
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
dir4="/media/cmlws/Data2/hjc/image/"
;--------------------------------------------------------------------------------------------
;    Masking Land area
;--------------------------------------------------------------------------------------------
a = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
lsdata = a->LSMASK
;---------CHL_clim----------------------------------------------------------------------------
g2=addfile(dir2+"diff_thetao_clim_199710-201112.nc","r")
thetao_clim=g2->thetao
lat=g2->lat
lon=g2->lon
depth=g2->deptht
dim=dimsizes(thetao_clim)

thermo_clim_depth=new((/dim(0),dim(2),dim(3)/),"float")
num_clim=dim_maxind(thetao_clim(deptht|:,time_counter|:,lat|:,lon|:),0)
clim_A=ndtooned(num_clim)
clim_B=depth(clim_A)
thermo_clim_depth=onedtond(clim_B,(/dim(0),dim(2),dim(3)/))
copy_VarMeta(num_clim,thermo_clim_depth)
thetao_clim_clm=dim_avg_n_Wrap(thermo_clim_depth,0)
;-------------------------------------------------------------------------------------------------
lsm_thetao  = landsea_mask(a->LSMASK,thetao_clim_clm&lat,thetao_clim_clm&lon)
thetao_clim_clm=mask(thetao_clim_clm,lsm_thetao.ge.1,False)
;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir2+"diff_thetao_const_199710-201112.nc","r")
thetao_const=h1->thetao

thermo_const_depth=new((/dim(0),dim(2),dim(3)/),"float")
num_const=dim_maxind(thetao_const(deptht|:,time_counter|:,lat|:,lon|:),0)
const_A=ndtooned(num_const)
const_B=depth(const_A)
thermo_const_depth=onedtond(const_B,(/dim(0),dim(2),dim(3)/))
copy_VarMeta(num_const,thermo_const_depth)
thetao_const_clm=dim_avg_n_Wrap(thermo_const_depth,0)
thetao_const_clm=mask(thetao_const_clm,lsm_thetao.ge.1,False)
;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir2+"diff_thetao_inter_199710-201112.nc","r")
thetao_inter=h2->thetao

thermo_inter_depth=new((/dim(0),dim(2),dim(3)/),"float")
num_inter=dim_maxind(thetao_inter(deptht|:,time_counter|:,lat|:,lon|:),0)
inter_A=ndtooned(num_inter)
inter_B=depth(inter_A)
thermo_inter_depth=onedtond(inter_B,(/dim(0),dim(2),dim(3)/))
copy_VarMeta(num_inter,thermo_inter_depth)
thetao_inter_clm=dim_avg_n_Wrap(thermo_inter_depth,0)
thetao_inter_clm=mask(thetao_inter_clm,lsm_thetao.ge.1,False)
;--------------------------------------------------------------------------------------------
inter_clim=thetao_inter_clm-thetao_clim_clm
copy_VarMeta(thetao_clim_clm,inter_clim)
inter_const=thetao_inter_clm-thetao_const_clm
copy_VarMeta(thetao_clim_clm,inter_const)
clim_const=thetao_clim_clm-thetao_const_clm
copy_VarMeta(thetao_clim_clm,clim_const)
;--------------------------------------------------------------------------------------------

 plot=new(3,graphic)
 wks  = gsn_open_wks("png",dir4+"thermocline_map_DIFF_enso_region_199710-201112")    ; send graphics to PNG file
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
 res@cnLevelSpacingF        =       5
 res@cnMaxLevelValF         =      50
 res@cnMinLevelValF         =      -50
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
 pres@gsnPanelMainString="Diff. in Thermocline depth (199710 - 201112)"
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
