begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir3="/media/cmlws/Data2/hjc/image/"
dir4="/media/cmlws/Data2/hjc/NEMO/r4.0.6/output_pro/"
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
rad    = 4.0*atan(1.0)/180.0
;--------------------------------------------------------------------------------------------
g2=addfile(dir4+"thermo_depth_clim_199710-201112.nc","r")
thermo_clim=g2->thermo(3:170,{lat_min:lat_max},:)
lon_nemo=g2->lon
lat_nemo=g2->lat({lat_min:lat_max})
thermo_clim_lonflip = lonFlip(thermo_clim)
clat2   = cos(lat_nemo*rad)
time=g2->time_counter(3:170)
thermo_clim_nino3=thermo_clim(:,:,{nino3_lon_min:nino3_lon_max})
thermo_clim_nino34=thermo_clim(:,:,{nino34_lon_min:nino34_lon_max})
thermo_clim_nino4=thermo_clim_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
thermo_clim_nino3_wgt = wgt_areaave_Wrap(thermo_clim_nino3,clat2,1.0,1)
thermo_clim_nino34_wgt = wgt_areaave_Wrap(thermo_clim_nino34,clat2,1.0,1)
thermo_clim_nino4_wgt = wgt_areaave_Wrap(thermo_clim_nino4,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h1=addfile(dir4+"thermo_depth_const_199710-201112.nc","r")
thermo_const=h1->thermo(3:170,{lat_min:lat_max},:)
thermo_const_lonflip = lonFlip(thermo_const)
thermo_const_nino3=thermo_const(:,:,{nino3_lon_min:nino3_lon_max})
thermo_const_nino34=thermo_const(:,:,{nino34_lon_min:nino34_lon_max})
thermo_const_nino4=thermo_const_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
thermo_const_nino3_wgt = wgt_areaave_Wrap(thermo_const_nino3,clat2,1.0,1)
thermo_const_nino34_wgt = wgt_areaave_Wrap(thermo_const_nino34,clat2,1.0,1)
thermo_const_nino4_wgt = wgt_areaave_Wrap(thermo_const_nino4,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h2=addfile(dir4+"thermo_depth_inter_199710-201112.nc","r")
thermo_inter=h2->thermo(3:170,{lat_min:lat_max},:)
thermo_inter_lonflip = lonFlip(thermo_inter)
thermo_inter_nino3=thermo_inter(:,:,{nino3_lon_min:nino3_lon_max})
thermo_inter_nino34=thermo_inter(:,:,{nino34_lon_min:nino34_lon_max})
thermo_inter_nino4=thermo_inter_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
thermo_inter_nino3_wgt = wgt_areaave_Wrap(thermo_inter_nino3,clat2,1.0,1)
thermo_inter_nino34_wgt = wgt_areaave_Wrap(thermo_inter_nino34,clat2,1.0,1)
thermo_inter_nino4_wgt = wgt_areaave_Wrap(thermo_inter_nino4,clat2,1.0,1)

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
dim=dimsizes(thermo_const)
;----------- For moving average ------------------------------------
y=5 ; moving year
p=y*12;chunck period
tp=dim(0)-p+1;total period after moving averaged 
;----------------------------------area average------------------------------------------------
SST_nino3_wgt=new((/3,dim(0)/),"float")
SST_nino3_wgt(0,:)=thermo_clim_nino3_wgt
SST_nino3_wgt(1,:)=thermo_const_nino3_wgt
SST_nino3_wgt(2,:)=thermo_inter_nino3_wgt
SST_nino3_wgt!0="data"
;-----------------------------------------------
sst_nino3_mv=new((/3,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck 
 do k=0,tp-1
  imsi(:,:)=SST_nino3_wgt(:,k:k+p-1)
  sst_nino3_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino3_mv!1="time"
sst_nino3_mv&time=time(0:tp-1)
;----------------------------------area average------------------------------------------------
SST_nino34_wgt=new((/3,dim(0)/),"float")
SST_nino34_wgt(0,:)=thermo_clim_nino34_wgt
SST_nino34_wgt(1,:)=thermo_const_nino34_wgt
SST_nino34_wgt(2,:)=thermo_inter_nino34_wgt
SST_nino34_wgt!0="data"
;-----------------------------------------------
sst_nino34_mv=new((/3,tp/),"float"); Target
 do k=0,tp-1
  imsi(:,:)=SST_nino34_wgt(:,k:k+p-1)
  sst_nino34_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino34_mv!1="time"
sst_nino34_mv&time=time(0:tp-1)
;----------------------------------area average------------------------------------------------
SST_nino4_wgt=new((/3,dim(0)/),"float")
SST_nino4_wgt(0,:)=thermo_clim_nino4_wgt
SST_nino4_wgt(1,:)=thermo_const_nino4_wgt
SST_nino4_wgt(2,:)=thermo_inter_nino4_wgt
SST_nino4_wgt!0="data"
;-----------------------------------------------
sst_nino4_mv=new((/3,tp/),"float"); Target
 do k=0,tp-1
  imsi(:,:)=SST_nino4_wgt(:,k:k+p-1)
  sst_nino4_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino4_mv!1="time"
sst_nino4_mv&time=time(0:tp-1)
;----------------------------------area average------------------------------------------------
year=ispan(1998,2007,2)
year2=ispan(1998,2007,1)
;--------------------------------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir3+"5moving_ENSO_Thermo_timeseries_NEMOs_199801-201112")             ; send graphics to PNG file
 plot=new(3,graphic)
  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet
  res@vpHeightF 	 = 0.4               ; change aspect ratio of plot
  res@vpWidthF 	         = 0.7
  res@trXMaxF            = 2007
  res@trXMinF	         = 1998              ; set x-axis minimum
  res@gsnLeftStringOrthogonalPosF=0.08
  res@gsnLeftStringFontHeightF=0.025
  res@tmYLMode		 = "Manual"
  res@tmYLTickSpacingF	 =  5
  res@tmYLTickStartF 	 =  65
  res@tmYLTickEndF	 = 90
  res@tmYLMinorPerMajor=4
;---------For anomaly----------
;  res@gsnYRefLine       =0 
;  res@gsnYRefLineColor = "gray50"
;  res@gsnYRefLineDashPattern=1
;-------------------------------
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = (/"Red","Blue","Green"/) ; colors chosen
  res@xyLineThicknesses	 = (/3.,3.,3./)      ; line thicknesses
  res@xyDashPatterns	 = (/0.,0.,0./)      ; make all lines solid
  res@tiYAxisString	 = "m"      ; add an axis title    
  res@tiYAxisAngleF=0
  res@txFontHeightF	 = 0.0195            ; change title font heights
  res@tmXBMode          = "Explicit"
  res@tmXBValues        = year
  res@tmXBLabels        = year 
  res@tiMainString=""
  res@gsnLeftString              = "NINO3"
  res@trYMinF	         = 65              ; set x-axis minimum
  res@trYMaxF            = 90
;  plot = gsn_csm_xy (wks,yfrac,SST_ano,res)       ; create line plot
  plot(0) = gsn_csm_xy (wks,yfrac(0:tp-1),sst_nino3_mv,res)       ; create line plot
  res@gsnLeftString              = "NINO3.4"
  res@tmYLTickStartF 	 =  100
  res@tmYLTickEndF	 = 125
  res@trYMinF	         = 100              ; set x-axis minimum
  res@trYMaxF            = 125
  plot(1) = gsn_csm_xy (wks,yfrac(0:tp-1),sst_nino34_mv,res)       ; create line plot
  res@tmYLTickStartF 	 =  125
  res@tmYLTickEndF	 = 145
  res@trYMinF	         = 125           ; set x-axis minimum
  res@trYMaxF            = 145
  res@gsnLeftString              = "NINO4"
  plot(2) = gsn_csm_xy (wks,yfrac(0:tp-1),sst_nino4_mv,res)       ; create line plot

  gres = True
  gres@YPosPercent = 15.    ; expressed as %, 0->100, sets position of top border of legend 
  gres@XPosPercent = 75      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres = True
  lineres@lgLineColors = (/"red","blue","green"/) ; line colors
  lineres@lgLineThicknesses = 3                        ; line thicknesses
  lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
  textres = True
  textres@lgLabels = (/"CLIM","CONST","INTER"/)  ; legend labels (required)
  plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
  plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
  plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Monthly Thermocline depth (5 years moving;199801 - 201112)"
; pres@gsnPanelBottom=0.1
; pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 2
 gsn_panel(wks,plot,(/3,1/),pres)

 frame(wks)

end
