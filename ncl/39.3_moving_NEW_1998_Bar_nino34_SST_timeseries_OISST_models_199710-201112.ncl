begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
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
h2=addfile(dir2+"tos_inter_98_init_clim_r180x90_199801-199912.nc","r")
tos_inter_raw=h2->tos(:,{lat_min:lat_max},:)
;tos_inter_mon=clmMonTLL(tos_inter_raw)
tos_inter=calcMonAnomTLL(tos_inter_raw,tos_clim_mon)
tos_inter_lonflip = lonFlip(tos_inter)
tos_inter_nino34=tos_inter(:,:,{nino34_lon_min:nino34_lon_max})
tos_inter_nino34_wgt = wgt_areaave_Wrap(tos_inter_nino34,clat2,1.0,1)
;----------------------------------area average------------------------------------------------
el98=new((/3,24/),"float")
el98(0,:)=oisst_nino34_wgt(0:23)
el98(1,:)=tos_clim_nino34_wgt(0:23)
el98(2,:)=tos_inter_nino34_wgt
el98!0="data"
;start=12*(x-1998)
;end=12*(x-1998)+23
time=g2->time_counter(3:170)
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y98=yfrac(0:22)
;----------- For moving average ------------------------------------
p=3;chunck period
tp=24-p+1;total period after moving averaged
;-----------------------------------------------
el98_mv=new((/3,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:)=el98(:,k:k+p-1)
  el98_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

el98_mv!1="time"

el_mv2=new((/3,tp+1/),"float");
el_mv2(:,0)=(el98(:,0)+el98(:,1))/2
el_mv2(:,1:tp)=el98_mv

;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("x11",dir3+"3moving_NEW_clim_inter_1998_bar_xy_nino34_SST_timeseries_OISST") 
  xy_plot=new(1,graphic)
  bar_plot=new(1,graphic)
  res                          = True
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  res@tmXBFormat = "f"        ; remove the trailing ".0" 
  res@trYMinF                  = -2
  res@trYMaxF                  =3.5
  res@tmYLMode          = "Manual"
  res@tmYLTickSpacingF  =  1
  res@tmYLTickStartF    = -2
  ;res@tmYLTickEndF      = 3.5
  res@tmYLMinorPerMajor=4
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
  res@gsnYRefLine       =0
  res@gsnYRefLineColor = "black"
  res@gsnYRefLineDashPattern=0
  res@xyMarkLineModes      =(/"MarkLines","MarkLines"/)
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = (/"Red","Green"/) ; colors chosen
  res@xyMarkerColors=(/"Red","Green"/)
  res@xyMarkerThicknesses    = (/3.,3./)      ; line thicknesses
  res@xyLineThicknesses    = (/4.,4./)      ; line thicknesses
  res@xyMarkers=(/3,3/)
  res@xyDashPatterns     = (/0.,0./)      ; make all lines solid
  res@tiYAxisString      = "~F35~J~F~C"      ; add an axis title
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@gsnCenterString 	="NINO34 SST (1998)"
  res@gsnCenterStringFontHeightF=0.024
  res@tmXBMode   = "Explicit"
  res@tmXBValues =y98(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/" Jan ~C~1998"," Apr ~C~1998"," Jul ~C~1998"," Oct ~C~1998","Jan ~C~1999"," Apr ~C~1999"," Jul ~C~1999"," Oct ~C~1999"/)
  xy_plot = gsn_csm_xy(wks,y98,el_mv2(1:2,:),res)

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
  bres@gsnXYBarChartBarWidth = 0.06
  bres@gsnXYBarChartColors   = "black"        ; Color for bars
  bar_plot= gsn_csm_xy (wks,y98,el_mv2(0,:),bres)
  overlay(xy_plot,bar_plot)

  lineres = True
  lineres@lgPerimDashSegLenF=0.01
  lineres@lgMonoItemType     = False
  lineres@lgMonoLineDashSegLen=False
  lineres@lgLineLabelConstantSpacingF=0.1
  lineres@lgMonoLineThickness =False
  lineres@lgLabelFontHeightF =0.080
  lineres@vpWidthF           = 0.10 
  lineres@lgDashIndexes=(/0,0/)
  lineres@vpHeightF          = 0.08 
  lineres@lgItemTypes=(/"MarkLines","MarkLines"/)
  lineres@lgMarkerIndexes    =(/3,3/) 
  lineres@lgLineColors = (/"red","green"/) ; line colors
  lineres@lgMarkerColors = (/"red","green"/) ; line colors
  lineres@lgLineThicknesses = (/5,5/)                        ; line thicknesses
  lineres@lgLineLabelFontThicknessF=(/5,5/)
  lineres@lgMonoMarkerThickness=False
  lineres@lgMarkerThicknesses=(/1,1/)
  lineres@lgPerimOn              = False
  lineres@LineLengthPercent = 5
  labels = (/"CLIM","INTER"/)  ; legend labels (required)
  gsn_legend_ndc(wks,2,labels,0.79,0.8,lineres)
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
