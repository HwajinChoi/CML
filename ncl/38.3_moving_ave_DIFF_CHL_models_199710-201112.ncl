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
;------------------------------------------------------------------------------------------
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

CHL=(chl98_nino34_wgt+chl03_nino34_wgt+chl10_nino34_wgt)/3
copy_VarMeta(chl98_nino34_wgt,CHL)
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
el98=SST_nino34_wgt(:,0:23);data(oisst,clim,const,inter)
el03=SST_nino34_wgt(:,60:83);data(oisst,clim,const,inter)
el10=SST_nino34_wgt(:,144:167);data(oisst,clim,const,inter)

EL=(el98+el03+el10)/3
copy_VarMeta(el10,EL)
;----------- For moving average ------------------------------------
p=3;chunck period
tp=24-p+1;total period after moving averaged
;-----------------------------------------------
EL_mv=new((/4,tp/),"float"); Target
imsi=new((/4,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:)=EL(:,k:k+p-1)
  EL_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

EL_mv!1="time"

EL_mv2=new((/4,tp+1/),"float"); Target
EL_mv2(:,0)=(EL(:,0)+EL(:,1))/2
EL_mv2(:,1:tp)=EL_mv;data(oisst,clim,const,inter)

diff_inter_clim=EL_mv2(3,:)-EL_mv2(1,:)
diff_inter_const=EL_mv2(3,:)-EL_mv2(2,:)
;diff_clim_const=EL_mv2(1,:)-EL_mv2(2,:)

DIFF=new((/2,tp+1/),"float"); Target
DIFF(0,:)=diff_inter_clim
DIFF(1,:)=diff_inter_const

mon=ispan(1,23,1)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("png",dir3+"3_moving_AVE_CHL_DIFF_nino34_SST_timeseries")   
  xy_plot=new(1,graphic)
  res                          = True
  res@tmXBFormat = "f"        ; remove the trailing ".0" 
  res@trYMinF                  = -0.4
  res@trYMaxF                  =0.4
  res@tmYRMode          = "Manual"
  res@tmYRTickSpacingF  =  0.2
  res@tmYRTickStartF    = -0.4
  res@tmYRTickEndF      = 0.4
  res@tmYRMinorPerMajor=3
  res@xyMarkLineModes      =(/"MarkLines","MarkLines"/)
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = (/"purple","Gold"/) ; colors chosen
  res@xyMarkerColors=(/"purple","Gold"/)
  res@xyMarkerThicknesses    = (/3.,3./)      ; line thicknesses
  res@xyLineThicknesses    = (/4.,4./)      ; line thicknesses
  res@xyMarkers=(/16,16/)
  res@xyDashPatterns     = (/0.,0./)      ; make all lines solid
  res@tiYAxisString      = "~F35~J~F~C"      ; add an axis title
  res@txFontHeightF      = 0.0195            ; change title font heights

  bres			=True
  bres@gsnDraw                  = False   ; Don't draw
  bres@gsnFrame                 = False   ; Don't advance frame
  bres@vpHeightF          = 0.4               ; change aspect ratio of plot
  bres@gsnYRefLineDashPattern=0
  bres@vpWidthF           = 0.62
  bres@gsnYRefLine       =0
  bres@gsnYRefLineColor = "black"
  bres@gsnCenterString 	="Chlorophyll, SST Bias Diff"
  bres@gsnCenterStringFontHeightF=0.024
  bres@tmXBMode   = "Explicit"
  bres@tmXBValues = mon(::3)     ; choose first 13 timesteps
  bres@tmXBLabels = (/" Jan "," Apr "," Jul "," Oct "," Jan "," Apr "," Jul "," Oct "/)
  bres@tmYRMode="Manual"
  bres@tmYLMode          = "Manual"
  bres@tmYLTickSpacingF=0.05
  bres@tiYAxisFontColor = "darkgreen" 
  bres@tmYLTickStartF=0.1
  bres@tmYLMinorPerMajor=4
  bres@tmYLTickEndF=-0.1
  bres@xyDashPattern         = 1
  bres@xyLineThicknesses      = 4
  bres@gsnXYBarChartColors   = "darkgreen"
  bres@trYMaxF           =   0.1
  bres@trYMinF           =-0.1
  bres@xyLineColor="darkgreen"
  bres@tiYAxisString     = "mg / m~S~3~N"      ; add an axis title
  bres@xyMarker          =      3
  bres@xyMarkerThicknessF=      3
  bres@gsnYRefLine       =0
  bres@gsnYRefLineColor = "black"
  bres@gsnYRefLineDashPattern=0
  bres@gsnXYBarChart         = True            ; Turn on bar chart
  bres@gsnXYBarChartBarWidth = 0.55
  xy_plot = gsn_csm_xy2(wks,mon,CHL,DIFF,bres,res)

  lineres = True
  lineres@lgPerimDashSegLenF=0.01
  lineres@lgMonoItemType     = False
  lineres@lgMonoLineDashSegLen=False
  lineres@lgLineLabelConstantSpacingF=0.1
  lineres@lgMonoLineThickness =False
  lineres@lgLabelFontHeightF =0.12
  lineres@vpWidthF           = 0.14 
  lineres@lgDashIndexes=(/0,0/)
  lineres@vpHeightF          = 0.08 
  lineres@lgItemTypes=(/"MarkLines","MarkLines"/)
  lineres@lgMarkerIndexes    =(/16,16/) 
  lineres@lgLineColors = (/"purple","gold"/) ; line colors
  lineres@lgMarkerColors = (/"purple","gold"/) ; line colors
  lineres@lgLineThicknesses = (/4,4/)                        ; line thicknesses
  lineres@lgLineLabelFontThicknessF=(/4,4/)
  lineres@lgMonoMarkerThickness=False
  lineres@lgMarkerThicknesses=(/1,1/)
  lineres@lgPerimOn              = False
  lineres@LineLengthPercent = 5
  labels = (/"INTER-CLIM","INTER-CONST"/)  ; legend labels (required)
  gsn_legend_ndc(wks,2,labels,0.67,0.8,lineres)
  lbres                    = True          ; labelbar only resources
  lbres@vpWidthF           = 0.08      ; labelbar width
  lbres@vpHeightF          = 0.02      ; labelbar height
  lbres@lbBoxMajorExtentF  = 0.75          ; puts space between color boxes
  lbres@lbFillColors       = "darkgreen" ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.012         ; font height. default is small
  lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
  gsn_labelbar_ndc(wks,1,"CHL",0.58,0.792,lbres)
  draw(xy_plot)
  frame(wks)

end
