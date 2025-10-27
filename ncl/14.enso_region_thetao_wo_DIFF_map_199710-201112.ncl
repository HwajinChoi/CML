begin
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
dir4="/media/cmlws/Data2/hjc/image/"
;--------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------(5N-5S, 150W-90W)-----------------------------------------------------------------------
lon_min=130
lon_max=280+1
;---------CHL_clim----------------------------------------------------------------------------
g2=addfile(dir3+"thetao_chl_clim_199710_201112.nc","r")
thetao_clim=g2->thetao
thetao_clim_flip=lonFlip(thetao_clim)
thetao_clim2=thetao_clim_flip(:,{250:0},{lat_min:lat_max},{lon_min:lon_max})
;-------------------------------------------------------------------------------------------------
thetao_clim_clm=dim_avg_n_Wrap(thetao_clim2,2)
t_clim=dim_avg_n_Wrap(thetao_clim_clm,0)
;-------------------------------------------------------------------------------------------------
;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir3+"thetao_chl_const_199710_201112.nc","r")
thetao_const=h1->thetao
thetao_const_flip=lonFlip(thetao_const)
thetao_const2=thetao_const_flip(:,{250:0},{lat_min:lat_max},{lon_min:lon_max})
;-------------------------------------------------------------------------------------------------
thetao_const_clm=dim_avg_n_Wrap(thetao_const2,2)
t_const=dim_avg_n_Wrap(thetao_const_clm,0)
;-------------------------------------------------------------------------------------------------
;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir3+"thetao_chl_inter_199710_201112.nc","r")
thetao_inter=h2->thetao
thetao_inter_flip=lonFlip(thetao_inter)
thetao_inter2=thetao_inter_flip(:,{250:0},{lat_min:lat_max},{lon_min:lon_max})
;-------------------------------------------------------------------------------------------------
thetao_inter_clm=dim_avg_n_Wrap(thetao_inter2,2)
t_inter=dim_avg_n_Wrap(thetao_inter_clm,0)
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;---------CHL_clim----------------------------------------------------------------------------
g5=addfile(dir3+"wo_chl_clim_199710_201112.nc","r")
wo_clim=g5->wo
wo_clim=wo_clim*100*((10)^4)
wo_clim@units="cm/s"
wo_clim_flip=lonFlip(wo_clim)
wo_clim2=wo_clim_flip(:,{100:0},{lat_min:lat_max},{lon_min:lon_max})
;-------------------------------------------------------------------------------------------------
wo_clim_clm=dim_avg_n_Wrap(wo_clim2,2)
w_clim=dim_avg_n_Wrap(wo_clim_clm,0)
;-------------------------------------------------------------------------------------------------
;---------CHL_const----------------------------------------------------------------------------
h5=addfile(dir3+"wo_chl_const_199710_201112.nc","r")
wo_const=h5->wo
wo_const=wo_const*100*((10)^4)
wo_const@units="cm/s"
wo_const_flip=lonFlip(wo_const)
wo_const2=wo_const_flip(:,{100:0},{lat_min:lat_max},{lon_min:lon_max})
;-------------------------------------------------------------------------------------------------
wo_const_clm=dim_avg_n_Wrap(wo_const2,2)
w_const=dim_avg_n_Wrap(wo_const_clm,0)
;-------------------------------------------------------------------------------------------------
;---------CHL_inter----------------------------------------------------------------------------
h6=addfile(dir3+"wo_chl_inter_199710_201112.nc","r")
wo_inter=h6->wo
wo_inter=wo_inter*100*((10)^4)
wo_inter@units="cm/s"
wo_inter_flip=lonFlip(wo_inter)
wo_inter2=wo_inter_flip(:,{100:0},{lat_min:lat_max},{lon_min:lon_max})
;-------------------------------------------------------------------------------------------------
wo_inter_clm=dim_avg_n_Wrap(wo_inter2,2)
w_inter=dim_avg_n_Wrap(wo_inter_clm,0)
;--------------------------------------------------------------------------------------------
t_clim := t_clim(::-1,:)
t_const := t_const(::-1,:)
t_inter := t_inter(::-1,:)
w_clim := w_clim(::-1,:)
w_const := w_const(::-1,:)
w_inter := w_inter(::-1,:)
;--------------------------------------------------------------------------------------------
t_inter_clim=t_inter-t_clim
copy_VarMeta(t_clim,t_inter_clim)
t_inter_const=t_inter-t_const
copy_VarMeta(t_clim,t_inter_const)
t_clim_const=t_clim-t_const
copy_VarMeta(t_clim,t_clim_const)

