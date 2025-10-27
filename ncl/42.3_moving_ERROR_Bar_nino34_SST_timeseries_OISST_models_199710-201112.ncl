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

el98_mv!1="time"; data(oisst,clim,const,inter) * time(21)
el03_mv!1="time"
el10_mv!1="time"

el98_mv2=new((/4,tp+1/),"float"); Target
el03_mv2=new((/4,tp+1/),"float"); Target
el10_mv2=new((/4,tp+1/),"float"); Target

el98_mv2(:,0)=(el98(:,0)+el98(:,1))/2
el03_mv2(:,0)=(el03(:,0)+el03(:,1))/2
el10_mv2(:,0)=(el10(:,0)+el10(:,1))/2

el98_mv2(:,1:tp)=el98_mv
el03_mv2(:,1:tp)=el03_mv
el10_mv2(:,1:tp)=el10_mv

CLIM_98=((abs(el98_mv2(0,:)-el98_mv2(1,:))-abs(el98_mv2(0,:)-el98_mv2(3,:)))/abs(el98_mv2(0,:)-el98_mv2(1,:)))*100
CLIM_03=((abs(el03_mv2(0,:)-el03_mv2(1,:))-abs(el03_mv2(0,:)-el03_mv2(3,:)))/abs(el03_mv2(0,:)-el03_mv2(1,:)))*100
CLIM_10=((abs(el10_mv2(0,:)-el10_mv2(1,:))-abs(el10_mv2(0,:)-el10_mv2(3,:)))/abs(el10_mv2(0,:)-el10_mv2(1,:)))*100

CONST_98=((abs(el98_mv2(0,:)-el98_mv2(2,:))-abs(el98_mv2(0,:)-el98_mv2(3,:)))/abs(el98_mv2(0,:)-el98_mv2(2,:)))*100
CONST_03=((abs(el03_mv2(0,:)-el03_mv2(2,:))-abs(el03_mv2(0,:)-el03_mv2(3,:)))/abs(el03_mv2(0,:)-el03_mv2(2,:)))*100
CONST_10=((abs(el10_mv2(0,:)-el10_mv2(2,:))-abs(el10_mv2(0,:)-el10_mv2(3,:)))/abs(el10_mv2(0,:)-el10_mv2(2,:)))*100
;print(CLIM_10)
;print(CONST_98(10))
;print("B = "+abs(el98_mv(0,10)-el98_mv(2,10)))
;print("A = "+abs(el98_mv(0,10)-el98_mv(3,10)))
;exit

error_98=new((/2,23/),"float")
error_98(0,:)=CLIM_98
error_98(1,:)=CONST_98

error_03=new((/2,23/),"float")
error_03(0,:)=CLIM_03
error_03(1,:)=CONST_03

error_10=new((/2,23/),"float")
error_10(0,:)=CLIM_10
error_10(1,:)=CONST_10
 
