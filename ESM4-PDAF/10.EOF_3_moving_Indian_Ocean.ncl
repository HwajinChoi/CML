begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"

;-----Regional grid----------------
;   Tropical Pacific
;----------------------------------------------
T="Indian_Ocean"
lon_s=30
lon_f=110
lat_s=-20
lat_f=20
M=(/"ESM4-PDAF_ocean","ESM4-PDAF_coupled","ECDA","GODAS","ECCO","SODA"/)

f0=addfile(dir1+"tos_detrend_ODA_3moving_ano_2015-2021.nc","r")
tos_oda=f0->tos(:,{lat_s:lat_f},{lon_s:lon_f})
f1=addfile(dir1+"tos_detrend_AODA_3moving_ano_2010-2021.nc","r")
tos_aoda=f1->tos(:,{lat_s:lat_f},{lon_s:lon_f})
f2=addfile(dir1+"tos_detrend_ECDA_3moving_ano_2010-2017.nc","r")
tos_ecda=f2->tos(:,{lat_s:lat_f},{lon_s:lon_f})
f3=addfile(dir1+"tos_detrend_GODAS_3moving_ano_2010-2021.nc","r")
tos_godas=f3->tos(:,{lat_s:lat_f},{lon_s:lon_f})
f4=addfile(dir1+"tos_detrend_ECCO_3moving_ano_2010-2017.nc","r")
tos_ecco=f4->tos(:,{lat_s:lat_f},{lon_s:lon_f})
f5=addfile(dir1+"tos_detrend_SODA_3moving_ano_2010-2021.nc","r")
tos_soda=f5->tos(:,{lat_s:lat_f},{lon_s:lon_f})
;----------------------------------------------
neof   = 3        ; number of EOFs
optEOF = True       
optEOF@jopt = 0
optETS = False
;----------------------------------------------
tos_oda_eof      = eofunc_n_Wrap(tos_oda, neof, optEOF,0)
tos_oda_eof_ts   = eofunc_ts_n_Wrap (tos_oda, tos_oda_eof, optETS,0)

tos_aoda_eof      = eofunc_n_Wrap(tos_aoda, neof, optEOF,0)
tos_aoda_eof_ts   = eofunc_ts_n_Wrap (tos_aoda, tos_aoda_eof, optETS,0)
tos_aoda_eof=tos_aoda_eof*(-1)
tos_aoda_eof_ts=tos_aoda_eof_ts*(-1)

tos_ecda_eof      = eofunc_n_Wrap(tos_ecda, neof, optEOF,0)
tos_ecda_eof_ts   = eofunc_ts_n_Wrap (tos_ecda, tos_ecda_eof, optETS,0)
tos_ecda_eof=tos_ecda_eof*(-1)
tos_ecda_eof_ts=tos_ecda_eof_ts*(-1)

tos_godas_eof      = eofunc_n_Wrap(tos_godas, neof, optEOF,0)
tos_godas_eof_ts   = eofunc_ts_n_Wrap (tos_godas, tos_godas_eof, optETS,0)
tos_godas_eof=tos_godas_eof*(-1)
tos_godas_eof_ts=tos_godas_eof_ts*(-1)

tos_ecco_eof      = eofunc_n_Wrap(tos_ecco, neof, optEOF,0)
tos_ecco_eof_ts   = eofunc_ts_n_Wrap (tos_ecco, tos_ecco_eof, optETS,0)
tos_ecco_eof=tos_ecco_eof*(-1)
tos_ecco_eof_ts=tos_ecco_eof_ts*(-1)

tos_soda_eof      = eofunc_n_Wrap(tos_soda, neof, optEOF,0)
tos_soda_eof_ts   = eofunc_ts_n_Wrap (tos_soda, tos_soda_eof, optETS,0)
tos_soda_eof=tos_soda_eof*(-1)
tos_soda_eof_ts=tos_soda_eof_ts*(-1)

PC_time=new((/6,142/),"float")
PC_time@_FillValue=-999
PC_time=-999
PC_time(0,60:141)=tos_oda_eof_ts(0,:)
PC_time(1,:)=tos_aoda_eof_ts(0,:)
PC_time(2,0:93)=tos_ecda_eof_ts(0,:)
PC_time(3,:)=tos_godas_eof_ts(0,:)
PC_time(4,0:93)=tos_ecco_eof_ts(0,:)
PC_time(5,:)=tos_soda_eof_ts(0,:)
PC_time!0="data"

