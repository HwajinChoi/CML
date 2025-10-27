begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir3="/media/cmlws/Data2/hjc/image/"
;-------------------------------------------OISST-------------------------------------------
f=addfile(dir1+"oisst-avhrr-v02r01.r180x90.199801-201112.nc","r")
sst=f->sst(0:,0,:,:)
oisst = short2flt(sst)
lat_oisst=f->lat
lon_oisst=f->lon
;---------------------------------------------------------------------------------------------
g2=addfile(dir2+"tos_regrid_clim_199710-201112.nc","r")
tos_clim=g2->tos(3:170,:,:)
lon_nemo=g2->lon
lat_nemo=g2->lat
time=g2->time_counter(3:170)
h1=addfile(dir2+"tos_regrid_const_199710-201112.nc","r")
tos_const=h1->tos(3:170,:,:)
h2=addfile(dir2+"tos_regrid_inter_199710-201112.nc","r")
tos_inter=h2->tos(3:170,:,:)
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
dim=dimsizes(tos_const)
;----------------------------------area average------------------------------------------------
rad    = 4.0*atan(1.0)/180.0
re     = 6371220.0
clat1   = cos(lat_oisst*rad)
clat2   = cos(lat_nemo*rad)

oisst_wgt = wgt_areaave_Wrap(oisst,clat1,1.0,1)
oisst_wgt!0="time_counter"
tos_clim_wgt = wgt_areaave_Wrap(tos_clim,clat2,1.0,1)
tos_const_wgt = wgt_areaave_Wrap(tos_const,clat2,1.0,1)
tos_inter_wgt = wgt_areaave_Wrap(tos_inter,clat2,1.0,1)

SST_wgt=new((/4,dim(0)/),"float")
SST_wgt(0,:)=oisst_wgt
SST_wgt(1,:)=tos_clim_wgt
SST_wgt(2,:)=tos_const_wgt
SST_wgt(3,:)=tos_inter_wgt
SST_wgt!0="data"
;------make anomaly---
clim=dim_avg_n_Wrap(SST_wgt,1)
SST_clim=new((/4,dim(0)/),"float")
  do i=0,dim(0)-1
   SST_clim(:,i)=clim
  end do
copy_VarMeta(SST_wgt,SST_clim)
SST_ano=SST_wgt-SST_clim
copy_VarMeta(SST_wgt,SST_ano)
year=ispan(1998,2011,2)
year2=ispan(1998,2011,1)
;--------------------------------------------------------------------------------------------------
 wks = gsn_open_wks("x11",dir3+"SST_timeseries_OISST_NEMOs_199710-201112")             ; send graphics to PNG file
  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet
  res@vpHeightF 	 = 0.4               ; change aspect ratio of plot
  res@vpWidthF 	         = 0.7
  res@trXMaxF            = 2011
  res@trXMinF	         = 1998              ; set x-axis minimum
  res@trYMinF	         = 17.5              ; set x-axis minimum
  res@trYMaxF            = 19
  res@tmYLMode		 = "Manual"
  res@tmYLTickSpacingF	 =  0.5
  res@tmYLTickStartF 	 =  17.5
  res@tmYLTickEndF	 = 19
  res@tmYLMinorPerMajor=4
;---------For anomaly----------
;  res@gsnYRefLine       =0 
;  res@gsnYRefLineColor = "gray50"
;  res@gsnYRefLineDashPattern=1
;-------------------------------
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = (/"Black","Red","Blue","Green"/) ; colors chosen
  res@xyLineThicknesses	 = (/3.,3.,3.,3./)      ; line thicknesses
  res@xyDashPatterns	 = (/0.,0.,0./)      ; make all lines solid
  res@tiYAxisString	 = "~F35~J~F~C"      ; add an axis title    
  res@txFontHeightF	 = 0.0195            ; change title font heights
  res@tmXBMode          = "Explicit"
  res@tmXBValues        = year
  res@tmXBLabels        = year 
  res@tiMainString="Global monthly SST (1998-2011)"
;  plot = gsn_csm_xy (wks,yfrac,SST_ano,res)       ; create line plot
  plot = gsn_csm_xy (wks,yfrac,SST_wgt,res)       ; create line plot

  gres = True
  gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend 
  gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres = True
  lineres@lgLineColors = (/"black","red"/) ; line colors
  lineres@lgLineThicknesses = 3                        ; line thicknesses
  lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
  textres = True
  textres@lgLabels = (/"OISST","CLIM"/)  ; legend labels (required)
  plot = simple_legend(wks,plot,gres,lineres,textres)
  gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend 
  gres@XPosPercent = 25      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres@lgLineColors = (/"blue","green"/) ; line colors
  textres@lgLabels = (/"CONST","INTER"/)  ; legend labels (required)

  plot = simple_legend(wks,plot,gres,lineres,textres)

 draw(plot)    ; This will draw all three curves
 frame(wks)

end
