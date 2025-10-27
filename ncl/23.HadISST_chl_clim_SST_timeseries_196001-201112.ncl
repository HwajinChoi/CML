begin
dir1="/media/cmlws/Data2/hjc/HadISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir3="/media/cmlws/Data2/hjc/image/"
dir4="/media/cmlws/Data2/hjc/OISST/"

f=addfile(dir1+"HadISST_sst_r180x360_196101-201112.nc","r") 
had_raw=f->sst
had=month_to_annual(had_raw,1)
time=f->time
lat_had=f->latitude
lon_had=f->longitude
;--------------------- HadISST missing; values <= -1.8 --------------------------------
had_masked=where(had .le. -1.8,had@_FillValue,had)
copy_VarMeta(had,had_masked)
;--------------------------------------------------------------------------------------
g=addfile(dir2+"tos_regrid_clim_196101-201112.nc","r")
tos_raw=g->tos
tos=month_to_annual(tos_raw,1)
lat_tos=g->lat
;--------------------------------------------------------------------------------------
h=addfile(dir4+"oisst-avhrr-v02r01.r180x90.198201-201112.nc","r")
oisst_raw=h->sst(:,0,:,:)
oisst2 = short2flt(oisst_raw)
oisst=month_to_annual(oisst2,1)
lat_oisst=h->lat
lon_oisst=h->lon
;----------------------------------area average------------------------------------------------
rad    = 4.0*atan(1.0)/180.0
re     = 6371220.0
clat1   = cos(lat_had*rad)
clat2   = cos(lat_tos*rad)
clat3   = cos(lat_oisst*rad)
had_wgt = wgt_areaave_Wrap(had_masked,clat1,1.0,1)
tos_clim_wgt = wgt_areaave_Wrap(tos,clat2,1.0,1)
oisst_wgt=wgt_areaave_Wrap(oisst,clat3,1.0,1)

dim=dimsizes(had_wgt)
SST=new((/3,dim(0)/),"float") 
SST=SST@_FillValue
SST(0,:)=had_wgt
SST(1,:)=tos_clim_wgt
SST(2,21:dim(0)-1)=oisst_wgt
SST!0="data"

year=ispan(1961,2011,2)
year2=ispan(1961,2011,1)

 wks = gsn_open_wks("x11",dir3+"HadISST_OISST_chl_clim_SST_timeseries_1961-2011")             ; send graphics to PNG file
  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
  res@trXMaxF            = 2011
  res@trXMinF            = 1960              ; set x-axis minimum
  res@trYMinF            = 17.5              ; set x-axis minimum
  res@trYMaxF            = 20
  res@tmYLMode           = "Manual"
  res@tmYLTickSpacingF   =  0.5
  res@tmYLTickStartF     =  17.5
  res@tmYLTickEndF       =20 
  res@tmYLMinorPerMajor=4
;---------For anomaly----------
;  res@gsnYRefLine       =0
;  res@gsnYRefLineColor = "gray50"
;  res@gsnYRefLineDashPattern=1
;-------------------------------
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = (/"Black","Red","purple"/) ; colors chosen
  res@xyLineThicknesses  = (/3.,3.,3./)      ; line thicknesses
  res@xyDashPatterns     = (/0.,0.,0./)      ; make all lines solid
  res@tiYAxisString      = "~F35~J~F~C"      ; add an axis title
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@tmXBMode          = "Manual"
  res@tmXBMinorPerMajor=4
;  res@tmXBValues        = year
;  res@tmXBLabels        = year
  res@tmXBTickSpacingF=10
  res@tmXBTickStartF=1960
  res@tmXBTickEndF=2011
  res@tiMainString="Global annual SST (1961-2011)"
  plot = gsn_csm_xy (wks,year2,SST,res)       ; create line plot
;  plot = gsn_csm_xy (wks,year2,SST_wgt,res)       ; create line plot
 gres = True
  gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend
  gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres = True
  lineres@lgLineColors = (/"black","red","purple"/) ; line colors
  lineres@lgLineThicknesses = 3                        ; line thicknesses
  lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
  textres = True
  textres@lgLabels = (/"HadISST","CLIM","OISST"/)  ; legend labels (required)
  plot = simple_legend(wks,plot,gres,lineres,textres)

 draw(plot)    ; This will draw all three curves
 frame(wks)



end
