begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"

;-----Regional grid----------------
;   Tropical Pacific
;----------------------------------------------
lon1_s=110
lon1_f=300
lat1_s=-20
lat1_f=20
M=(/"ESM4-PDAF","EN4","ECDA","GODAS","ECCO","SODA"/)
colors=(/"red","magenta","gold","green","blue","purple"/)
lon2_s=120
lon2_f=250
lat2_s=20
lat2_f=60

g0=addfile(dir1+"tos_EN4_3moving_ano_2015-2021.nc","r")
tos_en=g0->tos;time x lat x lon
tos_en4=dtrend_n(tos_en,False,0)
copy_VarMeta(tos_en,tos_en4)
tos_EN4_trop=tos_en4(:,{lat1_s:lat1_f},{lon1_s:lon1_f})
tos_EN4_np=tos_en4(:,{lat2_s:lat2_f},{lon2_s:lon2_f})

f0=addfile(dir1+"tos_detrend_ODA_3moving_ano_2015-2021.nc","r")
tos_oda_trop=f0->tos(:,{lat1_s:lat1_f},{lon1_s:lon1_f})
tos_oda_np=f0->tos(:,{lat2_s:lat2_f},{lon2_s:lon2_f})

g=addfile(dir1+"Tropical_Pacific_tos_EOF_1st_3moving_ano_PC_timeseries_2010-2021.nc","r")
PC_time=g->pc_timeseries(:,60::)
dim=dimsizes(PC_time)

g2=addfile(dir1+"North_Pacific_tos_EOF_1st_3moving_ano_PC_timeseries_2010-2021.nc","r")
PC_time_np=g2->pc_timeseries(:,60::)
;----------------------------------------------
neof   = 3        ; number of EOFs
optEOF = True
optEOF@jopt = 0
optETS = False
;----------------------------------------------
tos_oda_eof_trop      = eofunc_n_Wrap(tos_oda_trop, neof, optEOF,0)
tos_oda_eof_np      = eofunc_n_Wrap(tos_oda_np, neof, optEOF,0)
tos_oda_eof_np=tos_oda_eof_np*(-1)

tos_en4_eof_trop=eofunc_n_Wrap(tos_EN4_trop, neof, optEOF,0)
tos_en4_eof_ts_trop=eofunc_ts_n_Wrap(tos_EN4_trop,tos_en4_eof_trop, optETS,0)

tos_en4_eof_np=eofunc_n_Wrap(tos_EN4_np, neof, optEOF,0)
tos_en4_eof_ts_np=eofunc_ts_n_Wrap(tos_EN4_np,tos_en4_eof_np, optETS,0)
tos_en4_eof_ts_np=tos_en4_eof_ts_np*(-1)

PC_trop=new((/dim(0),dim(1)/),"float")
PC_trop(0,:)=PC_time(0,:)
PC_trop(1,:)=tos_en4_eof_ts_trop(0,:)
PC_trop(2:dim(0)-1,:)=PC_time(2:dim(0)-1,:)

PC_np=new((/dim(0),dim(1)/),"float")
PC_np(0,:)=PC_time_np(0,:)
PC_np(1,:)=tos_en4_eof_ts_np(0,:)
PC_np(2:dim(0)-1,:)=PC_time_np(2:dim(0)-1,:)

A=new(6,"float")
A=2.0
B=new(6,"integer")
B=0
y=ispan(1,82,1)

plot=new(4,graphic)
wks=gsn_open_wks("pdf",dir0+"figure9_EOF_1st_mode_map_Trop_North_Pacific_2015-2021")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@gsnCenterStringFontHeightF=0.028
res@gsnLeftString=""
res2=res
res@gsnAddCyclic         = False        ; data not cyclic
res@pmLabelBarWidthF=0.7
res@cnFillPalette        = "BlueDarkRed18"
res@mpShapeMode  = "FreeAspect"
res@vpHeightF=0.2
res@vpWidthF=0.8
res@mpCenterLonF         = 180.         ; defailt is 0 [GM]
res@mpMinLatF            = lat1_s
res@mpMaxLatF            = lat1_f
res@mpMinLonF            = lon1_s
res@mpMaxLonF            = lon1_f
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnLineLabelsOn         =       False
res@cnMaxLevelValF         =      0.04
res@cnMinLevelValF         =      -0.04
res@cnLevelSpacingF        =       0.005
res@mpFillDrawOrder      = "PostDraw"
res@cnFillOn             = True         ; turn on color fill
res@cnLinesOn            = False         ; True is default
res@lbLabelBarOn         = True        ; turn off individual lb's
res@pmLabelBarOrthogonalPosF=0.3
res@mpLandFillColor      = "black"
res@tmXBLabelFontHeightF   =       0.02
res@tmYLLabelFontHeightF   =       0.02
;res@tmYLMinorPerMajor=1
res@tmYLLabelStride     =       2
res@gsnCenterString="(a) EOF1 | Tropical Pacific | ESM4-PDAF"
plot(0) = gsn_csm_contour_map(wks,tos_oda_eof_trop(0,:,:),res)
res@mpMinLatF            = lat2_s
res@mpMaxLatF            = lat2_f
res@mpMinLonF            = lon2_s
res@mpMaxLonF            = lon2_f
res@gsnCenterString="(b) EOF1 | North Pacific | ESM4-PDAF"
plot(1) = gsn_csm_contour_map(wks,tos_oda_eof_np(0,:,:),res)
res2@vpHeightF=0.4
res2@vpWidthF=0.8
res2@gsnYRefLine=0
res2@gsnYRefLineDashPattern=0
res2@gsnYRefLineThicknessF=2
res2@gsnYRefLineColor=(/"black"/)
res2@gsnRightString=""
res2@tiXAxisString ="Time"
res2@tiXAxisFontHeightF=0.023
res2@tiYAxisString =""
res2@tiMainString=""
res2@trXMinF  = 0
res2@trXMaxF=82
res2@tmXBMode="Explicit"
res2@tmXBValues=(/0,24,48,72/)
res2@tmXBLabels=(/2015,2017,2019,2021/)
res2@tmXBLabelFontHeightF=0.022
res2@tmYLLabelFontHeightF=0.022
res2@xyLineThicknesses    = A
res2@xyDashPatterns=B
res2@xyLineColors=colors
res2@gsnCenterString="(c) PC1 | Tropical Pacific | ESM4-PDAF"
plot(2)=gsn_csm_xy(wks,y,PC_trop,res2)
res2@gsnCenterString="(d) PC1 | North Pacific | ESM4-PDAF"
plot(3)=gsn_csm_xy(wks,y,PC_np,res2)

gres = True
gres@YPosPercent = 96    ; expressed as %, 0->100, sets position of top border of legend 
gres@XPosPercent = 73      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
gres@ItemSpacePercent = 6.
lineres = True
lineres@lgLineColors = colors(::-1)
lineres@lgLineThicknesses = 5                        ; line thicknesses
lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
textres = True
textres@lgLabelFontHeights = (/0.018,0.018,0.018,0.018/)                           ; label font heights
textres@lgLabels = M(::-1)
plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
gres@YPosPercent = 34    ; expressed as %, 0->100, sets position of top border of legend 
gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

; panel plot only resources
resP                     = True         ; modify the panel plot
;resP@gsnMaximize         = True         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelMainString  = ""
gsn_panel(wks,plot,(/2,2/),resP)     ; draw all 'neof' as one plot

end
