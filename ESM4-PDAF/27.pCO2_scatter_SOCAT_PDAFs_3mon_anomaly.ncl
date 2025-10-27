begin
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"

NP_lon_s=140
NP_lon_f=250
NP_lat_s=10
NP_lat_f=50

NA_lon_s=300
NA_lon_f=350
NA_lat_s=10
NA_lat_f=60

f1=addfile(dir1+"co2_ODA_3moving_ano_2015-2021.nc","r")
co2_oda_NP=f1->co2(:,{NP_lat_s:NP_lat_f},{NP_lon_s:NP_lon_f})
co2_oda_NA=f1->co2(:,{NA_lat_s:NA_lat_f},{NA_lon_s:NA_lon_f})

co2_oda_NP1=dim_avg_n_Wrap(co2_oda_NP,1)
co2_oda_NP2=dim_avg_n_Wrap(co2_oda_NP1,1)
co2_oda_NA1=dim_avg_n_Wrap(co2_oda_NA,1)
co2_oda_NA2=dim_avg_n_Wrap(co2_oda_NA1,1)

f2=addfile(dir1+"co2_SOCAT_3moving_ano_2015-2021.nc","r")
co2_socat_for_oda_NP=f2->co2(:,{NP_lat_s:NP_lat_f},{NP_lon_s:NP_lon_f})
co2_socat_for_oda_NA=f2->co2(:,{NA_lat_s:NA_lat_f},{NA_lon_s:NA_lon_f})

co2_socat_for_oda_NP1=dim_avg_n_Wrap(co2_socat_for_oda_NP,1)
co2_socat_for_oda_NP2=dim_avg_n_Wrap(co2_socat_for_oda_NP1,1)
co2_socat_for_oda_NA1=dim_avg_n_Wrap(co2_socat_for_oda_NA,1)
co2_socat_for_oda_NA2=dim_avg_n_Wrap(co2_socat_for_oda_NA1,1)

f3=addfile(dir1+"co2_AODA_3moving_ano_2010-2021.nc","r")
co2_aoda_NP=f3->co2(:,{NP_lat_s:NP_lat_f},{NP_lon_s:NP_lon_f})
co2_aoda_NA=f3->co2(:,{NA_lat_s:NA_lat_f},{NA_lon_s:NA_lon_f})

co2_aoda_NP1=dim_avg_n_Wrap(co2_aoda_NP,1)
co2_aoda_NP2=dim_avg_n_Wrap(co2_aoda_NP1,1)
co2_aoda_NA1=dim_avg_n_Wrap(co2_aoda_NA,1)
co2_aoda_NA2=dim_avg_n_Wrap(co2_aoda_NA1,1)

f4=addfile(dir1+"co2_SOCAT_3moving_ano_2010-2021.nc","r")
co2_socat_NP=f4->co2(:,{NP_lat_s:NP_lat_f},{NP_lon_s:NP_lon_f})
co2_socat_NA=f4->co2(:,{NA_lat_s:NA_lat_f},{NA_lon_s:NA_lon_f})

co2_socat_NP1=dim_avg_n_Wrap(co2_socat_NP,1)
co2_socat_NP2=dim_avg_n_Wrap(co2_socat_NP1,1)
co2_socat_NA1=dim_avg_n_Wrap(co2_socat_NA,1)
co2_socat_NA2=dim_avg_n_Wrap(co2_socat_NA1,1)

corr1=escorc(co2_oda_NP2,co2_socat_for_oda_NP2)
corr2=escorc(co2_oda_NA2,co2_socat_for_oda_NA2)
corr3=escorc(co2_aoda_NP2,co2_socat_NP2)
corr4=escorc(co2_aoda_NA2,co2_socat_NA2)

wks = gsn_open_wks("png",dir2+"pCO2_scatter_SOCAT_PDAFs_3mon_anomaly")
plot=new(4,"graphic")
res   = True
res@gsnDraw            = False             ; don't draw yet
res@gsnFrame           = False             ; don't advance frame yet
res@vpHeightF          = 0.5              ; change aspect ratio of plot
res@vpWidthF           = 0.5
res@gsnLeftStringFontHeightF=0.015
res@trXMinF            = -5
res@trXMaxF            =5
res@trYMinF                  = -6
res@trYMaxF                  = 6
;res@tmXBMode="Manual"
;res@tmXBTickStartF=-0.1
;res@tmXBTickSpacingF=0.1
;res@tmXBMinorPerMajor=3
res@gsnYRefLine=0
res@gsnYRefLineDashPattern=0
res@gsnYRefLineThicknessF=2
res@gsnYRefLineColor=(/"black"/)
res@gsnXRefLine=0
res@gsnXRefLineDashPattern=0
res@gsnXRefLineThicknessF=2
res@gsnXRefLineColor=(/"black"/)

res@xyDashPattern      = 0
res@xyLineThicknessF    = 3.
res@gsnLeftString= "7-9"
res@tiYAxisString = "SOCAT"
res@gsnLeftString=""
res@tiXAxisString = "ESM4-PDAF_ocean" ; y-axis label
res@xyMarkLineMode    = "Markers"                ; choose to use markers
res@xyMarkers         =  16                      ; choose type of marker  
res@xyMarkerColor     = "black" 
res@xyMarkerSizeF     = 0.01                     ; Marker size (default 0.01
res@gsnCenterStringOrthogonalPosF=0.05
res@gsnCenterStringFontHeightF=0.025
res@gsnCenterString="pCO~B~2~N~ (North PAC)"
plot(0) = gsn_csm_xy (wks,co2_oda_NP2,co2_socat_for_oda_NP2,res)
res@gsnCenterString="pCO~B~2~N~ (North ATL)"
plot(1) = gsn_csm_xy (wks,co2_oda_NA2,co2_socat_for_oda_NA2,res)
res@tiXAxisString = "ESM4-PDAF_coupled" ; y-axis label
res@gsnCenterString=""
res@trXMinF            = -8
res@trXMaxF            =8
res@trYMinF                  = -15
res@trYMaxF                  = 15
plot(2) = gsn_csm_xy (wks,co2_aoda_NP2,co2_socat_NP2,res)
plot(3) = gsn_csm_xy (wks,co2_aoda_NA2,co2_socat_NA2,res)

txres1               = True
txres1@txFontHeightF = 0.014
gsn_text_ndc(wks, "r = 0.23",0.44, 0.62, txres1)
gsn_text_ndc(wks, "r = 0.03",0.85, 0.62, txres1)
gsn_text_ndc(wks, "r = 0.68",0.44, 0.12, txres1)
gsn_text_ndc(wks, "r = 0.56",0.85, 0.12, txres1)

pres             = True
pres@gsnFrame         = False
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 7 
;pres@gsnPanelLeft  =0.1
gsn_panel(wks,plot,(/2,2/),pres)
frame(wks)
end
