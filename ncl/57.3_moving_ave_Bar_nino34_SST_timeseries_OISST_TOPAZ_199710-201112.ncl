begin
dir1="/media/cmlws/Data2/hjc/OISST/imsi/"
dir2="/media/cmlws/Data2/hjc/NEMO_TOPAZ/"
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;-------------------------------------------OISST-------------------------------------------
f=addfile(dir1+"oisst_r180x90_1983-2004.nc","r")
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
oisst_nino34=oisst(:,:,{nino34_lon_min:nino34_lon_max})
oisst_nino34_wgt = wgt_areaave_Wrap(oisst_nino34,clat1,1.0,1)
oisst_nino34_wgt!0="time_counter"
;---------------------------------------------------------------------------------------------
g2=addfile(dir2+"grid_T_1983-2004.mm.msk.flt.sstemper.nc","r")
tos_clim_raw=g2->sstemper(:,{lat_min:lat_max},:)
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
;----------------------------------area average------------------------------------------------
dim=dimsizes(tos_clim)
SST_nino34_wgt=new((/2,dim(0)/),"float")
SST_nino34_wgt(0,:)=oisst_nino34_wgt
SST_nino34_wgt(1,:)=tos_clim_nino34_wgt
SST_nino34_wgt!0="data"
;start=12*(x-1998)
;end=12*(x-1998)+23
;----------- For moving average ------------------------------------
p=3;chunck period
tp=24-p+1;total period after moving averaged
;-----------------------------------------------
EL_mv=new((/2,tp/),"float"); Target
imsi=new((/2,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:)=SST_nino34_wgt(:,k:k+p-1)
  EL_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

EL_mv!1="time"

EL_mv2=new((/2,tp+1/),"float"); Target
EL_mv2(:,0)=(SST_nino34_wgt(:,0)+SST_nino34_wgt(:,1))/2
EL_mv2(:,1:tp)=EL_mv

mon=ispan(1,23,1)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("png",dir3+"3_moving_AVE_bar_xy_nino34_SST_timeseries_OISST_NEMO_TOPAZ")   
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
  res@xyMarkLineMode      =(/"MarkLines"/)
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColor       = (/"Blue"/) ; colors chosen
  res@xyMarkerColor=(/"Blue"/)
  res@xyMarkerThicknessF    = 3.
  res@xyLineThicknessF    = 4.
  res@xyMarker=16
  res@xyDashPattern     = 0.
  res@tiYAxisString      = "~F35~J~F~C"      ; add an axis title
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@gsnCenterString 	="NINO34 SST "
  res@gsnCenterStringFontHeightF=0.024
  res@tmXBMode   = "Explicit"
  res@tmXBValues = mon(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/" Jan "," Apr "," Jul "," Oct "," Jan "," Apr "," Jul "," Oct "/)
  xy_plot = gsn_csm_xy(wks,mon,EL_mv2(1,:),res)

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
  bar_plot= gsn_csm_xy (wks,mon,EL_mv2(0,:),bres)
  overlay(xy_plot,bar_plot)

  lineres = True
  lineres@lgPerimDashSegLenF=0.01
  lineres@lgMonoItemType     = True
  lineres@lgMonoLineDashSegLen=True
  lineres@lgLineLabelConstantSpacingF=0.1
  lineres@lgMonoLineThickness =True
  lineres@lgLabelFontHeightF =0.22
  lineres@vpWidthF           = 0.14 
  lineres@lgDashIndex=0
  lineres@vpHeightF          = 0.08 
  lineres@lgItemType="MarkLines"
  lineres@lgMarkerIndexes    =16
  lineres@lgLineColors = "blue"
  lineres@lgMarkerColors = "blue"
  lineres@lgLineThicknessF = 4
  lineres@lgLineLabelFontThicknessF=6
  lineres@lgMonoMarkerThickness=True
  lineres@lgMarkerThicknessF=1
  lineres@lgPerimOn              = False
  lineres@LineLengthPercent = 5
  labels = (/"NEMO_TOPAZ"/)  ; legend labels (required
  gsn_legend_ndc(wks,1,labels,0.75,0.82,lineres)
  lbres                    = True          ; labelbar only resources
  lbres@vpWidthF           = 0.08      ; labelbar width
  lbres@vpHeightF          = 0.02      ; labelbar height
  lbres@lbBoxMajorExtentF  = 0.75          ; puts space between color boxes
  lbres@lbFillColors       = "black" ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.012         ; font height. default is small
  lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
  gsn_labelbar_ndc(wks,1,"OISST",0.66,0.792,lbres)
  draw(xy_plot)
  frame(wks)

end
