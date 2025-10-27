begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
dir0="/media/cmlws/Data2/hjc/MJO/data/RE/cobalt/"
dir1="/media/cmlws/Data2/hjc/MJO/data/RE/daily_chl/"
dir2="/media/cmlws/Data2/hjc/MJO/data/RE/clim_chl/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

b2 = addfile(file11,"r")
;------------Maritime Continent-------------
p_lat_s=-20
p_lat_f=20
p_lon_s=100
p_lon_f=130
;------------Indian-------------
i_lat_s=-20
i_lat_f=0
i_lon_s=50
i_lon_f=80
;-------------------------------
f=addfile(dir0+"tos.199001-200912.nc","r")
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

g=addfile(dir1+"tos.199001-200912.nc","r")
tos_daily=g->tos
tos_daily_P_DJF=month_to_season(tos_daily(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),"DJF")
tos_daily_P_JJA=month_to_season(tos_daily(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),"JJA")
tos_daily_P_annual=month_to_annual(tos_daily(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),1)

tos_daily_P_DJF2=dim_avg_n_Wrap(tos_daily_P_DJF,1); average of DJF
tos_daily_P_JJA2=dim_avg_n_Wrap(tos_daily_P_JJA,1) ; average of JJA
tos_daily_P_annual2=dim_avg_n_Wrap(tos_daily_P_annual,1)

tos_daily_P_DJF3=dim_avg_n_Wrap(tos_daily_P_DJF2,1); average of DJF
tos_daily_P_JJA3=dim_avg_n_Wrap(tos_daily_P_JJA2,1) ; average of JJA
tos_daily_P_annual3=dim_avg_n_Wrap(tos_daily_P_annual2,1)

tos_daily_I_DJF=month_to_season(tos_daily(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),"DJF")
tos_daily_I_JJA=month_to_season(tos_daily(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),"JJA")
tos_daily_I_annual=month_to_annual(tos_daily(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),1)

tos_daily_I_DJF2=dim_avg_n_Wrap(tos_daily_I_DJF,1); average of DJF
tos_daily_I_JJA2=dim_avg_n_Wrap(tos_daily_I_JJA,1) ; average of JJA
tos_daily_I_annual2=dim_avg_n_Wrap(tos_daily_I_annual,1)

tos_daily_I_DJF3=dim_avg_n_Wrap(tos_daily_I_DJF2,1); average of DJF
tos_daily_I_JJA3=dim_avg_n_Wrap(tos_daily_I_JJA2,1) ; average of JJA
tos_daily_I_annual3=dim_avg_n_Wrap(tos_daily_I_annual2,1)

h=addfile(dir2+"tos.199001-200912.nc","r")
tos_clim=h->tos
tos_clim_P_DJF=month_to_season(tos_clim(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),"DJF")
tos_clim_P_JJA=month_to_season(tos_clim(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),"JJA")
tos_clim_P_annual=month_to_annual(tos_clim(:,{p_lat_s:p_lat_f},{p_lon_s:p_lon_f}),1)

tos_clim_P_DJF2=dim_avg_n_Wrap(tos_clim_P_DJF,1); average of DJF
tos_clim_P_JJA2=dim_avg_n_Wrap(tos_clim_P_JJA,1) ; average of JJA
tos_clim_P_annual2=dim_avg_n_Wrap(tos_clim_P_annual,1)

tos_clim_P_DJF3=dim_avg_n_Wrap(tos_clim_P_DJF2,1); average of DJF
tos_clim_P_JJA3=dim_avg_n_Wrap(tos_clim_P_JJA2,1) ; average of JJA
tos_clim_P_annual3=dim_avg_n_Wrap(tos_clim_P_annual2,1)

tos_clim_I_DJF=month_to_season(tos_clim(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),"DJF")
tos_clim_I_JJA=month_to_season(tos_clim(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),"JJA")
tos_clim_I_annual=month_to_annual(tos_clim(:,{i_lat_s:i_lat_f},{i_lon_s:i_lon_f}),1)

tos_clim_I_DJF2=dim_avg_n_Wrap(tos_clim_I_DJF,1); average of DJF
tos_clim_I_JJA2=dim_avg_n_Wrap(tos_clim_I_JJA,1) ; average of JJA
tos_clim_I_annual2=dim_avg_n_Wrap(tos_clim_I_annual,1)

tos_clim_I_DJF3=dim_avg_n_Wrap(tos_clim_I_DJF2,1); average of DJF
tos_clim_I_JJA3=dim_avg_n_Wrap(tos_clim_I_JJA2,1) ; average of JJA
tos_clim_I_annual3=dim_avg_n_Wrap(tos_clim_I_annual2,1)

TOS_P_annual=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_P_annual(0,:)=tos_on_P_annual3
TOS_P_annual(1,:)=tos_daily_P_annual3
TOS_P_annual(2,:)=tos_clim_P_annual3

TOS_P_DJF=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_P_DJF(0,:)=tos_on_P_DJF3
TOS_P_DJF(1,:)=tos_daily_P_DJF3
TOS_P_DJF(2,:)=tos_clim_P_DJF3

TOS_P_JJA=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_P_JJA(0,:)=tos_on_P_JJA3
TOS_P_JJA(1,:)=tos_daily_P_JJA3
TOS_P_JJA(2,:)=tos_clim_P_JJA3

