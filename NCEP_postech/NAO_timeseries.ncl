begin
dir1="/media/cmlws/Data2/hjc/NCEP/data/obs/"


data=asciiread(dir1+"NAO_index_196001-201912.csv",(/60,13/),"float")
data2=data(:,1:12)
NAO=ndtooned(data2)
NAO!0="time";720

NAO_djf=month_to_season(NAO,"DJF")
NAO_mam=month_to_season(NAO,"MAM")
NAO_jja=month_to_season(NAO,"JJA")
NAO_son=month_to_season(NAO,"SON")
x=ispan(1960,2019,1)
aut_djf=esacr(NAO_djf,1)
aut_mam=esacr(NAO_mam,1)
aut_jja=esacr(NAO_jja,1)
aut_son=esacr(NAO_son,1)
;print(NAO_djf)
;print(NAO_mam)
;print(NAO_jja)
print(NAO_son)
exit
;-----------------------------------
p_djf=trend_manken(NAO_djf,False,0)
p_mam=trend_manken(NAO_mam,False,0)
p_jja=trend_manken(NAO_jja,False,0)
p_son=trend_manken(NAO_son,False,0)

rc_djf=regline_stats(x,NAO_djf)
rc_mam=regline_stats(x,NAO_mam)
rc_jja=regline_stats(x,NAO_jja)
rc_son=regline_stats(x,NAO_son)

pltarry  = new ( (/8,60/), "float")
pltarry(0,:) = rc_djf@YMR025                         ; mean response
pltarry(1,:) = rc_djf@YMR975
pltarry(2,:) = rc_mam@YMR025                         ; mean response
pltarry(3,:) = rc_mam@YMR975
pltarry(4,:) = rc_jja@YMR025                         ; mean response
pltarry(5,:) = rc_jja@YMR975
pltarry(6,:) = rc_son@YMR025                         ; mean response
pltarry(7,:) = rc_son@YMR975

 wks = gsn_open_wks("png","./NAO_seasonal_timeseries")
 plot=new(4,"graphic")
 plot1=new(4,"graphic")
 plot2=new(4,"graphic")
 res   = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF          = 0.4               ; change aspect ratio of plot
 res@vpWidthF           = 0.6
 res@trXMinF                  = 1960
 res@trXMaxF                  =2020
 res@gsnLeftStringFontHeightF=0.015
 ;res@tmXBMode   = "Explicit"
 ;res@tmXBValues =(/y(61),y(92),y(123)/)
 ;res@tmXBLabels = (/"July","Aug","Sep"/)
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnCenterStringFontHeightF=0.025
 res@gsnLeftString=""
 res@gsnYRefLine=0
 res@gsnYRefLineColor="black"
 res@gsnYRefLineDashPattern=2
 res@trYMinF                  = -3
 res@trYMaxF                  = 3
 res2=res
 res@xyLineThicknessF    = 4.0
 res@xyDashPattern=0
 res3=res
 res@xyLineColor         = "grey50"
 res@tiYAxisString = "NAO" ; y-axis label
 res@tiXAxisString = "Time"
 res@gsnCenterString="DJF" 
 plot(0) = gsn_csm_xy(wks,x,NAO_djf,res)
 res@gsnCenterString="MAM" 
 res@tiYAxisString = "" ; y-axis label
 plot(1) = gsn_csm_xy(wks,x,NAO_mam,res)
 res@gsnCenterString="JJA" 
 res@tiYAxisString = "NAO" ; y-axis label
 plot(2) = gsn_csm_xy(wks,x,NAO_jja,res)
 res@gsnCenterString="SON" 
 res@tiYAxisString = "" ; y-axis label
 plot(3) = gsn_csm_xy(wks,x,NAO_son,res)
 res2@xyLineThicknesses    = (/3.0,3.0/)
 res2@xyDashPatterns=(/0,0/)
 res2@xyLineColors         = (/"blue","blue"/)
 plot1(0)=gsn_csm_xy(wks,x,pltarry(0:1,:),res2)
 plot1(1)=gsn_csm_xy(wks,x,pltarry(2:3,:),res2)
 plot1(2)=gsn_csm_xy(wks,x,pltarry(4:5,:),res2)
 plot1(3)=gsn_csm_xy(wks,x,pltarry(6:7,:),res2)
 res3@xyLineColor         = "black"
 plot2(0)=gsn_csm_xy(wks,x,rc_djf@Yest,res3)
 plot2(1)=gsn_csm_xy(wks,x,rc_mam@Yest,res3)
 plot2(2)=gsn_csm_xy(wks,x,rc_jja@Yest,res3)
 plot2(3)=gsn_csm_xy(wks,x,rc_son@Yest,res3)

 do i=0,3
 overlay(plot(i),plot2(i))
 end do

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent =5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/2,2/),pres)

 txres1               = True
 txres1@txFontHeightF = 0.014
;txres1@txAngleF      = 90.
 t_djf = "Trend = "+sprintf("%5.2f",p_djf(1)*10)+"*/decade"
 t_mam = "Trend = "+sprintf("%5.2f",p_mam(1)*10)+"*/decade"
 t_jja = "Trend = "+sprintf("%5.2f",p_jja(1)*10)+"*/decade"
 t_son = "Trend = "+sprintf("%5.2f",p_son(1)*10)+"/decade"
 gsn_text_ndc(wks, t_djf,0.37, 0.82, txres1)
 gsn_text_ndc(wks, t_mam,0.86, 0.82, txres1)
 gsn_text_ndc(wks, t_jja,0.37, 0.42, txres1)
 gsn_text_ndc(wks, t_son,0.86, 0.42, txres1)

 frame(wks)

end
