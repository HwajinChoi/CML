load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir3="/media/cmlws/Data2/hjc/image/"
dir4="/media/cmlws/Data2/hjc/satellite/seawifs_modis/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;-----------------------------------------------------------------------------------------------
rad    = 4.0*atan(1.0)/180.0
;-----------------------------------------------------------------------------------------------
k=addfile(dir4+"chl_r180x90_199710-202112.nc","r")
chl_raw=k->chlor_a(3:290,:,:)
chl_mon=clmMonTLL(chl_raw)
chl=calcMonAnomTLL(chl_raw,chl_mon)
lat_chl=k->lat({lat_min:lat_max})
clat0=cos(lat_chl*rad)

chl_98=chl(1:23,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
chl_03=chl(61:83,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
chl_10=chl(145:167,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})

chl98_nino34_wgt = wgt_areaave_Wrap(chl_98,clat0,1.0,1)
chl03_nino34_wgt = wgt_areaave_Wrap(chl_03,clat0,1.0,1)
chl10_nino34_wgt = wgt_areaave_Wrap(chl_10,clat0,1.0,1)
;-------------------------------------------OISST-------------------------------------------
f=addfile(dir1+"oisst-avhrr-v02r01.r180x90.199801-201112.nc","r")
sst=f->sst(:,0,{lat_min:lat_max},:)
oisst_flt = short2flt(sst);time*lat*lon
oisst_mon=clmMonTLL(oisst_flt)
oisst = calcMonAnomTLL (oisst_flt,oisst_mon)

dim0=dimsizes(oisst_flt)
oisst_lonflip = lonFlip(oisst)
lat_oisst=f->lat({lat_min:lat_max})
lon_oisst=f->lon
clat1   = cos(lat_oisst*rad)
;--------------------------------------------------------------------------------------------
oisst_nino34=oisst(:,:,{nino34_lon_min:nino34_lon_max})
oisst_nino34_wgt = wgt_areaave_Wrap(oisst_nino34,clat1,1.0,1)
oisst_nino34_wgt!0="time_counter"
;---------------------------------------------------------------------------------------------
g2=addfile(dir2+"tos_regrid_clim_199710-201112.nc","r")
tos_clim_raw=g2->tos(3:170,{lat_min:lat_max},:)
lon_nemo=g2->lon
lat_nemo=g2->lat({lat_min:lat_max})
tos_clim_mon=clmMonTLL(tos_clim_raw)
tos_clim=calcMonAnomTLL(tos_clim_raw,tos_clim_mon)
;--------------------------------------------------------------------------------------------
dim1=dimsizes(tos_clim_raw)
tos_clim_lonflip = lonFlip(tos_clim)
clat2   = cos(lat_nemo*rad)
tos_clim_nino34=tos_clim(:,:,{nino34_lon_min:nino34_lon_max})
tos_clim_nino34_wgt = wgt_areaave_Wrap(tos_clim_nino34,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h1=addfile(dir2+"tos_regrid_const_199710-201112.nc","r")
tos_const_raw=h1->tos(3:170,{lat_min:lat_max},:)
tos_const_mon=clmMonTLL(tos_const_raw)
tos_const=calcMonAnomTLL(tos_const_raw,tos_const_mon)
tos_const_lonflip = lonFlip(tos_const)
tos_const_nino34=tos_const(:,:,{nino34_lon_min:nino34_lon_max})
tos_const_nino34_wgt = wgt_areaave_Wrap(tos_const_nino34,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h2=addfile(dir2+"tos_regrid_inter_199710-201112.nc","r")
tos_inter_raw=h2->tos(3:170,{lat_min:lat_max},:)
tos_inter_mon=clmMonTLL(tos_inter_raw)
tos_inter=calcMonAnomTLL(tos_inter_raw,tos_inter_mon)
tos_inter_lonflip = lonFlip(tos_inter)
tos_inter_nino34=tos_inter(:,:,{nino34_lon_min:nino34_lon_max})
tos_inter_nino34_wgt = wgt_areaave_Wrap(tos_inter_nino34,clat2,1.0,1)
;----------------------------------area average------------------------------------------------
dim=dimsizes(tos_const)
SST_nino34_wgt=new((/4,dim(0)/),"float")
SST_nino34_wgt(0,:)=oisst_nino34_wgt
SST_nino34_wgt(1,:)=tos_clim_nino34_wgt
SST_nino34_wgt(2,:)=tos_const_nino34_wgt
SST_nino34_wgt(3,:)=tos_inter_nino34_wgt
SST_nino34_wgt!0="data"

;start=12*(x-1998)
;end=12*(x-1998)+23
el98=SST_nino34_wgt(:,1:23);data(oisst,clim,const,inter)
el03=SST_nino34_wgt(:,61:83);data(oisst,clim,const,inter)
el10=SST_nino34_wgt(:,145:167);data(oisst,clim,const,inter)

time=g2->time_counter(3:170)
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y98=yfrac(1:23)
y03=yfrac(61:83)
y10=yfrac(145:167)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("x11",dir3+"bar_xy_nino34_CHL_SST_timeseries_OISST_models_98_03_10")        ; send graphics to PNG file
  xy_plot=new(3,graphic)
  bar_plot=new(3,graphic)
  resR				=True
  resR@tmYRMode="Manual"
  resR@tmYRTickSpacingF=0.05
  resR@tmYRTickStartF=0.15
  resR@tmYRMinorPerMajor=4
  resR@tmYRTickEndF=-0.15
  resR@xyDashPattern         = 1
  resR@xyLineThicknesses      = 4 
  resR@trYMaxF           =   0.15
  resR@trYMinF           =-0.15
  resR@xyLineColor="darkgreen"
  resR@xyMarkerColor=resR@xyLineColor
  resR@tiYAxisString      = "mg / m~S~3~N"      ; add an axis title
  resR@xyMarkLineMode      ="MarkLines"
  resR@xyMarker=3
  resR@xyMarkerThicknessF=3
  res                          = True
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  res@tmXBFormat = "f"        ; remove the trailing ".0" 
  res@trYMinF                  = -3
  res@trYMaxF                  =3
  res@tmYLMode          = "Manual"
  res@tmYLTickSpacingF  =  1
  res@tmYLTickStartF    = -3 
  res@tmYLTickEndF      = 3
  res@tmYLMinorPerMajor=4
  res@vpHeightF          = 0.45              ; change aspect ratio of plot
  res@vpWidthF           = 0.85
  res@gsnYRefLine       =0
  res@gsnYRefLineColor = "black"
  res@gsnYRefLineDashPattern=0
  res@xyMarkLineModes      =(/"MarkLines","MarkLines","MarkLines"/)
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = (/"Red","Blue","Green"/) ; colors chosen
  res@xyMarkerColors=(/"Red","Blue","Green"/)
  res@xyMarkerThicknesses    = (/3.,3.,3./)      ; line thicknesses
  res@xyLineThicknesses    = (/4.,4.,4./)      ; line thicknesses
  res@xyMarkers=(/16,16,16/)
  res@xyDashPatterns     = (/0.,0.,0./)      ; make all lines solid
  res@tiYAxisString      = "~F35~J~F~C"      ; add an axis title
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@gsnCenterString 	="NINO34 SST (1998)"
  res@gsnCenterStringFontHeightF=0.030
  res@tmXBMode   = "Explicit"
  res@tmXBValues = y98(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/" Feb ~C~1998"," May ~C~1998"," Aug ~C~1998"," Nov ~C~1998","Feb ~C~1999", \
                     " May ~C~1999"," Aug ~C~1999"," Nov ~C~1999"/)
  xy_plot(0) = gsn_csm_xy2(wks,y98,el98(1:3,:),chl98_nino34_wgt,res,resR)
  resR@trYMaxF           =   0.05
  resR@trYMinF           =-0.05
  res2=res
  res2@gsnCenterString 	="NINO34 SST (2003)"
  res2@tmYLTickStartF    =-2
  res2@tmYLTickEndF      = 2
  res2@trYMinF                  = -2
  res2@trYMaxF                 =2
  res2@tmXBValues = y03(::3)     ; choose first 13 timesteps
  res2@tmXBLabels = (/" Feb ~C~2003"," May ~C~2003"," Aug ~C~2003"," Nov ~C~2003","Feb ~C~2004", \
                     " May ~C~2004"," Aug ~C~2004"," Nov ~C~2004"/)
  xy_plot(1) = gsn_csm_xy2(wks,y03,el03(1:3,:),chl03_nino34_wgt,res2,resR)
  resR@trYMaxF           =   0.15
  resR@trYMinF           =-0.15
  res3=res
  res3@gsnCenterString 	="NINO34 SST (2010)"
  res3@trYMinF                  = -3
  res3@trYMaxF                  =3
  res3@tmYLTickStartF    =-3
  res3@tmYLTickEndF      = 3
  res3@tmXBValues = y10(::3)     ; choose first 13 timesteps
  res3@tmXBLabels = (/" Feb ~C~2010"," May ~C~2010"," Aug ~C~2010"," Nov ~C~2010","Feb ~C~2011", \
                     " May ~C~2011"," Aug ~C~2011"," Nov ~C~2011"/)
  xy_plot(2) = gsn_csm_xy2(wks,y10,el10(1:3,:),chl10_nino34_wgt,res3,resR)

  bres			=True
  bres@gsnDraw                  = False
  bres@gsnFrame                 = False
  bres@trYMinF                  = -4
  bres@trYMaxF                  =4
  bres@vpHeightF          = 0.4               ; change aspect ratio of plot
  bres@vpWidthF           = 0.7
  bres@gsnYRefLine       =0
  bres@gsnYRefLineColor = "black"
  bres@gsnYRefLineDashPattern=0
  bres@gsnXYBarChart         = True            ; Turn on bar chart
  bres@gsnXYBarChartBarWidth = 0.05
  bres@gsnXYBarChartColors   = "black"        ; Color for bars
  bar_plot(0)= gsn_csm_xy (wks,y98,el98(0,:),bres)
  bar_plot(1) = gsn_csm_xy(wks,y03,el03(0,:),bres)
  bar_plot(2) = gsn_csm_xy(wks,y10,el10(0,:),bres)
  overlay(xy_plot(0),bar_plot(0))
  overlay(xy_plot(1),bar_plot(1))
  overlay(xy_plot(2),bar_plot(2))

  lineres = True
  lineres@lgPerimDashSegLenF=0.01
  lineres@lgMonoItemType     = False
  lineres@lgMonoLineDashSegLen=False
  lineres@lgLineLabelConstantSpacingF=0.1
  lineres@lgMonoLineThickness =False
  lineres@lgLabelFontHeightF =0.055
  lineres@vpWidthF           = 0.10 
  lineres@lgDashIndexes=(/0,0,0/)
  lineres@vpHeightF          = 0.08 
  lineres@lgItemTypes=(/"MarkLines","MarkLines","MarkLines"/)
  lineres@lgMarkerIndexes    =(/16,16,16/) 
  lineres@lgLineColors = (/"red","blue","green"/) ; line colors
  lineres@lgMarkerColors = (/"red","blue","green"/) ; line colors
  lineres@lgLineThicknesses = (/4,4,4/)                        ; line thicknesses
  lineres@lgLineLabelFontThicknessF=(/4,4,4/)
  lineres@lgMonoMarkerThickness=False
  lineres@lgMarkerThicknesses=(/1,1,1/)
  lineres@lgPerimOn              = False
  lineres@LineLengthPercent = 5
  labels = (/"CLIM","CONST","INTER"/)  ; legend labels (required)
  gsn_legend_ndc(wks,3,labels,0.59,0.958,lineres)
  gsn_legend_ndc(wks,3,labels,0.59,0.482,lineres)
  gsn_legend_ndc(wks,3,labels,0.59,0.29,lineres)
  lbres                    = True          ; labelbar only resources
  lbres@vpWidthF           = 0.08      ; labelbar width
  lbres@vpHeightF          = 0.02      ; labelbar height
  lbres@lbBoxMajorExtentF  = 0.75          ; puts space between color boxes
  lbres@lbFillColors       = "black" ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.008         ; font height. default is small
  lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
  gsn_labelbar_ndc(wks,1,"OISST",0.51,0.949,lbres)
  gsn_labelbar_ndc(wks,1,"OISST",0.51,0.430,lbres)
  gsn_labelbar_ndc(wks,1,"OISST",0.51,0.281,lbres)

  lin = True
  lin@lgPerimDashSegLenF=0.01
  lin@lgMonoItemType     = True
  lin@lgMonoLineDashSegLen=True
  lin@lgMonoDashIndex =True
  lin@lgMonoMarkerColor=True
  lin@lgMonoLineColor=True
  lin@lgMonoMarkerThickness=True
  lin@lgMonoMarkerSize=True
  lin@lgLineLabelConstantSpacingF=0.1
  lin@lgMonoLineThickness =True
  lin@lgLabelFontHeightF =0.055
  lin@vpWidthF           = 0.10 
  lin@lgDashIndex=1
  lin@vpHeightF          = 0.08 
  lin@lgItemType="MarkLines"
  lin@lgMarkerIndex =3
  lin@lgLineColor ="Darkgreen"
  lin@lgMarkerColor = "Darkgreen"
  lin@lgLineThicknessF = 4                        ; line thicknesses
  lin@lgLineLabelFontThicknessF=4
  lin@lgMonoMarkerThickness=True
  lin@lgMarkerThicknessF=3
  lin@lgPerimOn              = False
  lin@LineLengthPercent = 5
  label = (/"CHL"/)  ; legend labels (required)
  gsn_legend_ndc(wks,1,label,0.5,0.958,lin)
  gsn_legend_ndc(wks,1,label,0.5,0.482,lin)
  gsn_legend_ndc(wks,1,label,0.5,0.29,lin)

  pres                       =   True
  pres@gsnFrame         = False
  pres@gsnPanelLabelBar      = False
  pres@gsnMaximize        =       False
  pres@gsnPanelYWhiteSpacePercent = 4
  gsn_panel(wks,xy_plot,(/3,1/),pres)
  frame(wks)

end
