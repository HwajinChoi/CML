begin
dir1="/media/cmlws/Data2/hjc/NEMO_TOPAZ/"
dir2=""
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;------------------------------------------------------------------------------------------
f=addfile(dir1+"grid_T_1972-2004.mm.msk.flt.sstemper.nc","r")
sst_topaz1=f->sstemper(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
lat_topaz=f->lat({lat_min:lat_max})
sst_topaz_mon=clmMonTLL(sst_topaz1)
sst_topaz = calcMonAnomTLL(sst_topaz1,sst_topaz_mon)
rad    = 4.0*atan(1.0)/180.0
clat1   = cos(lat_topaz*rad)
sst_topaz_nino34_wgt = wgt_areaave_Wrap(sst_topaz,clat1,1.0,1)
sst_topaz_nino34_wgt!0="time_counter"

g=addfile(dir1+"tptrc_T_1972-2004.mm.msk.flt.sfcchl.nc","r")
chl_topaz1=g->sfcchl(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
chl_topaz_mon=clmMonTLL(chl_topaz1)
chl_topaz = calcMonAnomTLL(chl_topaz1,chl_topaz_mon)
chl_topaz_nino34_wgt = wgt_areaave_Wrap(chl_topaz,clat1,1.0,1)
chl_topaz_nino34_wgt!0="time_counter"
;------------------------------------------------------------------------------------------
topaz_nino34_wgt=new((/2,36/),"float")
topaz_nino34_wgt(0,:)=sst_topaz_nino34_wgt
topaz_nino34_wgt(1,:)=chl_topaz_nino34_wgt
;------------------------------------------------------------------------------------------
;-------------------------- For moving average ------------------------------------
p=3;chunck period
tp=36-p+1;total period after moving averaged
;-----------------------------------------------
EL_mv=new((/2,tp/),"float"); Target
imsi=new((/2,p/),"float"); Chunck

 do k=0,tp-1
  imsi(:,:)=topaz_nino34_wgt(:,k:k+p-1)
  EL_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

EL_mv!1="time"

EL_mv2=new((/2,tp+1/),"float"); Target
EL_mv2(:,0)=(topaz_nino34_wgt(:,0)+topaz_nino34_wgt(:,1))/2
EL_mv2(:,1:tp)=EL_mv

mon=ispan(1,35,1)
;--------------------------------------------------------------------------------------------
  wks = gsn_open_wks("x11",dir3+"SST_CHL_AVE_nino34_NEMO_TOPAZ_extended")
  xy_plot=new(1,graphic)
  bar_plot=new(1,graphic)
  res                          = True
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  res@tmXBFormat = "f"        ; remove the trailing ".0"
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
  res@gsnYRefLine       =0
  res@gsnYRefLineColor = "black"
  res@gsnYRefLineDashPattern=0
  res@xyMarkLineMode      =(/"MarkLines"/)
  res@xyMonoLineColor    = True             ; want colored lines
  res@xyMarkerThicknessF    = 3.
  res@xyLineThicknessF    = 4.
  res@xyMarker=4
  res@xyDashPattern     = 0.
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@gsnLeftStringFontHeightF=0.024
  res@tmXBMode   = "Explicit"
  res@tmXBValues = mon(::3)     ; choose first 13 timesteps
  res@tmXBLabels = (/" Jan "," Apr "," Jul "," Oct "," Jan "," Apr "," Jul "," Oct "," Jan "," Apr "," Jul "," Oct "/)
  res@tmXMajorGrid= True
  res@tmXMajorGridLineDashPattern=2
;  res@tmYMajorGridThicknessF      = 1.0
  res2=res
  res@tiYAxisString      = "~F35~J~F~C"      ; add an axis title
  res@gsnLeftString   ="NEMO-TOPAZ"
  res@trYMinF                  = -2
  res@trYMaxF                  =2
  res@xyLineColor       = (/"black"/) ; colors chosen
  res@xyMarkerColor=(/"black"/)
  res@tmYLMode          = "Manual"
  res@tmYLTickSpacingF  =  1
  res@tmYLTickStartF    = -2
  res@tmYLTickEndF      = 2
  res@tmYLMinorPerMajor=4
  res2@tiYAxisString      = "ug/kg"      ; add an axis title
  res2@tmYRLabelFontColor="green"
  res2@xyLineColor       = (/"green"/) ; colors chosen
  res2@xyMarkerColor=(/"green"/)
  res2@gsnCenterString   =""
  res2@tmYLMode          = "Manual"
  ;res2@tmYLTickSpacingF  =  1
  res2@tmYLTickStartF    = -0.15
  res2@tmYLTickEndF      = 0.15
  res2@trYMinF                  = -0.15
  res2@trYMaxF                  =0.15
  xy_plot = gsn_csm_xy2(wks,mon,EL_mv2(0,:),EL_mv2(1,:),res,res2)

;  lineres = True
;  lineres@lgPerimDashSegLenF=0.01
;  lineres@lgMonoItemType     = True
;  lineres@lgMonoLineDashSegLen=True
;  lineres@lgLineLabelConstantSpacingF=0.1
;  lineres@lgMonoLineThickness =True
;  lineres@lgLabelFontHeightF =0.22
;  lineres@vpWidthF           = 0.14
;  lineres@lgDashIndex=0
;  lineres@vpHeightF          = 0.08
;  lineres@lgItemType="MarkLines"
;  lineres@lgMarkerIndexes    =16
;  lineres@lgLineColors = "blue"
;  lineres@lgMarkerColors = "blue"
;  lineres@lgLineThicknessF = 4
;  lineres@lgLineLabelFontThicknessF=6
;  lineres@lgMonoMarkerThickness=True
;  lineres@lgMarkerThicknessF=1
;  lineres@lgPerimOn              = False
;  lineres@LineLengthPercent = 5
;  labels = (/"NEMO_TOPAZ"/)  ; legend labels (required
;  gsn_legend_ndc(wks,1,labels,0.75,0.82,lineres)

  draw(xy_plot)
  frame(wks)

end
