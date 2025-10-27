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
oisst_flt = short2flt(sst)
dim0=dimsizes(oisst_flt)
oisst_clim=dim_avg_n_Wrap(oisst_flt,0)
oisst=new((/dim0(0),dim0(1),dim0(2)/),"float")

 do i=0,dim0(0)-1
  oisst(i,:,:)=oisst_flt(i,:,:)-oisst_clim
 end do
copy_VarMeta(oisst_flt,oisst)

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
tos_clim_clim=dim_avg_n_Wrap(tos_clim_raw,0)
dim1=dimsizes(tos_clim_raw)
tos_clim=new((/dim1(0),dim1(1),dim1(2)/),"float")

 do i=0,dim1(0)-1
  tos_clim(i,:,:)=tos_clim_raw(i,:,:)-tos_clim_clim
 end do
copy_VarMeta(tos_clim_raw,tos_clim)

tos_clim_lonflip = lonFlip(tos_clim)
clat2   = cos(lat_nemo*rad)
time=g2->time_counter(3:170)
tos_clim_nino3=tos_clim(:,:,{nino3_lon_min:nino3_lon_max})
tos_clim_nino34=tos_clim(:,:,{nino34_lon_min:nino34_lon_max})
tos_clim_nino4=tos_clim_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
tos_clim_nino3_wgt = wgt_areaave_Wrap(tos_clim_nino3,clat2,1.0,1)
tos_clim_nino34_wgt = wgt_areaave_Wrap(tos_clim_nino34,clat2,1.0,1)
tos_clim_nino4_wgt = wgt_areaave_Wrap(tos_clim_nino4,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h1=addfile(dir2+"tos_regrid_const_199710-201112.nc","r")
tos_const_raw=h1->tos(3:170,{lat_min:lat_max},:)
tos_const_clim=dim_avg_n_Wrap(tos_const_raw,0)
tos_const=new((/dim1(0),dim1(1),dim1(2)/),"float")

 do i=0,dim1(0)-1
  tos_const(i,:,:)=tos_const_raw(i,:,:)-tos_const_clim
 end do
copy_VarMeta(tos_const_raw,tos_const)

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
tos_inter_clim=dim_avg_n_Wrap(tos_inter_raw,0)
tos_inter=new((/dim1(0),dim1(1),dim1(2)/),"float")

 do i=0,dim1(0)-1
  tos_inter(i,:,:)=tos_inter_raw(i,:,:)-tos_inter_clim
 end do
copy_VarMeta(tos_inter_raw,tos_inter)

tos_inter_lonflip = lonFlip(tos_inter)
tos_inter_nino3=tos_inter(:,:,{nino3_lon_min:nino3_lon_max})
tos_inter_nino34=tos_inter(:,:,{nino34_lon_min:nino34_lon_max})
tos_inter_nino4=tos_inter_lonflip(:,:,{nino4_lon_min:nino4_lon_max})
tos_inter_nino3_wgt = wgt_areaave_Wrap(tos_inter_nino3,clat2,1.0,1)
tos_inter_nino34_wgt = wgt_areaave_Wrap(tos_inter_nino34,clat2,1.0,1)
tos_inter_nino4_wgt = wgt_areaave_Wrap(tos_inter_nino4,clat2,1.0,1)

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
dim=dimsizes(tos_const)
;----------- For moving average ------------------------------------
y=7 ; moving year
p=y*12;chunck period
tp=dim(0)-p+1;total period after moving averaged 
;----------------------------------area average------------------------------------------------
SST_nino3_wgt=new((/4,dim(0)/),"float")
SST_nino3_wgt(0,:)=oisst_nino3_wgt
SST_nino3_wgt(1,:)=tos_clim_nino3_wgt
SST_nino3_wgt(2,:)=tos_const_nino3_wgt
SST_nino3_wgt(3,:)=tos_inter_nino3_wgt
SST_nino3_wgt!0="data"
;-----------------------------------------------
sst_nino3_mv=new((/4,tp/),"float"); Target
imsi=new((/4,p/),"float"); Chunck 
 do k=0,tp-1
  imsi(:,:)=SST_nino3_wgt(:,k:k+p-1)
  sst_nino3_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino3_mv!1="time"
sst_nino3_mv&time=time(0:tp-1)
;----------------------------------area average------------------------------------------------
SST_nino34_wgt=new((/4,dim(0)/),"float")
SST_nino34_wgt(0,:)=oisst_nino34_wgt
SST_nino34_wgt(1,:)=tos_clim_nino34_wgt
SST_nino34_wgt(2,:)=tos_const_nino34_wgt
SST_nino34_wgt(3,:)=tos_inter_nino34_wgt
SST_nino34_wgt!0="data"
;-----------------------------------------------
sst_nino34_mv=new((/4,tp/),"float"); Target
 do k=0,tp-1
  imsi(:,:)=SST_nino34_wgt(:,k:k+p-1)
  sst_nino34_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino34_mv!1="time"
sst_nino34_mv&time=time(0:tp-1)
;----------------------------------area average------------------------------------------------
SST_nino4_wgt=new((/4,dim(0)/),"float")
SST_nino4_wgt(0,:)=oisst_nino4_wgt
SST_nino4_wgt(1,:)=tos_clim_nino4_wgt
SST_nino4_wgt(2,:)=tos_const_nino4_wgt
SST_nino4_wgt(3,:)=tos_inter_nino4_wgt
SST_nino4_wgt!0="data"
;-----------------------------------------------
sst_nino4_mv=new((/4,tp/),"float"); Target
 do k=0,tp-1
  imsi(:,:)=SST_nino4_wgt(:,k:k+p-1)
  sst_nino4_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
sst_nino4_mv!1="time"
sst_nino4_mv&time=time(0:tp-1)
;----------------------------------area average------------------------------------------------
year=ispan(1998,2008,2)
year2=ispan(1998,2008,1)
;--------------------------------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir3+"7moving_ENSO_ANO_SST_timeseries_OISST_NEMOs_199801-201112")             ; send graphics to PNG file
 plot=new(3,graphic)
  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet
  res@vpHeightF 	 = 0.4               ; change aspect ratio of plot
  res@vpWidthF 	         = 0.7
  res@trXMaxF            = 2005
  res@trXMinF	         = 1998              ; set x-axis minimum
  res@gsnLeftStringOrthogonalPosF=0.08
  res@gsnLeftStringFontHeightF=0.025