w_inter_clim=w_inter-w_clim
copy_VarMeta(w_clim,w_inter_clim)
w_inter_const=w_inter-w_const
copy_VarMeta(w_clim,w_inter_const)
w_clim_const=w_clim-w_const
copy_VarMeta(w_clim,w_clim_const)
;--------------------------------------------------------------------------------------------

 plot=new(6,graphic)
 wks  = gsn_open_wks("png",dir4+"Diff_Vertical_equator_thetao_wo_mean_199710-201112")    ; send graphics to PNG file
 res			=	True
 res@lbLabelBarOn               = False
 ; Set resources for when we turn on labelbar later
 res@lbTitleFontHeightF         = .03                 ; make title smaller
 res@vpWidthF			= 0.75
 res@vpHeightF			= 0.35
 res@pmLabelBarWidthF		=  0.8
 res@lbTitleString              = "~S~o~N~C"            ; title string
 res@lbTitlePosition            = "Bottom"            ; title position
 res@lbTitleDirection           = "Across"            ; title direction
 res@lbLabelStride              = 2
 res@lbLabelFontHeightF         = 0.025
 res@pmLabelBarHeightF          = 0.1
 res@pmLabelBarOrthogonalPosF=0.2
 res@tmYLMode              = "Explicit"
 res@tmYLValues            = (/250,200,150,100,50,0/)
 res@tmYLLabels            = res@tmYLValues
 
 res@lbBoxEndCapStyle           = "TriangleBothEnds"
 res@lbOrientation              = "Horizontal"        ; orientation
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =	False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 res@gsnLeftString		=""
 res@gsnRightString		=""
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@tmXBLabelFontHeightF   =       0.025
 res@tmYLLabelFontHeightF   =       0.025
 res@tmXBTickStartF		= 150
 ;res@tmXBLabelStride     =       2
 res@tmXBTickSpacingF=30
; res@tmYLLabelStride     =       2
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnLevelSpacingF        =       0.2
 res@cnMaxLevelValF         =      2
 res@cnMinLevelValF         =      -2
 res@trYReverse = True

 res@cnFillPalette          =       "BlueDarkRed18"
 res@gsnCenterString        = "Temp"
 plot(0) = gsn_csm_contour(wks,t_inter_clim,res)        ; draw global map
 res@gsnCenterString        = ""
 plot(2) = gsn_csm_contour(wks,t_inter_const,res)        ; draw global map
 res@lbLabelBarOn           = True
 plot(4) = gsn_csm_contour(wks,t_clim_const,res)        ; draw global map
 res@lbLabelBarOn           = False
 delete([/res@cnLevelSpacingF,res@tmYLValues,res@tmYLLabels/])
 res@lbTitleString              = "x 10~S~-4~N~ cm/s"            ; title string
 res@cnLevelSpacingF        =       0.2
 res@cnMaxLevelValF         =     2 
 res@cnMinLevelValF         =      -2
 res@gsnCenterString        = "W"
 res@cnFillPalette          =    "BlueDarkRed18"
 res@tmYLMode              = "Explicit"
 res@tmYLValues            = (/100,80,60,40,20/)
 res@tmYLLabels            = res@tmYLValues
 res@tmXMinorGrid	=False
 plot(1) = gsn_csm_contour(wks,w_inter_clim,res)        ; draw global map
 res@gsnCenterString        = ""
 plot(3) = gsn_csm_contour(wks,w_inter_const,res)        ; draw global map
 res@lbLabelBarOn           = True
 plot(5) = gsn_csm_contour(wks,w_clim_const,res)        ; draw global map
 res@lbLabelBarOn           = False

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Diff (199710 - 201112)"
 pres@gsnPanelBottom=0.1
 pres@gsnPanelLeft=0.15
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 3
 pres@pmLabelBarWidthF = 0.8 ; label bar width
 pres@pmLabelBarHeightF = 0.05
 pres@gsnPanelLabelBar=False
 gsn_panel(wks,plot,(/3,2/),pres)
 txres               = True
 txres@txFontHeightF = 0.015
; txres@txAngleF      = 90.
 gsn_text_ndc(wks, "INTER - CLIM",  0.08, 0.78, txres)
 gsn_text_ndc(wks, "INTER - CONST", 0.08, 0.515, txres)
 gsn_text_ndc(wks, "CLIM - CONST", 0.08, 0.24, txres)
 txres2               = True
 txres2@txFontHeightF = 0.012
 gsn_text_ndc(wks, "[m]",  0.185, 0.875, txres)
 gsn_text_ndc(wks, "[m]",  0.185, 0.611, txres)
 gsn_text_ndc(wks, "[m]",  0.185, 0.352, txres)
 
 gsn_text_ndc(wks, "[m]",  0.62, 0.875, txres)
 gsn_text_ndc(wks, "[m]",  0.62, 0.611, txres)
 gsn_text_ndc(wks, "[m]",  0.62, 0.352, txres)
 frame(wks)

end
