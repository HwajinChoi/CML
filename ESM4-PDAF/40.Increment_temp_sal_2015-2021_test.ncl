begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"                                                                                                                    
f0=addfile(dir1+"surface_increment_ocn_model_increment_201501-202112_ensmean.1x1.new.nc","r")
surf_temp=f0->tempinc(:,0,:,:)
surf_temp@_FillValue=9.969209968386869e+36
lat=f0->lat
lon=f0->lon
surf_sal=f0->saltinc(:,0,:,:)
surf_sal@_FillValue=9.969209968386869e+36
surf_temp=surf_temp*6
surf_sal=surf_sal*6

b2 = addfile(file11,"r")
lsm_t85  = landsea_mask(b2->LSMASK,lat,lon)

surf_temp2=where(surf_temp .ge. 100,surf_temp@_FillValue,surf_temp)
surf_sal2=where(surf_sal .ge. 100,surf_sal@_FillValue,surf_sal)
copy_VarMeta(surf_temp,surf_temp2)
copy_VarMeta(surf_sal,surf_sal2)

surf_temp22=where(surf_temp2 .eq. 0, surf_temp2@_FillValue,surf_temp2)
surf_sal22=where(surf_sal2 .eq. 0, surf_sal2@_FillValue,surf_sal2)

copy_VarMeta(surf_temp,surf_temp22)
copy_VarMeta(surf_sal,surf_sal22)
surf_temp3=dim_avg_n_Wrap(surf_temp22,0)
surf_sal3=dim_avg_n_Wrap(surf_sal22,0)

surf_temp33 = mask(surf_temp3,lsm_t85.eq.1,False)
surf_sal33 = mask(surf_sal3,lsm_t85.eq.1,False)
copy_VarMeta(surf_sal3,surf_sal33)
copy_VarMeta(surf_temp3,surf_temp33)

f1=addfile(dir1+"subsurface-100m_increment_ocn_model_increment_201501-202112_ensmean.1x1.new.nc","r")
sub_temp=f1->tempinc
sub_sal=f1->saltinc
sub_temp@_FillValue=9.969209968386869e+36
sub_sal@_FillValue=9.969209968386869e+36

sub_temp=sub_temp*6
sub_sal=sub_sal*6
sub_temp1=where(sub_temp .ge. 100,sub_temp@_FillValue,sub_temp)
sub_sal1=where(sub_sal .ge. 100,sub_sal@_FillValue,sub_sal)
copy_VarMeta(sub_temp,sub_temp1)
copy_VarMeta(sub_sal,sub_sal1)

sub_temp2=where(sub_temp1 .eq. 0, sub_temp1@_FillValue,sub_temp1)
sub_sal2=where(sub_sal1 .eq. 0, sub_sal1@_FillValue,sub_sal1)
copy_VarMeta(sub_temp,sub_temp2)
copy_VarMeta(sub_sal,sub_sal2)

sub_temp22=dim_avg_n_Wrap(sub_temp2,0)
sub_sal22=dim_avg_n_Wrap(sub_sal2,0)
sub_temp3=dim_avg_n_Wrap(sub_temp22,0)
sub_sal3=dim_avg_n_Wrap(sub_sal22,0)

sub_temp33 = mask(sub_temp3,lsm_t85.eq.1,False)
sub_sal33 = mask(sub_sal3,lsm_t85.eq.1,False)
copy_VarMeta(sub_sal3,sub_sal33)
copy_VarMeta(sub_temp3,sub_temp33)

plot=new(4,graphic)
wks=gsn_open_wks("png",dir0+"figure3_nan_increment_temp_sau_surf_sub_2015-2021")
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
res@lbLabelStride     =   5
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
res@cnMaxLevelValF         =      2.5
res@cnMinLevelValF         =      -2.5
res@cnLevelSpacingF        =       0.25
plot(0)=gsn_csm_contour_map(wks,surf_temp33,res)
;res@lbLabelStride     =   4
res@cnMaxLevelValF         =      0.01
res@cnMinLevelValF         =      -0.01
res@cnLevelSpacingF        =       0.001
res@gsnCenterString        =   "(b) Surface salinity"
plot(1)=gsn_csm_contour_map(wks,surf_sal33,res)
;res@lbLabelStride     =   4
;res@lbTitleString    = "~S~o~N~C"                ; title string
res@gsnCenterString        =   "(c) Subsurface temperature"
res@cnMaxLevelValF         =      0.05
res@cnMinLevelValF         =      -0.05
res@cnLevelSpacingF        =       0.005
plot(2)=gsn_csm_contour_map(wks,sub_temp33,res)
;res@lbLabelStride     =   4
res@cnMaxLevelValF         =      0.01
res@cnMinLevelValF         =      -0.01
res@cnLevelSpacingF        =       0.001
res@gsnCenterString        =   "(d) Subsurface salinity"
plot(3)=gsn_csm_contour_map(wks,sub_sal33,res)

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
