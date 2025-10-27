begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
dir1="/media/cmlws/Data2/hjc/MJO/data/on/"
dir2="/media/cmlws/Data2/hjc/MJO/data/off/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

b2 = addfile(file11,"r")
;------------Philip-------------
p_lat_s=-10
p_lat_f=10
p_lon_s=160
p_lon_f=240
;------------India-------------
i_lat_s=-30
i_lat_f=0
i_lon_s=250
i_lon_f=280
;-------------------------------
f=addfile(dir1+"tos_0_360_200001-201912.nc","r")
tos_on=f->tos ; 240
yh=f->yh
xh=f->xh
tos_on_P_DJF=month_to_season(tos_on(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),"DJF")
tos_on_P_JJA=month_to_season(tos_on(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),"JJA")
tos_on_P_annual=month_to_annual(tos_on(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),1)

tos_on_P_DJF2=dim_avg_n_Wrap(tos_on_P_DJF,1); average of DJF
tos_on_P_JJA2=dim_avg_n_Wrap(tos_on_P_JJA,1) ; average of JJA
tos_on_P_annual2=dim_avg_n_Wrap(tos_on_P_annual,1)

tos_on_P_DJF3=dim_avg_n_Wrap(tos_on_P_DJF2,1); average of DJF
tos_on_P_JJA3=dim_avg_n_Wrap(tos_on_P_JJA2,1) ; average of JJA
tos_on_P_annual3=dim_avg_n_Wrap(tos_on_P_annual2,1)

tos_on_I_DJF=month_to_season(tos_on(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),"DJF")
tos_on_I_JJA=month_to_season(tos_on(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),"JJA")
tos_on_I_annual=month_to_annual(tos_on(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),1)

tos_on_I_DJF2=dim_avg_n_Wrap(tos_on_I_DJF,1); average of DJF
tos_on_I_JJA2=dim_avg_n_Wrap(tos_on_I_JJA,1) ; average of JJA
tos_on_I_annual2=dim_avg_n_Wrap(tos_on_I_annual,1)

tos_on_I_DJF3=dim_avg_n_Wrap(tos_on_I_DJF2,1); average of DJF
tos_on_I_JJA3=dim_avg_n_Wrap(tos_on_I_JJA2,1) ; average of JJA
tos_on_I_annual3=dim_avg_n_Wrap(tos_on_I_annual2,1)

g=addfile(dir2+"tos_0_360_200001-201912.nc","r")
tos_off=g->tos
tos_off_P_DJF=month_to_season(tos_off(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),"DJF")
tos_off_P_JJA=month_to_season(tos_off(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),"JJA")
tos_off_P_annual=month_to_annual(tos_off(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),1)

tos_off_P_DJF2=dim_avg_n_Wrap(tos_off_P_DJF,1); average of DJF
tos_off_P_JJA2=dim_avg_n_Wrap(tos_off_P_JJA,1) ; average of JJA
tos_off_P_annual2=dim_avg_n_Wrap(tos_off_P_annual,1)

tos_off_P_DJF3=dim_avg_n_Wrap(tos_off_P_DJF2,1); average of DJF
tos_off_P_JJA3=dim_avg_n_Wrap(tos_off_P_JJA2,1) ; average of JJA
tos_off_P_annual3=dim_avg_n_Wrap(tos_off_P_annual2,1)

tos_off_I_DJF=month_to_season(tos_off(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),"DJF")
tos_off_I_JJA=month_to_season(tos_off(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),"JJA")
tos_off_I_annual=month_to_annual(tos_off(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),1)

tos_off_I_DJF2=dim_avg_n_Wrap(tos_off_I_DJF,1); average of DJF
tos_off_I_JJA2=dim_avg_n_Wrap(tos_off_I_JJA,1) ; average of JJA
tos_off_I_annual2=dim_avg_n_Wrap(tos_off_I_annual,1)

tos_off_I_DJF3=dim_avg_n_Wrap(tos_off_I_DJF2,1); average of DJF
tos_off_I_JJA3=dim_avg_n_Wrap(tos_off_I_JJA2,1) ; average of JJA
tos_off_I_annual3=dim_avg_n_Wrap(tos_off_I_annual2,1)

tos_diff_I_annual=tos_on_I_annual3-tos_off_I_annual3
tos_diff_I_DJF=tos_on_I_DJF3-tos_off_I_DJF3
tos_diff_I_JJA=tos_on_I_JJA3-tos_off_I_JJA3

tos_diff_P_annual=tos_on_P_annual3-tos_off_P_annual3
tos_diff_P_DJF=tos_on_P_DJF3-tos_off_P_DJF3
tos_diff_P_JJA=tos_on_P_JJA3-tos_off_P_JJA3

TOS_P_annual=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_P_annual(0,:)=tos_on_P_annual3
TOS_P_annual(1,:)=tos_off_P_annual3
TOS_P_annual(2,:)=tos_diff_P_annual

