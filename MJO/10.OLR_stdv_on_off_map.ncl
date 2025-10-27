begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
dir0="/media/cmlws/Data2/hjc/MJO/data/RE/cobalt/"
dir1="/media/cmlws/Data2/hjc/MJO/data/RE/daily_chl/"
dir2="/media/cmlws/Data2/hjc/MJO/data/RE/clim_chl/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

b2 = addfile(file11,"r")

f=addfile(dir0+"olr.199001-200912.nc","r")
olr_on=f->olr ; 240
yh=f->grid_yt
xh=f->grid_xt

lsm_t85  = landsea_mask(b2->LSMASK,yh,xh)
olr_on_DJF=month_to_season(olr_on,"DJF")
olr_on_JJA=month_to_season(olr_on,"JJA")
olr_on_annual=month_to_annual(olr_on,1)

olr_on_DJF2=dim_stddev_n_Wrap(olr_on_DJF,0); average of DJF
olr_on_JJA2=dim_stddev_n_Wrap(olr_on_JJA,0) ; average of JJA
olr_on_annual2=dim_stddev_n_Wrap(olr_on_annual,0)

g=addfile(dir1+"olr.199001-200912.nc","r")
olr_daily=g->olr
olr_daily_DJF=month_to_season(olr_daily,"DJF")
olr_daily_JJA=month_to_season(olr_daily,"JJA")
olr_daily_annual=month_to_annual(olr_daily,1)

olr_daily_DJF2=dim_stddev_n_Wrap(olr_daily_DJF,0) ; average of DJF
olr_daily_JJA2=dim_stddev_n_Wrap(olr_daily_JJA,0) ; average of JJA
olr_daily_annual2=dim_stddev_n_Wrap(olr_daily_annual,0)

h=addfile(dir2+"olr.199001-200912.nc","r")
olr_clim=h->olr
olr_clim_DJF=month_to_season(olr_clim,"DJF")
olr_clim_JJA=month_to_season(olr_clim,"JJA")
olr_clim_annual=month_to_annual(olr_clim,1)

olr_clim_DJF2=dim_stddev_n_Wrap(olr_clim_DJF,0) ; average of DJF
olr_clim_JJA2=dim_stddev_n_Wrap(olr_clim_JJA,0) ; average of JJA
olr_clim_annual2=dim_stddev_n_Wrap(olr_clim_annual,0)

plot=new(9,graphic)
wks=gsn_open_wks("png",dir3+"olr_STDV_COBALT_DAILY_CLIM_DJF_JJA_tropical_map")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@vpHeightF=0.2
res@vpWidthF=0.8
res@cnFillOn             = True         ; turn on color fill
res@cnLineLabelsOn         =       False
res@cnLinesOn            = False         ; True is default
res@gsnAddCyclic=False
res@mpCenterLonF         = 180.         ; defailt is 0 [GM]
res@mpMinLatF            =-30 
res@mpMaxLatF            =30
;res@mpMinLonF            = 0
;res@mpMaxLonF            = 360
res@mpShapeMode  = "FreeAspect"
;res@mpFillDrawOrder      = "PostDraw"
;res@mpLandFillColor      = "black"
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
;res@tmYLMinorPerMajor=1
res@gsnLeftStringFontHeightF=0.028
res@gsnRightStringFontHeightF=0.025
res@tmYLLabelStride     =       2
res@tmXBLabelStride     =       2
res@pmLabelBarOrthogonalPosF=0.5
res@gsnCenterStringFontHeightF=0.04
res@gsnCenterStringOrthogonalPosF=0.15
res@pmLabelBarWidthF=0.75
res@lbLabelFontHeightF  = 0.03
res@gsnAddCyclic         = False 

; panel plot only resources
resP                     = True         ; modify the panel plot
resP@gsnMaximize         = True         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
;resP@lbLabelFontHeightF  = 0.012
;resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelLeft=0.1

resP@gsnPanelMainString  = ""
res@gsnRightString = "" 
res@gsnLeftString  ="" 
res@gsnCenterString  ="Annual"
res@cnFillPalette        = "matlab_jet"
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     16
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =     2  
res@lbLabelBarOn         = False        ; turn off individual lb's
plot(0) = gsn_csm_contour_map(wks,olr_on_annual2,res)
res@gsnCenterString  =""
plot(3) = gsn_csm_contour_map(wks,olr_daily_annual2,res)
res@lbLabelBarOn         = True        ; turn off individual lb's
plot(6) = gsn_csm_contour_map(wks,olr_clim_annual2,res)
res@gsnCenterString  ="JJA"
res@cnMaxLevelValF         =      20
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =       2
res@lbLabelBarOn         = False        ; turn off individual lb's
plot(1) = gsn_csm_contour_map(wks,olr_on_JJA2,res)
res@gsnCenterString  =""
plot(4) = gsn_csm_contour_map(wks,olr_daily_JJA2,res)
res@lbLabelBarOn         = True 
plot(7) = gsn_csm_contour_map(wks,olr_clim_JJA2,res)
res@gsnCenterString  ="DJF"
res@cnMaxLevelValF         =      24
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =       2
res@lbLabelBarOn         = False        ; turn off individual lb's
plot(2) = gsn_csm_contour_map(wks,olr_on_DJF2,res)
res@gsnCenterString  =""
plot(5) = gsn_csm_contour_map(wks,olr_daily_DJF2,res)
res@lbLabelBarOn         = True 
plot(8) = gsn_csm_contour_map(wks,olr_clim_DJF2,res)

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.012
gsn_text_ndc(wks,"Cobalt",0.06,0.61,txres1)
gsn_text_ndc(wks,"Daily",0.06,0.5,txres1)
gsn_text_ndc(wks,"Clim",0.06,0.39,txres1)

txres2               = True                      ; text mods desired
txres2@txFontHeightF = 0.008
gsn_text_ndc(wks,"[w/m~S~2~N~]",0.265,0.28,txres1)
gsn_text_ndc(wks,"[w/m~S~2~N~]",0.565,0.28,txres1)
gsn_text_ndc(wks,"[w/m~S~2~N~]",0.865,0.28,txres1)
gsn_panel(wks,plot,(/3,3/),resP)     ; draw all 'neof' as one plot

end