time=g2->time_counter(3:170)
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y98=yfrac(0:22)
y03=yfrac(60:82)
y10=yfrac(144:166)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("png",dir3+"3_moving_ERROR_bar_xy_nino34_SST_timeseries_OISST_models_98_03_10")
  xy_plot=new((/3,2/),graphic)
  res                          = True
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  res@tmXBFormat = "f"        ; remove the trailing ".0" 
  res@trYMinF                  = -100
  res@trYMaxF                  =100
  res@tmYLMode          = "Manual"
  res@tmYLTickSpacingF  =  50
  res@tmYLTickStartF    = -100 
  res@tmYLTickEndF      = 100
  res@tmYLMinorPerMajor=4
  res@gsnXYBarChart         = True
  res@gsnXYBarChartBarWidth = 0.3           ; change bar widths
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
  res@gsnYRefLine       =0
  res@gsnYRefLineColor = "black"
  res@gsnYRefLineDashPattern=0
  res@tiYAxisString      = "%"      ; add an axis title
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@gsnCenterString 	="NINO34 SST (1998)"
  res@gsnCenterStringFontHeightF=0.024
  res@tmXBMode   = "Explicit"
  res@tmXBValues            = ispan(1,23,3)
  res@trXMinF               = 0.4
  res@trXMaxF               =23.6
  res@gsnXYBarChartColors = "Magenta"
  res@xyLineColor="Magenta"
  res@tmXBLabels = (/"Jan ~C~1998","Apr ~C~1998","Jul  ~C~1998"," Oct ~C~1998"," Jan ~C~1998","Apr ~C~1999"," Jul ~C~1999"," Oct~C~1999"/)
  xy_plot(0,0) = gsn_csm_xy(wks,fspan(0.85,22.85,23) ,error_98(0,:),res)
  res@xyLineColor="Cyan"
  res@gsnXYBarChartColors = "Cyan"
  xy_plot(0,1) = gsn_csm_xy(wks,fspan(1.15,23.15,23) ,error_98(1,:),res)
  res@xyLineColor="Magenta"
  res@gsnXYBarChartColors = "Magenta"
  res@gsnCenterString 	="NINO34 SST (2003)"
  res@tmXBLabels = (/"Jan ~C~2003","Apr ~C~2003","Jul  ~C~2003"," Oct ~C~2003"," Jan ~C~2003","Apr ~C~2004"," Jul ~C~2004"," Oct ~C~2004"/)
  xy_plot(1,0) = gsn_csm_xy(wks,fspan(0.85,22.85,23),error_03(0,:),res)
  res@xyLineColor="Cyan"
  res@gsnXYBarChartColors = "Cyan"
  xy_plot(1,1) = gsn_csm_xy(wks,fspan(1.15,23.15,23),error_03(1,:),res)
  res@xyLineColor="Magenta"
  res@gsnXYBarChartColors = "Magenta"
  res@gsnCenterString 	="NINO34 SST (2010)"
  res@tmXBLabels = (/"Jan ~C~2010","Apr ~C~2010","Jul  ~C~2010"," Oct ~C~2010"," Jan ~C~2010","Apr ~C~2011"," Jul ~C~2011"," Oct ~C~2011"/)
  xy_plot(2,0) = gsn_csm_xy(wks,fspan(0.85,22.85,23),error_10(0,:),res)
  res@gsnXYBarChartColors = "Cyan"
  res@xyLineColor="Cyan"
  xy_plot(2,1) = gsn_csm_xy(wks,fspan(1.15,23.15,23),error_10(1,:),res)
 
  overlay(xy_plot(0,0),xy_plot(0,1))
  overlay(xy_plot(1,0),xy_plot(1,1))
  overlay(xy_plot(2,0),xy_plot(2,1))

  lbres                    = True          ; labelbar only resources
  lbres@lbPerimOn          = False
  lbres@vpWidthF           = 0.06      ; labelbar width
  lbres@vpHeightF          = 0.018      ; labelbar height
  lbres@lbBoxMajorExtentF  = 0.85          ; puts space between color boxes
  lbres@lbFillColors       = "Magenta" ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.012         ; font height. default is small
  lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
  gsn_labelbar_ndc(wks,1,"Err~B~CLIM~N~",0.641,0.935,lbres)
  gsn_labelbar_ndc(wks,1,"Err~B~CLIM~N~",0.641,0.6,lbres)
  gsn_labelbar_ndc(wks,1,"Err~B~CLIM~N~",0.641,0.1,lbres)

  lbres@lbFillColors     = "cyan" ; labelbar colors
  gsn_labelbar_ndc(wks,1,"Err~B~CONST~N~",0.641,0.957,lbres)
  gsn_labelbar_ndc(wks,1,"Err~B~CONST~N~",0.641,0.622,lbres)
  gsn_labelbar_ndc(wks,1,"Err~B~CONST~N~",0.641,0.122,lbres)

  pres                       =   True
  pres@gsnFrame         = False
  ;pres@gsnPanelMainString="Anomaly monthly SST (199801 - 201112)"
 ; pres@gsnPanelBottom=0.1
 ; pres@gsnPanelLeft=0.05
  pres@gsnPanelLabelBar      = False
  pres@gsnMaximize        =       False
  pres@gsnPanelYWhiteSpacePercent = 4
  gsn_panel(wks,xy_plot(:,0),(/3,1/),pres)
  frame(wks)

end
