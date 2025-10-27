begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"                                                                                                                    
f0=addfile(dir1+"surface_increment_ocn_model_increment_201501-202112_ensmean.1x1.new.nc","r")
surf_temp=f0->tempinc(:,0,:,:)
surf_sal=f0->saltinc(:,0,:,:)
surf_temp=surf_temp*6
surf_sal=surf_sal*6

surf_temp2=where(surf_temp .ge. 100,surf_temp@_FillValue,surf_temp)
surf_sal2=where(surf_sal .ge. 100,surf_sal@_FillValue,surf_sal)
copy_VarMeta(surf_temp,surf_temp2)
copy_VarMeta(surf_sal,surf_sal2)
surf_temp3=dim_avg_n_Wrap(surf_temp2,0)
surf_sal3=dim_avg_n_Wrap(surf_sal2,0)

f1=addfile(dir1+"subsurface_increment_ocn_model_increment_201501-202112_ensmean.1x1.new.nc","r")
sub_temp=f1->tempinc
sub_sal=f1->saltinc
sub_temp=sub_temp*6
sub_sal=sub_sal*6
sub_temp1=where(sub_temp .ge. 100,sub_temp@_FillValue,sub_temp)
sub_sal1=where(sub_sal .ge. 100,sub_sal@_FillValue,sub_sal)
copy_VarMeta(sub_temp,sub_temp1)
copy_VarMeta(sub_sal,sub_sal1)
sub_temp2=dim_avg_n_Wrap(sub_temp1,0)
sub_sal2=dim_avg_n_Wrap(sub_sal1,0)
sub_temp3=dim_avg_n_Wrap(sub_temp2,0)
sub_sal3=dim_avg_n_Wrap(sub_sal2,0)

plot=new(4,graphic)
wks=gsn_open_wks("png",dir0+"figure3_increment_temp_sau_surf_sub_2015-2021")
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
res@lbTitleString    = ""                ; title string
res@lbTitlePosition  = "Bottom"              ; title position
res@lbTitleFontHeightF= 0.020
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       2
res@tmYLLabelStride     =       2
res@mpCenterLonF       =       180
;res@gsnCenterStringOrthogonalPosF=0.1
res@mpLandFillColor    =   "black"
res@cnFillPalette          =       "temp_diff_18lev"
res@gsnCenterString        =   "(a) Surface temperature"
res@gsnLeftString=""
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      2.
res@cnMinLevelValF         =      -2.
res@cnLevelSpacingF        =       0.2
plot(0)=gsn_csm_contour_map(wks,surf_temp3,res)
res@cnMaxLevelValF         =      0.0030
res@cnMinLevelValF         =      -0.0030
res@cnLevelSpacingF        =       0.0003
res@gsnCenterString        =   "(b) Surface salinity"
plot(1)=gsn_csm_contour_map(wks,surf_sal3,res)
;res@lbTitleString    = "~S~o~N~C"                ; title string
res@gsnCenterString        =   "(c) Subsurface temperature"
res@cnMaxLevelValF         =      0.0030
res@cnMinLevelValF         =      -0.0030
res@cnLevelSpacingF        =       0.0003
plot(2)=gsn_csm_contour_map(wks,sub_temp3,res)
res@gsnCenterString        =   "(d) Subsurface salinity"
plot(3)=gsn_csm_contour_map(wks,sub_sal3,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 5
pres@gsnPanelMainString=""
pres@gsnPanelMainFontHeightF=0.023
;pres@gsnPanelTop       = 0.9
;pres@gsnPanelBottom       = 0.15
;pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/2,2/),pres)
frame(wks)


end
