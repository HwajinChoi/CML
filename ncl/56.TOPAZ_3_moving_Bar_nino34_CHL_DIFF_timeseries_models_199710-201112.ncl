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
rad    = 4.0*atan(1.0)/180.0
k1=addfile(dir4+"chl_r180x90_199710-202112.nc","r")
chl_raw=k1->chlor_a(3:290,:,:)
chl_mon=clmMonTLL(chl_raw)
chl=calcMonAnomTLL(chl_raw,chl_mon)
lat_chl=k1->lat({lat_min:lat_max})
clat0=cos(lat_chl*rad)

chl_98=chl(1:23,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
chl_03=chl(61:83,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
chl_10=chl(145:167,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})

chl98_nino34_wgt = wgt_areaave_Wrap(chl_98,clat0,1.0,1)
chl03_nino34_wgt = wgt_areaave_Wrap(chl_03,clat0,1.0,1)
chl10_nino34_wgt = wgt_areaave_Wrap(chl_10,clat0,1.0,1)
;---------------------------------------------------------------------------------------------
ff1=addfile(dir2+"tptrc_T_1998-1999.mm.msk.flt.sfcchl.nc","r")
sfcchl_98=ff1->sfcchl(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
lon_to=ff1->lon({nino34_lon_min:nino34_lon_max})
lat_to=ff1->lat({lat_min:lat_max})
lat_to2   = cos(lat_to*rad)
CHL_to_wgt_98 = wgt_areaave_Wrap(sfcchl_98,lat_to2,1.0,1)

ff2=addfile(dir2+"tptrc_T_2003-2004.mm.msk.flt.sfcchl.nc","r")
sfcchl_03=ff2->sfcchl(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
CHL_to_wgt_03 = wgt_areaave_Wrap(sfcchl_03,lat_to2,1.0,1)

;---------------------------------------------------------------------------------------------
g2=addfile(dir2+"CHL_chl_clim_1m_19971001_20111231_ptrc_T.nc","r")
CHL_clim_raw1=g2->DCHL(3:170,{lat_min:lat_max},:)
CHL_clim_raw2=g2->NCHL(3:170,{lat_min:lat_max},:)
lon_nemo=g2->lon
lat_nemo=g2->lat({lat_min:lat_max})
CHL_clim_raw=CHL_clim_raw1+CHL_clim_raw2
copy_VarMeta(CHL_clim_raw1,CHL_clim_raw)
CHL_clim_raw@long_name="chlorophyl Concentration"
CHL_clim_mon=clmMonTLL(CHL_clim_raw)
CHL_clim=calcMonAnomTLL(CHL_clim_raw,CHL_clim_mon)
;--------------------------------------------------------------------------------------------
dim1=dimsizes(CHL_clim_raw)
clat2   = cos(lat_nemo*rad)
CHL_clim_nino34=CHL_clim(:,:,{nino34_lon_min:nino34_lon_max})
CHL_clim_nino34_wgt = wgt_areaave_Wrap(CHL_clim_nino34,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h1=addfile(dir2+"CHL_chl_const_1m_19971001_20111231_ptrc_T.nc","r")
CHL_const_raw1=h1->NCHL(3:170,{lat_min:lat_max},:)
CHL_const_raw2=h1->DCHL(3:170,{lat_min:lat_max},:)
CHL_const_raw=CHL_const_raw1+CHL_const_raw2
copy_VarMeta(CHL_const_raw1,CHL_const_raw)
CHL_const_raw@long_name="chlorophyl Concentration"
CHL_const_mon=clmMonTLL(CHL_const_raw)
CHL_const=calcMonAnomTLL(CHL_const_raw,CHL_const_mon)
CHL_const_lonflip = lonFlip(CHL_const)
CHL_const_nino34=CHL_const(:,:,{nino34_lon_min:nino34_lon_max})
CHL_const_nino34_wgt = wgt_areaave_Wrap(CHL_const_nino34,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h2=addfile(dir2+"CHL_chl_inter_1m_19971001_20111231_ptrc_T.nc","r")
CHL_inter_raw1=h2->NCHL(3:170,{lat_min:lat_max},:)
CHL_inter_raw2=h2->DCHL(3:170,{lat_min:lat_max},:)
CHL_inter_raw=CHL_inter_raw1+CHL_inter_raw2
copy_VarMeta(CHL_inter_raw1,CHL_inter_raw)
CHL_inter_raw@long_name="chlorophyl Concentration"
CHL_inter_mon=clmMonTLL(CHL_inter_raw)
CHL_inter=calcMonAnomTLL(CHL_inter_raw,CHL_inter_mon)
CHL_inter_lonflip = lonFlip(CHL_inter)
CHL_inter_nino34=CHL_inter(:,:,{nino34_lon_min:nino34_lon_max})
CHL_inter_nino34_wgt = wgt_areaave_Wrap(CHL_inter_nino34,clat2,1.0,1)
;----------------------------------area average------------------------------------------------
dim=dimsizes(CHL_const)
SST_nino34_wgt=new((/3,dim(0)/),"float")
SST_nino34_wgt(0,:)=CHL_clim_nino34_wgt
SST_nino34_wgt(1,:)=CHL_const_nino34_wgt
SST_nino34_wgt(2,:)=CHL_inter_nino34_wgt
SST_nino34_wgt!0="data"
;start=12*(x-1998)
;end=12*(x-1998)+23
el98=new((/5,24/),"float")
el03=new((/5,24/),"float")
el10=new((/4,24/),"float")
;---------------------------------------------------------------------------------------------
el98(0,:)=chl98_nino34_wgt
el98(1:3,:)=SST_nino34_wgt(:,0:23);data(oisst,clim,const,inter)
el98(4,:)=CHL_to_wgt_98
;---------------------------------------------------------------------------------------------
el03(0,:)=chl03_nino34_wgt
el03(1:3,:)=SST_nino34_wgt(:,60:83);data(oisst,clim,const,inter)
el03(4,:)=CHL_to_wgt_03
;---------------------------------------------------------------------------------------------
el10(0,:)=chl10_nino34_wgt
el10(1:3,:)=SST_nino34_wgt(:,144:167);data(oisst,clim,const,inter)
;----------- For moving average ------------------------------------
p=3;chunck period
tp=24-p+1;total period after moving averaged
;-----------------------------------------------
el98_mv=new((/5,tp/),"float"); Target
el03_mv=new((/5,tp/),"float"); Target
el10_mv=new((/4,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck

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

EL98_mv=new((/3,tp+1/),"float"); Target
EL03_mv=new((/3,tp+1/),"float"); Target
EL10_mv=new((/3,tp+1/),"float"); Target

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
  wks = gsn_open_wks("x11",dir3+"3_moving_bar_Satellite_CHL_nino34_CHL_timeseries_models_98_03_10") 
  xy_plot=new(3,graphic)
  plot=new(3,graphic)
  res                          = True
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  res@tmXBFormat = "f"        ; remove the trailing ".0" 
  res@trYMinF                  = -0.16
  res@trYMaxF                  =0.16
  res@tmYLMode          = "Manual"
  res@tmYLTickSpacingF  =  0.05
  res@tmYLTickStartF    = -0.15 
  res@tmYLTickEndF      = 0.15
  res@tmYLMinorPerMajor=4
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.75
  res@gsnYRefLine       =0
  res@gsnYRefLineColor = "black"
  res@gsnYRefLineDashPattern=0
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@tiYAxisString     = "mg / m~S~3~N"      ; add an axis title
  res@tmXBMode   = "Explicit"
  res@tmXBValues = y98(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/"Jan ~C~1998","Apr ~C~1998","Jul  ~C~1998"," Oct ~C~1998"," Jan ~C~1998","Apr ~C~1999"," Jul ~C~1999"," Oct ~C~1999"/)
  resR=res
  res@gsnCenterString 	="CHL (1998)"
  res@gsnCenterStringFontHeightF=0.024
  res@xyMarkLineModes      =(/"MarkLines","MarkLines","MarkLines"/)
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = (/"Red","Blue","Green"/) ; colors chosen
  res@xyMarkerColors=(/"Red","Blue","Green"/)
  res@xyMarkerThicknesses    = (/3.,3.,3./)      ; line thicknesses
  res@xyLineThicknesses    = (/4.,4.,4./)      ; line thicknesses
  res@xyMarkers=(/16,16,16/)
  res@xyDashPatterns     = (/0.,0.,0./)      ; make all lines solid
  resR@xyDashPattern         = 1
  resR@xyLineThicknesses      = 4
  resR@trYMaxF           =   0.15
  resR@trYMinF           =-0.15
  resR@xyLineColor="darkgreen"
  resR@tiYAxisFontColor="darkgreen"
  resR@xyMarkerColor=resR@xyLineColor
  resR@xyMarkLineMode      ="MarkLines"
  resR@xyMarker=3
  resR@xyMarkerThicknessF=3
  xy_plot(0) = gsn_csm_xy(wks,y98,EL98_mv,res)
  plot(0)=gsn_csm_xy(wks,y98,chl98_nino34_wgt,resR)
  res2=res
  res2@tmXBLabels = (/"Jan ~C~2003","Apr ~C~2003","Jul  ~C~2003"," Oct ~C~2003"," Jan ~C~2003","Apr ~C~2004"," Jul ~C~2004"," Oct ~C~2004"/)
  res2@gsnCenterString 	="CHL (2003)"
  res2@tmYLTickStartF    =-0.1
  res2@tmYLTickEndF      = 0.1
  res2@trYMinF                  = -0.1
  res2@trYMaxF                 =0.1
  res2@tmXBValues = y03(::3)     ; choose first 13 timesteps
  resR@gsnCenterString=""
  resR@tmYLTickStartF    =-0.1
  resR@tmYLTickEndF      = 0.1
  resR@trYMinF                  = -0.1
  resR@trYMaxF                 =0.1
  xy_plot(1) = gsn_csm_xy(wks,y03,EL03_mv,res2)
  plot(1) = gsn_csm_xy(wks,y03,chl03_nino34_wgt,resR)
  res3=res
  res3@tmXBLabels = (/"Jan ~C~2010","Apr ~C~2010","Jul  ~C~2010"," Oct ~C~2010"," Jan ~C~2010","Apr ~C~2011"," Jul ~C~2011"," Oct ~C~2011"/)
  res3@gsnCenterString 	="CHL (2010)"
  res3@trYMinF                  = -0.1
  res3@trYMaxF                  =0.1
  res3@tmYLTickStartF    =-0.1
  res3@tmYLTickEndF      = 0.1
  res3@tmXBValues = y10(::3)     ; choose first 13 timesteps
  resR@trYMinF                  = -0.1
  resR@trYMaxF                  =0.1
  resR@tmYLTickStartF    =-0.1
  resR@tmYLTickEndF      = 0.1
  xy_plot(2) = gsn_csm_xy(wks,y10,EL10_mv,res3)
  plot(2) = gsn_csm_xy(wks,y10,chl10_nino34_wgt,resR)
  overlay(xy_plot(0),plot(0))
  overlay(xy_plot(1),plot(1))
  overlay(xy_plot(2),plot(2))

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
  gsn_legend_ndc(wks,3,labels,0.63,0.961,lineres)
  gsn_legend_ndc(wks,3,labels,0.63,0.482,lineres)
  gsn_legend_ndc(wks,3,labels,0.63,0.15,lineres)

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
  lin@lgLabelFontHeightF =0.1
  lin@vpWidthF           = 0.10
  lin@lgDashIndex=1
  lin@vpHeightF          = 0.10
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
  label = (/"Satellite CHL"/)  ; legend labels (required)
  gsn_legend_ndc(wks,1,label,0.52,0.989,lin)
  gsn_legend_ndc(wks,1,label,0.52,0.478,lin)
  gsn_legend_ndc(wks,1,label,0.52,0.148,lin)

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
