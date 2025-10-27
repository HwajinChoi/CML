begin
dir1="/media/cmlws/Data2/hjc/NEMO_TOPAZ/pro/"
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;------------------------------------------------------------------------------------------
files=systemfunc("ls "+dir1+"grid_T_*.mm.msk.flt.sstemper.nc")
fs=systemfunc("ls "+dir1+"grid_T_*.mm.msk.flt.sstemper.nc | head -1")
fs1=addfile(fs,"r")
f=addfiles(files,"r")
ListSetType(f,"join")
sstemper=f[:]->sstemper; case x time_counter x lat x lon
sstemper!0="case"
sstemper := sstemper(time_counter|:,case|:,lat|:,lon|:)
sst_topaz1=sstemper(:,:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max});case*time*lat*lon
lat_topaz=fs1->lat({lat_min:lat_max})
sst_topaz_mon=clmMonTLLL(sst_topaz1)
sst_topaz = calcMonAnomTLLL(sst_topaz1,sst_topaz_mon)
rad     = 4.0*atan(1.0)/180.0
clat1   = cos(lat_topaz*rad)
sst_topaz_nino34_wgt = wgt_areaave_Wrap(sst_topaz,clat1,1.0,1)

gfiles=systemfunc("ls "+dir1+"tptrc_T_*.mm.msk.flt.sfcchl.nc")
gs=systemfunc("ls "+dir1+"tptrc_T_*.mm.msk.flt.sfcchl.nc | head -1")
g=addfiles(gfiles,"r")
gs1=addfile(gs,"r")
ListSetType(g,"join")
sfcchl=g[:]->sfcchl
sfcchl!0="case"
sfcchl := sfcchl(time_counter|:,case|:,lat|:,lon|:)
chl_topaz1=sfcchl(:,:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
chl_topaz_mon=clmMonTLLL(chl_topaz1)
chl_topaz = calcMonAnomTLLL(chl_topaz1,chl_topaz_mon)
chl_topaz_nino34_wgt = wgt_areaave_Wrap(chl_topaz,clat1,1.0,1)
;------------------------------------------------------------------------------------------
topaz_nino34_wgt=new((/2,36,5/),"float")
topaz_nino34_wgt(0,:,:)=sst_topaz_nino34_wgt
topaz_nino34_wgt(1,:,:)=chl_topaz_nino34_wgt
topaz_nino34_wgt!0="variable"
topaz_nino34_wgt := topaz_nino34_wgt(variable|:,case|:,time_counter|:)
;------------------------------------------------------------------------------------------
;-------------------------- For moving average ------------------------------------
p=3;chunck period
tp=36-p+1;total period after moving averaged
;-----------------------------------------------
EL_mv=new((/2,5,tp/),"float"); Target
imsi=new((/2,5,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:,:)=topaz_nino34_wgt(:,:,k:k+p-1)
  EL_mv(:,:,k)=dim_avg_n_Wrap(imsi,2)
  imsi=imsi@_FillValue
 end do

EL_mv!2="time"

EL_mv2=new((/2,5,tp+1/),"float"); Target
EL_mv2(:,:,0)=(topaz_nino34_wgt(:,:,0)+topaz_nino34_wgt(:,:,1))/2
EL_mv2(:,:,1:tp)=EL_mv

mon=ispan(1,35,1)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("png",dir3+"Case_studies_BAR_SST_CHL_AVE_nino34_NEMO_TOPAZ_extended")
  xy_plot=new(5,graphic)
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
  res@tmXBValues = mon(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/" Jan "," Apr "," Jul "," Oct "," Jan "," Apr "," Jul "," Oct "," Jan "," Apr "," Jul "," Oct "/)
  res@tmXMajorGrid= True
  res@tmXMajorGridLineDashPattern=2
;  res@tmYMajorGridThicknessF      = 1.0
  res2=res
  res2@gsnCenterStringFontHeightF=0.026
  res@tiYAxisString      = "~F35~J~F~C"      ; add an axis title
  res@gsnLeftString   =""
  res@gsnXYBarChartColors   = "black"
  res@gsnXYBarChart         = True
  res@gsnXYBarChartBarWidth = 0.55
  res2@xyMarkerThicknessF    = 3.
  res2@xyLineThicknessF    = 4.
  res2@xyMarker          =       4
  res2@xyDashPattern     = 0.
  res2@xyMarkLineMode      =(/"MarkLines"/)
  res2@gsnCenterStringOrthogonalPosF=0.1
  res2@tiYAxisString      = "ug/kg"      ; add an axis title
  res2@tiYAxisFontColor="green"
  res2@tmYRLabelFontColor="green"
  res2@xyLineColor       = (/"green"/) ; colors chosen
  res2@xyMarkerColor=(/"green"/)
  res2@gsnCenterString   ="1972 - 1974"
  ;res2@tmYLTickSpacingF  =  1
;--------------------------------------------------------
  res2@tmYLMode          = "Manual"
  res2@tmYLTickStartF    = -0.15
  res2@tmYLTickEndF      = 0.15
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
  xy_plot(0) = gsn_csm_xy2(wks,mon,EL_mv2(0,0,:),EL_mv2(1,0,:),res,res2)
  res2@gsnCenterString   ="1982 - 1984"
  res2@tmYLTickStartF    = -0.3
  res2@tmYLTickEndF      = 0.3
  res2@trYMinF                  = -0.3
  res2@trYMaxF                  =0.3

  res@trYMinF                  = -3.
  res@trYMaxF                  =3.
  ;res@tmYLTickSpacingF  =  1.
  res@tmYLTickStartF    = -3.
  res@tmYLTickEndF      = 3.
  xy_plot(1) = gsn_csm_xy2(wks,mon,EL_mv2(0,1,:),EL_mv2(1,1,:),res,res2)
  res2@gsnCenterString   ="1991 - 1993"
  res@trYMinF                  = -2.0
  res@trYMaxF                  =2.0
  res@tmYLTickSpacingF  =  1.0
  res@tmYLTickStartF    = -2.0
  res@tmYLTickEndF      = 2.0
  res2@tmYLTickStartF    = -0.10
  res2@tmYLTickEndF      = 0.10
  res2@tmYLTickSpacingF  =  0.5
  res2@trYMinF                  = -0.10
  res2@trYMaxF                  =0.10
  xy_plot(2) = gsn_csm_xy2(wks,mon,EL_mv2(0,2,:),EL_mv2(1,2,:),res,res2)
  res2@gsnCenterString   ="1997 - 1999"
  res@trYMinF                  = -3.5
  res@trYMaxF                  =3.5
  res@tmYLTickSpacingF  =  1
  res@tmYLTickStartF    = -4.
  res@tmYLTickEndF      = 4.
  res2@tmYLTickStartF    = -0.25
  res2@tmYLTickEndF      = 0.25
  res2@tmYLTickSpacingF  =  0.1
  res2@trYMinF                  = -0.25
  res2@trYMaxF                  =0.25
  xy_plot(3) = gsn_csm_xy2(wks,mon,EL_mv2(0,3,:),EL_mv2(1,3,:),res,res2)
  res2@gsnCenterString   ="2002 - 2004"
  res@trYMinF                  = -2.
  res@trYMaxF                  =2.
  res@tmYLTickSpacingF  =  1
  res@tmYLTickStartF    = -2.
  res@tmYLTickEndF      = 2.
  res2@tmYLTickStartF    = -0.1
  res2@tmYLTickEndF      = 0.1
  res2@trYMinF                  = -0.1
  res2@trYMaxF                  =0.1
  xy_plot(4) = gsn_csm_xy2(wks,mon,EL_mv2(0,4,:),EL_mv2(1,4,:),res,res2)

  pres                       =   True
  pres@gsnFrame         = False
  pres@gsnPanelMainString="NEMO-TOPAZ"
 ; pres@gsnPanelBottom=0.1
 ; pres@gsnPanelLeft=0.05
  pres@gsnPanelLabelBar      = False
  pres@gsnMaximize        =       True
  pres@gsnPanelYWhiteSpacePercent = 4
  pres@gsnPanelRowSpec = True
  gsn_panel(wks,xy_plot,(/2,2,1/),pres)
  frame(wks)

end