;  res@trYMinF	         = 17.5              ; set x-axis minimum
;  res@trYMaxF            = 19
;  res@tmYLMode		 = "Manual"
;  res@tmYLTickSpacingF	 =  0.5
;  res@tmYLTickStartF 	 =  17.5
;  res@tmYLTickEndF	 = 19
  res@tmYLMinorPerMajor=4
;---------For anomaly----------
  res@gsnYRefLine       =0 
  res@gsnYRefLineColor = "gray50"
  res@gsnYRefLineDashPattern=1
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
  res@tiMainString=""
  res@gsnLeftString              = "NINO3"
;  plot = gsn_csm_xy (wks,yfrac,SST_ano,res)       ; create line plot
  plot(0) = gsn_csm_xy (wks,yfrac(0:tp-1),sst_nino3_mv,res)       ; create line plot
  res@gsnLeftString              = "NINO3.4"
  plot(1) = gsn_csm_xy (wks,yfrac(0:tp-1),sst_nino34_mv,res)       ; create line plot
  res@gsnLeftString              = "NINO4"
  plot(2) = gsn_csm_xy (wks,yfrac(0:tp-1),sst_nino4_mv,res)       ; create line plot

  gres = True
  gres@YPosPercent = 12.    ; expressed as %, 0->100, sets position of top border of legend 
  gres@XPosPercent = 60      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres = True
  lineres@lgLineColors = (/"black","red"/) ; line colors
  lineres@lgLineThicknesses = 3                        ; line thicknesses
  lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
  textres = True
  textres@lgLabels = (/"OISST","CLIM"/)  ; legend labels (required)
  plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
  plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
  gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend 
  gres@XPosPercent = 60      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
  gres@YPosPercent = 12.    ; expressed as %, 0->100, sets position of top border of legend 
  gres@XPosPercent = 80      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres@lgLineColors = (/"blue","green"/) ; line colors
  textres@lgLabels = (/"CONST","INTER"/)  ; legend labels (required)
  plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
  plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
  gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend 
  gres@XPosPercent = 80      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Monthly SST anomaly (7 years moving;199801 - 201112)"
; pres@gsnPanelBottom=0.1
; pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 2
 gsn_panel(wks,plot,(/3,1/),pres)

 frame(wks)

end