TOS_P_DJF=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_P_DJF(0,:)=tos_on_P_DJF3
TOS_P_DJF(1,:)=tos_off_P_DJF3
TOS_P_DJF(2,:)=tos_diff_P_DJF

TOS_P_JJA=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_P_JJA(0,:)=tos_on_P_JJA3
TOS_P_JJA(1,:)=tos_off_P_JJA3
TOS_P_JJA(2,:)=tos_diff_P_JJA

TOS_I_annual=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_I_annual(0,:)=tos_on_I_annual3
TOS_I_annual(1,:)=tos_off_I_annual3
TOS_I_annual(2,:)=tos_diff_I_annual

TOS_I_DJF=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_I_DJF(0,:)=tos_on_I_DJF3
TOS_I_DJF(1,:)=tos_off_I_DJF3
TOS_I_DJF(2,:)=tos_diff_I_DJF

TOS_I_JJA=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_I_JJA(0,:)=tos_on_I_JJA3
TOS_I_JJA(1,:)=tos_off_I_JJA3
TOS_I_JJA(2,:)=tos_diff_I_JJA

x=ispan(2000,2019,1)

plot=new(6,graphic)
wks=gsn_open_wks("png",dir3+"tos_BOX_timeseries_diff_clim_DJF_JJA_centeral_eastern")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@gsnRightString = "" 
res@gsnLeftString  ="" 
res@vpHeightF=0.5
res@vpWidthF=0.8
res@trXMinF  = 2000
res@trXMaxF=2019
res@tmXBLabelFontHeightF=0.035
res@tmYLLabelFontHeightF=0.035
res@gsnCenterStringFontHeightF=0.05
res@gsnCenterString  ="Annual"
res@xyLineThicknesses    = (/3,3/)
res@xyDashPatterns=(/0,0/)
res@xyLineColors=(/"black","grey50"/)
res@tiXAxisString ="Time"
res@tiXAxisFontHeightF=0.035
res@tiYAxisFontHeightF=0.035
res@gsnCenterStringOrthogonalPosF=0.1
res@gsnXRefLine=(/2005,2010,2015/)
res@gsnXRefLineDashPatterns=(/2,2,2/)
res@gsnXRefLineThicknesses=(/2,2,2/)
res@gsnXRefLineColors=(/"gray","gray","gray"/)
res@tiYAxisString ="~S~o~N~C"

res@pmLegendDisplayMode    = "Always"            ; turn on legend
res@pmLegendSide           = "Top"               ; Change location of
res@pmLegendParallelPosF   = 0.90                  ; move units right
res@pmLegendOrthogonalPosF =-0.43                ; move units down
res@pmLegendWidthF         = 0.09                ; Change width and
res@pmLegendHeightF        = 0.09                ; height of legend.
res@lgPerimOn              = False               ; turn off box around
res@lgLabelFontHeightF     = .03                 ; label font height
res@xyExplicitLegendLabels = (/"ON","OFF"/)         ; create explicit la

res@trYMinF  =23. 
res@trYMaxF=25.
plot(0) = gsn_csm_xy(wks,x,TOS_I_annual(0:1,:),res)
res@tiYAxisString =""
res@gsnCenterString  ="JJA"
res@trYMinF  =21.5 
res@trYMaxF=23.
plot(1) = gsn_csm_xy(wks,x,TOS_I_JJA(0:1,:),res)
res@gsnCenterString  ="DJF"
res@trYMinF  =24.5 
res@trYMaxF=26.5
plot(2) = gsn_csm_xy(wks,x,TOS_I_DJF(0:1,:),res)
res@gsnCenterString  =""
res@tiYAxisString ="~S~o~N~C"
res@trYMinF  =27.5 
res@trYMaxF=29.5
res@pmLegendOrthogonalPosF =-1.0                ; move units down

plot(3) = gsn_csm_xy(wks,x,TOS_P_annual(0:1,:),res)
res@tiYAxisString =""
res@trYMinF  =28 
res@trYMaxF=30
plot(4) = gsn_csm_xy(wks,x,TOS_P_JJA(0:1,:),res)
res@trYMinF  =27 
res@trYMaxF=29.5
res@pmLegendOrthogonalPosF =-0.25                ; move units down
plot(5) = gsn_csm_xy(wks,x,TOS_P_DJF(0:1,:),res)

; panel plot only resources
resP                     = True         ; modify the panel plot
resP@gsnMaximize         = False         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
resP@gsnPanelMainString  = ""
resP@gsnPanelLeft=0.1

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.014
gsn_text_ndc(wks,"Central",0.05,0.62,txres1)
gsn_text_ndc(wks,"Pacific",0.05,0.6,txres1)
gsn_text_ndc(wks,"Eastern",0.05,0.4,txres1)
gsn_text_ndc(wks,"Pacific",0.05,0.38,txres1)

gsn_panel(wks,plot,(/2,3/),resP)     ; draw all 'neof' as one plot
end
