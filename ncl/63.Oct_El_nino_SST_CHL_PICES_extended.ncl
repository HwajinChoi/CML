begin

dir1="/media/cmlws/Data2/hjc/NEMO_TOPAZ/NEMO_PISCES/"
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
rad    = 4.0*atan(1.0)/180.0
;------------------------------------------------------------------------------------------
f=addfile(dir1+"chl_PISCES_200201_200412_tos.nc","r")
tos_02 =f->tos; time_counter x lat x lon
sst_02 =tos_02(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max});time*lat*lon
lat    =f->lat({lat_min:lat_max})
sst_02_mon=clmMonTLL(sst_02)
sst_02_pices = calcMonAnomTLL(sst_02,sst_02_mon)
clat1  = cos(lat*rad)
sst_02_nino34_wgt = wgt_areaave_Wrap(sst_02_pices,clat1,1.0,1)
;------------------------------------------------------------------------------------------
f1=addfile(dir1+"chl_PISCES_199710_199912_tos.nc","r")
tos_97 =f1->tos
sst_97 =tos_97(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max});time*lat*lon
dim=dimsizes(sst_97)

sst_97_pices=new((/dim(0),dim(1),dim(2)/),"float")
sst_97_pices(0:2,:,:)=sst_97(0:2,:,:)-sst_02_mon(9:11,:,:)
sst_97_pices(3:14,:,:)=sst_97(3:14,:,:)-sst_02_mon
sst_97_pices(15:dim(0)-1,:,:)=sst_97(15:dim(0)-1,:,:)-sst_02_mon
copy_VarCoords(sst_97,sst_97_pices)
sst_97_nino34_wgt = wgt_areaave_Wrap(sst_97_pices,clat1,1.0,1)

sst_wgt=new((/2,27/),"float")
sst_wgt(0,:)=sst_02_nino34_wgt(9:35)
sst_wgt(1,:)=sst_97_nino34_wgt
sst_wgt!0="case"
sst=dim_avg_n_Wrap(sst_wgt,0)
;------------------------------------------------------------------------------------------
g1=addfile(dir1+"chl_PISCES_200201_200412_chl.nc","r")
NCHL_02=g1->NCHL
DCHL_02=g1->DCHL
chl_02_2=NCHL_02+DCHL_02
copy_VarCoords(NCHL_02,chl_02_2)
chl_02=chl_02_2(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
lat    =g1->lat({lat_min:lat_max})
chl_02_mon=clmMonTLL(chl_02)
chl_02_pices = calcMonAnomTLL(chl_02,chl_02_mon)
chl_02_nino34_wgt = wgt_areaave_Wrap(chl_02_pices,clat1,1.0,1)
;------------------------------------------------------------------------------------------
g=addfile(dir1+"chl_PISCES_199710_199912_chl.nc","r")
NCHL_97=g->NCHL
DCHL_97=g->DCHL
chl_97_02=NCHL_97+DCHL_97
copy_VarCoords(NCHL_97,chl_97_02)
chl_97=chl_97_02(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
chl_97_pices=new((/dim(0),dim(1),dim(2)/),"float")
chl_97_pices(0:2,:,:)=chl_97(0:2,:,:)-chl_02_mon(9:11,:,:)
chl_97_pices(3:14,:,:)=chl_97(3:14,:,:)-chl_02_mon
chl_97_pices(15:dim(0)-1,:,:)=chl_97(15:dim(0)-1,:,:)-chl_02_mon
copy_VarCoords(chl_97,chl_97_pices)
chl_97_nino34_wgt = wgt_areaave_Wrap(chl_97_pices,clat1,1.0,1)

chl_wgt=new((/2,27/),"float")
chl_wgt(0,:)=chl_02_nino34_wgt(9:35)
chl_wgt(1,:)=chl_97_nino34_wgt
chl_wgt!0="case"
chl=dim_avg_n_Wrap(chl_wgt,0)

pices_nino34_wgt=new((/2,27/),"float")
pices_nino34_wgt(0,:)=sst
pices_nino34_wgt(1,:)=chl
pices_nino34_wgt!0="variable"

;-------------------------- For moving average ------------------------------------
p=3;chunck period
tp1=27-p+1;total period after moving averaged
;-----------------------------------------------
EL_mv=new((/2,tp1/),"float"); Target
imsi=new((/2,p/),"float"); Chunck

 do k=0,tp1-1
  imsi(:,:)=pices_nino34_wgt(:,k:k+p-1)
  EL_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
EL_mv!1="time"

EL_mv_97=new((/2,tp1+1/),"float"); Target
EL_mv_97(:,0)=(pices_nino34_wgt(:,0)+pices_nino34_wgt(:,1))/2
EL_mv_97(:,1:tp1)=EL_mv
mon_97=ispan(1,26,1)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("png",dir3+"BAR_SST_CHL_AVE_nino34_NEMO_PISCES_extended")
  xy_plot=new(2,graphic)
  res                          = True
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  res@tmXBFormat = "f"        ; remove the trailing ".0"
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
  res@gsnYRefLine       =0
  res@gsnYRefLineColor = "black"
  res@gsnYRefLineDashPattern=0
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@tmXBMode   = "Explicit"
  res@tmXBValues = mon_97(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/" Oct "," Jan "," Apr "," Jul "," Oct "," Jan "," Apr "," Jul "," Oct "/)
  res@tmXMajorGrid= True
  res@tmXMajorGridLineDashPattern=2
;  res@tmYMajorGridThicknessF      = 1.0
  res2=res
  res@gsnXYBarChartColors   = "black"
  res@gsnXYBarChart         = True
  res@gsnXYBarChartBarWidth = 0.55
  res2@xyMonoLineColor    = True             ; want colored lines
  res2@xyMarkLineMode      =(/"MarkLines"/)
  res2@xyMarkerThicknessF    = 3.
  res2@xyLineThicknessF    = 4.
  res2@xyMarker		=	4
  res2@xyDashPattern     = 0.
  res2@gsnCenterStringFontHeightF=0.026
  res@tiYAxisString      = "~F35~J~F~C"      ; add an axis title
  res@gsnLeftString   =""
  res2@gsnCenterStringOrthogonalPosF=0.1
  res2@tiYAxisString      = "mg/m~S~3~N~"      ; add an axis title
  res2@tiYAxisFontColor="green"
  res2@tmYRLabelFontColor="green"
  res2@xyLineColor       = (/"green"/) ; colors chosen
  res2@xyMarkerColor=(/"green"/)
  res2@gsnCenterString   ="NEMO-PISCES"
  ;res2@tmYLTickSpacingF  =  1
;--------------------------------------------------------
  res2@tmYRMode          = "Manual"
  res2@tmYRTickStartF    = -0.15
  res2@tmYRTickEndF      = 0.15
  res2@trYMinF                  = -0.15
  res2@trYMaxF                  =0.15
  res@tmYLMode          = "Manual"
  res@trYMinF                  = -3.
  res@trYMaxF                  =3.
  res@tmYLTickSpacingF  =  1.
  res@tmYLTickStartF    = -3.
  res@tmYLTickEndF      = 3.
  res@tmYLMinorPerMajor=4
;--------------------------------------------------------
  xy_plot = gsn_csm_xy2(wks,mon_97,EL_mv_97(0,:),EL_mv_97(1,:),res,res2)
  draw(xy_plot)
  frame(wks)

end
