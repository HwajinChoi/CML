begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3 (5N-5S, 150W-90W)-----------------------------------------------------------------------
nino3_lon_min=-150
nino3_lon_max=-90
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;-----------------NINO4 (5N-5S, 160E-150W); It is neended to lonflip--------------------------------------------
nino4_lon_min=160
nino4_lon_max=210
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
rad    = 4.0*atan(1.0)/180.0
clat1   = cos(lat_oisst*rad)
;--------------------------------------------------------------------------------------------
oisst_nino3=oisst(:,:,{nino3_lon_min:nino3_lon_max})
oisst_nino34=oisst(:,:,{nino34_lon_min:nino34_lon_max})
oisst_nino4=oisst_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
oisst_nino3_wgt = wgt_areaave_Wrap(oisst_nino3,clat1,1.0,1)
oisst_nino34_wgt = wgt_areaave_Wrap(oisst_nino34,clat1,1.0,1)
oisst_nino4_wgt = wgt_areaave_Wrap(oisst_nino4,clat1,1.0,1)
oisst_nino3_wgt!0="time_counter"
oisst_nino34_wgt!0="time_counter"
oisst_nino4_wgt!0="time_counter"
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
tos_clim_nino3=tos_clim(:,:,{nino3_lon_min:nino3_lon_max})
tos_clim_nino34=tos_clim(:,:,{nino34_lon_min:nino34_lon_max})
tos_clim_nino4=tos_clim_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
tos_clim_nino3_wgt = wgt_areaave_Wrap(tos_clim_nino3,clat2,1.0,1)
tos_clim_nino34_wgt = wgt_areaave_Wrap(tos_clim_nino34,clat2,1.0,1)
tos_clim_nino4_wgt = wgt_areaave_Wrap(tos_clim_nino4,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h1=addfile(dir2+"tos_regrid_const_199710-201112.nc","r")
tos_const_raw=h1->tos(3:170,{lat_min:lat_max},:)
tos_const_mon=clmMonTLL(tos_const_raw)
tos_const=calcMonAnomTLL(tos_const_raw,tos_const_mon)
tos_const_lonflip = lonFlip(tos_const)
tos_const_nino3=tos_const(:,:,{nino3_lon_min:nino3_lon_max})
tos_const_nino34=tos_const(:,:,{nino34_lon_min:nino34_lon_max})
tos_const_nino4=tos_const_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
tos_const_nino3_wgt = wgt_areaave_Wrap(tos_const_nino3,clat2,1.0,1)
tos_const_nino34_wgt = wgt_areaave_Wrap(tos_const_nino34,clat2,1.0,1)
tos_const_nino4_wgt = wgt_areaave_Wrap(tos_const_nino4,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h2=addfile(dir2+"tos_regrid_inter_199710-201112.nc","r")
tos_inter_raw=h2->tos(3:170,{lat_min:lat_max},:)
tos_inter_mon=clmMonTLL(tos_inter_raw)
tos_inter=calcMonAnomTLL(tos_inter_raw,tos_inter_mon)
tos_inter_lonflip = lonFlip(tos_inter)
tos_inter_nino3=tos_inter(:,:,{nino3_lon_min:nino3_lon_max})
tos_inter_nino34=tos_inter(:,:,{nino34_lon_min:nino34_lon_max})
tos_inter_nino4=tos_inter_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
tos_inter_nino3_wgt = wgt_areaave_Wrap(tos_inter_nino3,clat2,1.0,1)
tos_inter_nino34_wgt = wgt_areaave_Wrap(tos_inter_nino34,clat2,1.0,1)
tos_inter_nino4_wgt = wgt_areaave_Wrap(tos_inter_nino4,clat2,1.0,1)
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

EL=(el98+el03+el10)/3
copy_VarMeta(el98,EL)

mon=ispan(1,23,1)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("x11",dir3+"bar_xy_nino34_AVE_SST_timeseries_OISST_models")        ; send graphics to PNG file
  xy_plot=new(1,graphic)
  bar_plot=new(1,graphic)
  res                          = True
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  res@tmXBFormat = "f"        ; remove the trailing ".0" 
  res@trYMinF                  = -2
  res@trYMaxF                  =2
  res@tmYLMode          = "Manual"
  res@tmYLTickSpacingF  =  1
  res@tmYLTickStartF    = -2 
  res@tmYLTickEndF      = 2
  res@tmYLMinorPerMajor=4
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
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
  res@gsnCenterString 	="NINO34 SST "
  res@gsnCenterStringFontHeightF=0.024
  res@tmXBMode   = "Explicit"
  res@tmXBValues = mon(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/" Feb "," May "," Aug "," Nov ","Feb "," May "," Aug "," Nov "/)
  xy_plot = gsn_csm_xy(wks,mon,EL(1:3,:),res)

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
  bres@gsnXYBarChartBarWidth = 0.55
  bres@gsnXYBarChartColors   = "black"        ; Color for bars
  bar_plot= gsn_csm_xy (wks,mon,EL(0,:),bres)
  overlay(xy_plot,bar_plot)

  lineres = True
  lineres@lgPerimDashSegLenF=0.01
  lineres@lgMonoItemType     = False
  lineres@lgMonoLineDashSegLen=False
  lineres@lgLineLabelConstantSpacingF=0.1
  lineres@lgMonoLineThickness =False
  lineres@lgLabelFontHeightF =0.080
  lineres@vpWidthF           = 0.10 
  lineres@lgDashIndexes=(/0,0,0/)
  lineres@vpHeightF          = 0.08 
  lineres@lgItemTypes=(/"MarkLines","MarkLines","MarkLines"/)
  lineres@lgMarkerIndexes    =(/16,16,16/) 
  lineres@lgLineColors = (/"red","blue","green"/) ; line colors
  lineres@lgMarkerColors = (/"red","blue","green"/) ; line colors
  lineres@lgLineThicknesses = (/5,5,5/)                        ; line thicknesses
  lineres@lgLineLabelFontThicknessF=(/5,5,5/)
  lineres@lgMonoMarkerThickness=False
  lineres@lgMarkerThicknesses=(/1,1,1/)
  lineres@lgPerimOn              = False
  lineres@LineLengthPercent = 5
  labels = (/"CLIM","CONST","INTER"/)  ; legend labels (required)
  gsn_legend_ndc(wks,3,labels,0.79,0.8,lineres)
  lbres                    = True          ; labelbar only resources
  lbres@vpWidthF           = 0.08      ; labelbar width
  lbres@vpHeightF          = 0.02      ; labelbar height
  lbres@lbBoxMajorExtentF  = 0.75          ; puts space between color boxes
  lbres@lbFillColors       = "black" ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.012         ; font height. default is small
  lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
  gsn_labelbar_ndc(wks,1,"OISST",0.7,0.792,lbres)

  draw(xy_plot)
  frame(wks)

end