TOS_I_annual=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_I_annual(0,:)=tos_on_I_annual3
TOS_I_annual(1,:)=tos_daily_I_annual3
TOS_I_annual(2,:)=tos_clim_I_annual3

TOS_I_DJF=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_I_DJF(0,:)=tos_on_I_DJF3
TOS_I_DJF(1,:)=tos_daily_I_DJF3
TOS_I_DJF(2,:)=tos_clim_I_DJF3

TOS_I_JJA=new((/3,20/),typeof(tos_on)) ; ON , OFF, DIFF
TOS_I_JJA(0,:)=tos_on_I_JJA3
TOS_I_JJA(1,:)=tos_daily_I_JJA3
TOS_I_JJA(2,:)=tos_clim_I_JJA3

x=ispan(1990,2009,1)

plot=new(6,graphic)
wks=gsn_open_wks("png",dir3+"tos_BOX_timeseries_DJF_JJA_Indian_Maritime_90-09")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@gsnRightString = "" 
res@gsnLeftString  ="" 
res@vpHeightF=0.5
res@vpWidthF=0.8
res@trXMinF  = 1990
res@trXMaxF=2009
res@tmXBMode="Explicit"
res@tmXBLabels=(/1990,1994,1998,2002,2006/)
res@tmXBValues=(/1990,1994,1998,2002,2006/)
res@tmXBLabelFontHeightF=0.035
res@tmYLLabelFontHeightF=0.035
res@gsnCenterStringFontHeightF=0.05
res@gsnCenterString  ="Annual"
res@xyLineThicknesses    = (/3,3,3/)
res@xyDashPatterns=(/0,0,0/)
res@xyLineColors=(/"black","red","blue"/)
res@tiXAxisString ="Time"
res@tiXAxisFontHeightF=0.035
res@tiYAxisFontHeightF=0.035
res@gsnCenterStringOrthogonalPosF=0.1
res@gsnXRefLine=(/1990,1994,1998,2002,2006/)
res@gsnXRefLineDashPatterns=(/2,2,2,2,2/)
res@gsnXRefLineThicknesses=(/2,2,2,2,2/)
res@gsnXRefLineColors=(/"gray","gray","gray","gray","gray"/)
res@tiYAxisString ="~S~o~N~C"

res@pmLegendDisplayMode    = "Always"            ; turn on legend
res@pmLegendSide           = "Top"               ; Change location of
res@pmLegendParallelPosF   = 0.85                  ; move units right
res@pmLegendOrthogonalPosF =-0.45                ; move units down
res@pmLegendWidthF         = 0.09                ; Change width and
res@pmLegendHeightF        = 0.12                ; height of legend.
res@lgPerimOn              = False               ; turn off box around
res@lgLabelFontHeightF     = .03                 ; label font height
res@xyExplicitLegendLabels = (/"COBLAT","Daily","Clim"/)

res@trYMinF  =27. 
res@trYMaxF=28.5
res@pmLegendParallelPosF   = 0.17
res@pmLegendOrthogonalPosF =-0.5                ; move units down
plot(0) = gsn_csm_xy(wks,x,TOS_I_annual,res)
res@tiYAxisString =""
res@gsnCenterString  ="JJA"
res@trYMinF  =25.5 
res@trYMaxF=27.5
res@pmLegendParallelPosF   = 0.85                  ; move units right
res@pmLegendOrthogonalPosF =-1.2                ; move units down
plot(1) = gsn_csm_xy(wks,x,TOS_I_JJA,res)
res@gsnCenterString  ="DJF"
res@trYMinF  =28. 
res@trYMaxF=29.5
res@pmLegendParallelPosF   = 0.17
res@pmLegendOrthogonalPosF =-0.5                ; move units down
plot(2) = gsn_csm_xy(wks,x,TOS_I_DJF,res)
res@gsnCenterString  =""
res@tiYAxisString ="~S~o~N~C"
res@trYMinF  =28. 
res@trYMaxF=29.5
res@pmLegendOrthogonalPosF =-1.0                ; move units down
plot(3) = gsn_csm_xy(wks,x,TOS_P_annual,res)
res@tiYAxisString =""
res@trYMinF  =28 
res@trYMaxF=29.5
res@pmLegendOrthogonalPosF =-0.3               ; move units down
plot(4) = gsn_csm_xy(wks,x,TOS_P_JJA,res)
res@trYMinF  =28. 
res@trYMaxF=29.5
plot(5) = gsn_csm_xy(wks,x,TOS_P_DJF,res)

; panel plot only resources
resP                     = True         ; modify the panel plot
resP@gsnMaximize         = False         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
resP@gsnPanelMainString  = ""
resP@gsnPanelLeft=0.1

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.014
gsn_text_ndc(wks,"Indian",0.05,0.62,txres1)
gsn_text_ndc(wks,"Ocean",0.05,0.6,txres1)
gsn_text_ndc(wks,"Maritime",0.05,0.4,txres1)
gsn_text_ndc(wks,"continent",0.05,0.38,txres1)

gsn_panel(wks,plot,(/2,3/),resP)     ; draw all 'neof' as one plot
end
