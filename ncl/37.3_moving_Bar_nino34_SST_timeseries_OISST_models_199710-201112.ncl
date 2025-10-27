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
time_counter=f->time
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
el98=SST_nino34_wgt(:,0:23);data(oisst,clim,const,inter)
el03=SST_nino34_wgt(:,60:83);data(oisst,clim,const,inter)
el10=SST_nino34_wgt(:,144:167);data(oisst,clim,const,inter)
;out=addfile("./imsi.nc","c")
;out->SST_nino34_wgt=SST_nino34_wgt
;exit
;----------- For moving average ------------------------------------
p=3;chunck period
tp=24-p+1;total period after moving averaged
;-----------------------------------------------
el98_mv=new((/4,tp/),"float"); Target
el03_mv=new((/4,tp/),"float"); Target
el10_mv=new((/4,tp/),"float"); Target
imsi=new((/4,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:)=el98(:,k:k+p-1)
  el98_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 
  imsi(:,:)=el03(:,k:k+p-1)
  el03_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue

  imsi(:,:)=el10(:,k:k+p-1)
  el10_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

el98_mv!1="time"
el03_mv!1="time"
el10_mv!1="time"

EL98_mv=new((/4,tp+1/),"float"); Target
EL03_mv=new((/4,tp+1/),"float"); Target
EL10_mv=new((/4,tp+1/),"float"); Target

EL98_mv(:,0)=(el98(:,0)+el98(:,1))/2
EL03_mv(:,0)=(el03(:,0)+el03(:,1))/2
EL10_mv(:,0)=(el10(:,0)+el10(:,1))/2

EL98_mv(:,1:tp)=el98_mv
EL03_mv(:,1:tp)=el03_mv
EL10_mv(:,1:tp)=el10_mv
 
time=g2->time_counter(3:170)
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y98=yfrac(0:22)
y03=yfrac(60:82)
y10=yfrac(144:166)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("x11",dir3+"3_moving_bar_xy_nino34_SST_timeseries_OISST_models_98_03_10")        ; send graphics to PNG file
  xy_plot=new(3,graphic)
  bar_plot=new(3,graphic)
  res                          = True
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  res@tmXBFormat = "f"        ; remove the trailing ".0" 
  res@trYMinF                  = -3.5
  res@trYMaxF                  =3.5
  res@tmYLMode          = "Manual"
  res@tmYLTickSpacingF  =  1
  res@tmYLTickStartF    = -3.5 
  res@tmYLTickEndF      = 3.5
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
  res@gsnCenterString 	="NINO34 SST (1998)"
  res@gsnCenterStringFontHeightF=0.024
  res@tmXBMode   = "Explicit"
  res@tmXBValues = y98(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/"Jan ~C~1998","Apr ~C~1998","Jul  ~C~1998"," Oct ~C~1998"," Jan ~C~1998","Apr ~C~1999"," Jul ~C~1999"," Oct ~C~1999"/)
  xy_plot(0) = gsn_csm_xy(wks,y98,EL98_mv(1:3,:),res)
  res2=res
  res2@tmXBLabels = (/"Jan ~C~2003","Apr ~C~2003","Jul  ~C~2003"," Oct ~C~2003"," Jan ~C~2003","Apr ~C~2004"," Jul ~C~2004"," Oct ~C~2004"/)
  res2@gsnCenterString 	="NINO34 SST (2003)"
  res2@tmYLTickStartF    =-2
  res2@tmYLTickEndF      = 2
  res2@trYMinF                  = -2
  res2@trYMaxF                 =2
  res2@tmXBValues = y03(::3)     ; choose first 13 timesteps
  xy_plot(1) = gsn_csm_xy(wks,y03,EL03_mv(1:3,:),res2)
  res3=res
  res3@tmXBLabels = (/"Jan ~C~2010","Apr ~C~2010","Jul  ~C~2010"," Oct ~C~2010"," Jan ~C~2010","Apr ~C~2011"," Jul ~C~2011"," Oct ~C~2011"/)
  res3@gsnCenterString 	="NINO34 SST (2010)"
  res3@trYMinF                  = -3
  res3@trYMaxF                  =3
  res3@tmYLTickStartF    =-3
  res3@tmYLTickEndF      = 3
  res3@tmXBValues = y10(::3)     ; choose first 13 timesteps
  xy_plot(2) = gsn_csm_xy(wks,y10,EL10_mv(1:3,:),res3)

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
  bar_plot(0)= gsn_csm_xy (wks,y98,EL98_mv(0,:),bres)
  bar_plot(1) = gsn_csm_xy(wks,y03,EL03_mv(0,:),bres)
  bar_plot(2) = gsn_csm_xy(wks,y10,EL10_mv(0,:),bres)
  overlay(xy_plot(0),bar_plot(0))
  overlay(xy_plot(1),bar_plot(1))
  overlay(xy_plot(2),bar_plot(2))

;  gres = True
;  gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend
;  gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres = True
  lineres@lgPerimDashSegLenF=0.01
  lineres@lgMonoItemType     = False
  lineres@lgMonoLineDashSegLen=False
  ;lineres@lgLineDashSegLens=(/0.03,0.03,0.03/)
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
  gsn_legend_ndc(wks,3,labels,0.625,0.961,lineres)
  gsn_legend_ndc(wks,3,labels,0.625,0.482,lineres)
  gsn_legend_ndc(wks,3,labels,0.625,0.296,lineres)
;  xy_plot(0) = simple_legend(wks,xy_plot(0),gres,lineres,textres)
;  xy_plot(1) = simple_legend(wks,xy_plot(1),gres,lineres,textres)
;  xy_plot(2) = simple_legend(wks,xy_plot(2),gres,lineres,textres)
  lbres                    = True          ; labelbar only resources
  lbres@vpWidthF           = 0.08      ; labelbar width
  lbres@vpHeightF          = 0.02      ; labelbar height
  lbres@lbBoxMajorExtentF  = 0.75          ; puts space between color boxes
  lbres@lbFillColors       = "black" ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.008         ; font height. default is small
  lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
  gsn_labelbar_ndc(wks,1,"OISST",0.545,0.952,lbres)
  gsn_labelbar_ndc(wks,1,"OISST",0.545,0.430,lbres)
  gsn_labelbar_ndc(wks,1,"OISST",0.545,0.287,lbres)

  pres                       =   True
  pres@gsnFrame         = False
  ;pres@gsnPanelMainString="Anomaly monthly SST (199801 - 201112)"
 ; pres@gsnPanelBottom=0.1
 ; pres@gsnPanelLeft=0.05
  pres@gsnPanelLabelBar      = False
  pres@gsnMaximize        =       False
  pres@gsnPanelYWhiteSpacePercent = 4
  gsn_panel(wks,xy_plot,(/3,1/),pres)
  frame(wks)

end
