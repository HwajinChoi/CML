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

;data(oisst,clim,const,inter)
EL_mv!1="time"
EL_mv2=new((/4,tp+1/),"float"); Target
EL_mv2(:,0)=(EL(:,0)+EL(:,1))/2
EL_mv2(:,1:tp)=EL_mv

CLIM_ave=((abs(EL_mv2(0,:)-EL_mv2(1,:))-abs(EL_mv2(0,:)-EL_mv2(3,:)))/abs(EL_mv2(0,:)-EL_mv2(1,:)))*100
CONST_ave=((abs(EL_mv2(0,:)-EL_mv2(2,:))-abs(EL_mv2(0,:)-EL_mv2(3,:)))/abs(EL_mv2(0,:)-EL_mv2(2,:)))*100

mon=ispan(1,23,3)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("png",dir3+"3_moving_ERROR_AVE_bar_nino34_SST_timeseries")   
  xy_plot=new((/1,2/),graphic)
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
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
  res@gsnYRefLine       =0
  res@gsnYRefLineColor = "black"
  res@gsnYRefLineDashPattern=0
  res@gsnXYBarChart         = True
  res@gsnXYBarChartBarWidth = 0.3           ; change bar widths
  res@tiYAxisString      = "%"      ; add an axis title
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@gsnCenterString 	="NINO34 SST "
  res@gsnCenterStringFontHeightF=0.024
  res@tmXBMode   = "Explicit"
  res@tmXBValues = mon
  res@trXMinF               = 0.4
  res@trXMaxF               =23.6
  res@gsnXYBarChartColors = "Magenta"
  res@xyLineColor="Magenta"
  res@tmXBLabels = (/" Jan "," Apr "," Jul "," Oct "," Jan "," Apr "," Jul "," Oct "/) 
  xy_plot(0,0) = gsn_csm_xy(wks,fspan(0.85,22.85,23),CLIM_ave,res)
  res@xyLineColor="Cyan"
  res@gsnXYBarChartColors = "Cyan"
  xy_plot(0,1) = gsn_csm_xy(wks,fspan(1.15,23.15,23),CONST_ave,res)
  overlay(xy_plot(0,0),xy_plot(0,1))

  lbres                    = True          ; labelbar only resources
  lbres@lbPerimOn          = False
  lbres@vpWidthF           = 0.10      ; labelbar width
  lbres@vpHeightF          = 0.025      ; labelbar height
  lbres@lbBoxMajorExtentF  = 0.85          ; puts space between color boxes
  lbres@lbFillColors       = "Magenta" ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.015         ; font height. default is small
  lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
  gsn_labelbar_ndc(wks,1,"Err~B~CLIM~N~",0.78,0.44,lbres)
  lbres@lbFillColors     = "cyan" ; labelbar colors
  gsn_labelbar_ndc(wks,1,"Err~B~CONST~N~",0.78,0.472,lbres)

  draw(xy_plot)
  frame(wks)

end