system("rm -f "+dir1+T+"_tos_EOF_1st_3moving_ano_PC_timeseries_2010-2021.nc")
out=addfile(    dir1+T+"_tos_EOF_1st_3moving_ano_PC_timeseries_2010-2021.nc","c")
out->pc_timeseries=PC_time
exit
;printMinMax(tos_oda_eof(0,:,:),0)
;printMinMax(tos_aoda_eof(0,:,:),0)
;printMinMax(tos_ecda_eof(0,:,:),0)
;printMinMax(tos_godas_eof(0,:,:),0)
;printMinMax(tos_ecco_eof(0,:,:),0)
;printMinMax(tos_soda_eof(0,:,:),0)

plot=new(6,graphic)
wks=gsn_open_wks("png",dir0+"EOF_1st_mode_map_"+T)
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@gsnAddCyclic         = False        ; data not cyclic
res@cnFillPalette        = "BlueDarkRed18"
res@mpCenterLonF         = 180.         ; defailt is 0 [GM]
res@mpMinLatF            = lat_s
res@mpMaxLatF            = lat_f
res@mpMinLonF            = lon_s
res@mpMaxLonF            = lon_f 
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnLineLabelsOn         =       False
res@cnMaxLevelValF         =      0.04
res@cnMinLevelValF         =      -0.04
res@cnLevelSpacingF        =       0.005
res@mpFillDrawOrder      = "PostDraw"
res@cnFillOn             = True         ; turn on color fill
res@cnLinesOn            = False         ; True is default
res@lbLabelBarOn         = False        ; turn off individual lb's
res@mpLandFillColor      = "black" 
res@tmXBLabelFontHeightF   =       0.02
res@tmYLLabelFontHeightF   =       0.02
;res@tmYLMinorPerMajor=1
res@gsnLeftStringFontHeightF=0.028
res@gsnRightStringFontHeightF=0.025
res@tmYLLabelStride     =       2
;symMinMaxPlt(tos_oda_eof, 16, False, res); contributed.ncl

; panel plot only resources
resP                     = True         ; modify the panel plot
resP@gsnMaximize         = True         ; large format
resP@gsnPanelLabelBar    = True         ; add common colorbar
resP@lbLabelFontHeightF  = 0.012
resP@gsnPanelYWhiteSpacePercent = 7
resP@pmLabelBarWidthF=0.75

resP@gsnPanelMainString  = ""
res@gsnRightString = sprintf("%5.1f", tos_oda_eof@pcvar(0)) +"%"
res@gsnLeftString  = M(0)
plot(0) = gsn_csm_contour_map(wks,tos_oda_eof(0,:,:),res)
res@gsnRightString = sprintf("%5.1f", tos_aoda_eof@pcvar(0)) +"%"
res@gsnLeftString  = M(1)
plot(1) = gsn_csm_contour_map(wks,tos_aoda_eof(0,:,:),res)
res@gsnLeftString  = M(2)
res@gsnRightString = sprintf("%5.1f", tos_ecda_eof@pcvar(0)) +"%"
plot(2) = gsn_csm_contour_map(wks,tos_ecda_eof(0,:,:),res)
res@gsnLeftString  = M(3)
res@gsnRightString = sprintf("%5.1f", tos_godas_eof@pcvar(0)) +"%"
plot(3) = gsn_csm_contour_map(wks,tos_godas_eof(0,:,:),res)
res@gsnLeftString  = M(4)
res@gsnRightString = sprintf("%5.1f", tos_ecco_eof@pcvar(0)) +"%"
plot(4) = gsn_csm_contour_map(wks,tos_ecco_eof(0,:,:),res)
res@gsnLeftString  = M(5)
res@gsnRightString = sprintf("%5.1f", tos_soda_eof@pcvar(0)) +"%"
plot(5) = gsn_csm_contour_map(wks,tos_soda_eof(0,:,:),res)
gsn_panel(wks,plot,(/3,2/),resP)     ; draw all 'neof' as one plot

end
