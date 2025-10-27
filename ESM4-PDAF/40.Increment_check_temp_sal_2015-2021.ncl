begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"                                                                                                                    
g=addfile(dir1+"tos.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
tos=g->tos

g1=addfile(dir1+"thetao-300m.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
thetao=g1->thetao(:,1:10,:,:)

g2=addfile(dir1+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
surf_so=g2->so(:,0,:,:)
sub_so=g2->so(:,{10:300},:,:)

f0=addfile(dir1+"surface_ocn_model_BG_increment_201501-202112_ensmean.1x1.new.nc","r")
surf_temp=f0->bgtemp(:,0,:,:)
surf_sal=f0->bgsalt(:,0,:,:)
surf_temp@_FillValue=9.969209968386869e+36
surf_sal@_FillValue=9.969209968386869e+36
surf_temp2=where(surf_temp .ge. 100,surf_temp@_FillValue,surf_temp)
surf_sal2=where(surf_sal .ge. 100,surf_sal@_FillValue,surf_sal)
copy_VarMeta(surf_temp,surf_temp2)
copy_VarMeta(surf_sal,surf_sal2)

tos_incre=tos-surf_temp2
so_surf_incre=surf_so-surf_sal2
copy_VarMeta(surf_temp,tos_incre)
copy_VarMeta(surf_so,so_surf_incre)
tos_incre2=dim_avg_n_Wrap(tos_incre,0)
so_surf_incre2=dim_avg_n_Wrap(so_surf_incre,0)


f1=addfile(dir1+"subsurface_ocn_model_BG_increment_201501-202112_ensmean.1x1.new.nc","r")
sub_temp=f1->bgtemp(:,1:10,:,:)
sub_sal=f1->bgsalt(:,1:10,:,:)
sub_temp@_FillValue=9.969209968386869e+36
sub_sal@_FillValue=9.969209968386869e+36
sub_temp1=where(sub_temp .ge. 100,sub_temp@_FillValue,sub_temp)
sub_sal1=where(sub_sal .ge. 100,sub_sal@_FillValue,sub_sal)
copy_VarMeta(sub_temp,sub_temp1)
copy_VarMeta(sub_sal,sub_sal1)

sub_temp_incre=thetao-sub_temp1
sub_so_incre=sub_so-sub_sal1
copy_VarMeta(thetao,sub_temp_incre)
copy_VarMeta(sub_so,sub_so_incre)
sub_temp_incre2=dim_avg_n_Wrap(sub_temp_incre,0)
sub_so_incre2=dim_avg_n_Wrap(sub_so_incre,0)
sub_temp_incre3=dim_avg_n_Wrap(sub_temp_incre2,0)
sub_so_incre3=dim_avg_n_Wrap(sub_so_incre2,0)


plot=new(4,graphic)
wks=gsn_open_wks("png",dir0+"figure3_increment_check_temp_sau_surf_sub_2015-2021")
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
res@cnMaxLevelValF         =      0.20
res@cnMinLevelValF         =      -0.20
res@cnLevelSpacingF        =       0.02
plot(0)=gsn_csm_contour_map(wks,tos_incre2,res)
res@cnMaxLevelValF         =      0.0030
res@cnMinLevelValF         =      -0.0030
res@cnLevelSpacingF        =       0.0003
res@gsnCenterString        =   "(b) Surface salinity"
plot(1)=gsn_csm_contour_map(wks,so_surf_incre2,res)
;res@lbTitleString    = "~S~o~N~C"                ; title string
res@cnMaxLevelValF         =      0.030
res@cnMinLevelValF         =      -0.030
res@cnLevelSpacingF        =       0.003
res@gsnCenterString        =   "(c) Subsurface temperature"
plot(2)=gsn_csm_contour_map(wks,sub_temp_incre3,res)
res@cnMaxLevelValF         =      0.0030
res@cnMinLevelValF         =      -0.0030
res@cnLevelSpacingF        =       0.0003
res@gsnCenterString        =   "(d) Subsurface salinity"
plot(3)=gsn_csm_contour_map(wks,sub_so_incre3,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 5
pres@gsnPanelMainString="Model - Background"
pres@gsnPanelMainFontHeightF=0.023
;pres@gsnPanelTop       = 0.9
;pres@gsnPanelBottom       = 0.15
;pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/2,2/),pres)
frame(wks)


end
