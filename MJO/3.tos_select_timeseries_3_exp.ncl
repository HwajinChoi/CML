begin
dir0="/media/cmlws/Data2/hjc/MJO/data/RE/cobalt/"
dir1="/media/cmlws/Data2/hjc/MJO/data/RE/daily_chl/"
dir2="/media/cmlws/Data2/hjc/MJO/data/RE/clim_chl/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

;--------------------------------------------
;lon_1=160
;lon_2=200
;lat_1=-20
;lat_2=-50
;region1="lat:20S-50S,160E-160W"

;lon_1=60
;lon_2=120
;lat_1=-30
;lat_2=-45
;region1="lat:30S-45S,60E-120E"

;lon_1=300
;lon_2=360
;lat_1=-25
;lat_2=-50
;region1="lat:25S-50S,60W-0E"

lon_1=140
lon_2=190
lat_1=10
lat_2=30
region1="lat:10N-30N,140E-190E"
;--------------------------------------------

f=addfile(dir0+"tos.199001-200912.nc","r")
tos_on=f->tos(:,{lat_1:lat_2},{lon_1:lon_2}) ; 240
yh=f->yh
xh=f->xh
tos_on_DJF=month_to_season(tos_on,"DJF")
tos_on_JJA=month_to_season(tos_on,"JJA")
tos_on_annual=month_to_annual(tos_on,1)

tos_on_DJF2=dim_avg_n_Wrap(tos_on_DJF,1); average of DJF
tos_on_JJA2=dim_avg_n_Wrap(tos_on_JJA,1) ; average of JJA
tos_on_annual2=dim_avg_n_Wrap(tos_on_annual,1)

tos_on_DJF3=dim_avg_n_Wrap(tos_on_DJF2,1); average of DJF
tos_on_JJA3=dim_avg_n_Wrap(tos_on_JJA2,1) ; average of JJA
tos_on_annual3=dim_avg_n_Wrap(tos_on_annual2,1)

g=addfile(dir1+"tos.199001-200912.nc","r")
tos_daily=g->tos(:,{lat_1:lat_2},{lon_1:lon_2})
tos_daily_DJF=month_to_season(tos_daily,"DJF")
tos_daily_JJA=month_to_season(tos_daily,"JJA")
tos_daily_annual=month_to_annual(tos_daily,1)

tos_daily_DJF2=dim_avg_n_Wrap(tos_daily_DJF,1) ; average of DJF
tos_daily_JJA2=dim_avg_n_Wrap(tos_daily_JJA,1) ; average of JJA
tos_daily_annual2=dim_avg_n_Wrap(tos_daily_annual,1)

tos_daily_DJF3=dim_avg_n_Wrap(tos_daily_DJF2,1) ; average of DJF
tos_daily_JJA3=dim_avg_n_Wrap(tos_daily_JJA2,1) ; average of JJA
tos_daily_annual3=dim_avg_n_Wrap(tos_daily_annual2,1)

h=addfile(dir2+"tos.199001-200912.nc","r")
tos_clim=h->tos(:,{lat_1:lat_2},{lon_1:lon_2})
tos_clim_annual=month_to_annual(tos_clim,1)
tos_clim_DJF=month_to_season(tos_clim,"DJF")
tos_clim_JJA=month_to_season(tos_clim,"JJA")
tos_clim_DJF2=dim_avg_n_Wrap(tos_clim_DJF,1) ; average of DJF
tos_clim_JJA2=dim_avg_n_Wrap(tos_clim_JJA,1) ; average of JJA
tos_clim_annual2=dim_avg_n_Wrap(tos_clim_annual,1)

tos_clim_DJF3=dim_avg_n_Wrap(tos_clim_DJF2,1) ; average of DJF
tos_clim_JJA3=dim_avg_n_Wrap(tos_clim_JJA2,1) ; average of JJA
tos_clim_annual3=dim_avg_n_Wrap(tos_clim_annual2,1)

ANNUAL=new((/3,20/),"float")
ANNUAL(0,:)=tos_on_annual3
ANNUAL(1,:)=tos_daily_annual3
ANNUAL(2,:)=tos_clim_annual3

DJF=new((/3,20/),"float")
DJF(0,:)=tos_on_DJF3
DJF(1,:)=tos_daily_DJF3
DJF(2,:)=tos_clim_DJF3

JJA=new((/3,20/),"float")
JJA(0,:)=tos_on_JJA3
JJA(1,:)=tos_daily_JJA3
JJA(2,:)=tos_clim_JJA3

x=ispan(1990,2009,1)

plot=new(3,graphic)
wks=gsn_open_wks("png",dir3+"tos_timeseries_DJF_JJA_region4")
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
res@tmXBLabels=(/1990,1994,1998,2002,2008/)
res@tmXBValues=(/1990,1994,1998,2002,2008/)
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
;res@gsnXRefLine=(/2005,2010,2015/)
;res@gsnXRefLineDashPatterns=(/2,2,2/)
;res@gsnXRefLineThicknesses=(/2,2,2/)
;res@gsnXRefLineColors=(/"gray","gray","gray"/)
res@tiYAxisString ="~S~o~N~C"
res@pmLegendDisplayMode    = "Always"            ; turn on legend
res@pmLegendSide           = "Bottom"               ; Change location of
res@pmLegendParallelPosF   = 0.2                  ; move units right
res@pmLegendOrthogonalPosF =-1.3                ; move units down
res@pmLegendWidthF         = 0.12                ; Change width and
res@pmLegendHeightF        = 0.12                ; height of legend.
res@lgPerimOn              = False               ; turn off box around
res@lgLabelFontHeightF     = .03                 ; label font height
res@xyExplicitLegendLabels = (/"COBLAT","Daily","Clim"/)         ; create explicit la

;res@trYMinF  =23.
;res@trYMaxF=27.
plot(0) = gsn_csm_xy(wks,x,ANNUAL,res)
res@gsnCenterString  ="DJF"
plot(1) = gsn_csm_xy(wks,x,DJF,res)
res@gsnCenterString  ="JJA"
res@pmLegendDisplayMode    ="Never"
plot(2) = gsn_csm_xy(wks,x,JJA,res)

resP                     = True         ; modify the panel plot
resP@gsnMaximize         = False         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
resP@gsnPanelMainString  = ""
resP@gsnPanelLeft=0.1

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.018
gsn_text_ndc(wks,region1,0.53,0.65,txres1)

gsn_panel(wks,plot,(/1,3/),resP)     ; draw all 'neof' as one plot


end
