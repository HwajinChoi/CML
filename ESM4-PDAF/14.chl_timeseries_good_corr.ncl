begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"

T=3

np_lat_1=10
np_lat_2=35
np_lon_1=140
np_lon_2=220

sp_lat_1=-20
sp_lat_2=0
sp_lon_1=160
sp_lon_2=210
name=(/"NP_ODA","SP_ODA","NP_AODA","SP_AODA"/)

f1=addfile(dir1+"chl_satellite_2_3moving_ano_2010-2021.nc","r")
sat_np=f1->chl_sa_mv3(:,{np_lat_1:np_lat_2},{np_lon_1:np_lon_2})
sat_sp=f1->chl_sa_mv3(:,{sp_lat_1:sp_lat_2},{sp_lon_1:sp_lon_2})

f2=addfile(dir1+"chl_ODA_3moving_ano_2015-2021.nc","r")
oda_np=f2->chl_oda_mv3(:,{np_lat_1:np_lat_2},{np_lon_1:np_lon_2})
oda_sp=f2->chl_oda_mv3(:,{sp_lat_1:sp_lat_2},{sp_lon_1:sp_lon_2})
oda_np=oda_np*10^6
oda_sp=oda_sp*10^6
np_lat=f2->lat({np_lat_1:np_lat_2})
sp_lat=f2->lat({sp_lat_1:sp_lat_2})
f3=addfile(dir1+"chl_AODA_3moving_ano_2010-2021.nc","r")
aoda_np=f3->chl_aoda_mv3(:,{np_lat_1:np_lat_2},{np_lon_1:np_lon_2})
aoda_sp=f3->chl_aoda_mv3(:,{sp_lat_1:sp_lat_2},{sp_lon_1:sp_lon_2})
aoda_np=aoda_np*10^6
aoda_sp=aoda_sp*10^6
;---------------------------------------------------------------------
rad    = 4.0*atan(1.0)/180.0
clat_np   = cos(np_lat*rad)
clat_sp   = cos(sp_lat*rad)

sat_np_area = wgt_areaave_Wrap(sat_np, clat_np, 1.0, 1)
oda_np_area = wgt_areaave_Wrap(oda_np, clat_np, 1.0, 1)
aoda_np_area = wgt_areaave_Wrap(aoda_np, clat_np, 1.0, 1)

sat_sp_area = wgt_areaave_Wrap(sat_sp, clat_sp, 1.0, 1)
oda_sp_area = wgt_areaave_Wrap(oda_sp, clat_sp, 1.0, 1)
aoda_sp_area = wgt_areaave_Wrap(aoda_sp, clat_sp, 1.0, 1)

NP_ODA=new((/2,82/),"float")
NP_ODA(0,:)=sat_np_area(60:141)
NP_ODA(1,:)=oda_np_area
NP_ODA!0="data"

SP_ODA=new((/2,82/),"float")
SP_ODA(0,:)=sat_sp_area(60:141)
SP_ODA(1,:)=oda_sp_area
SP_ODA!0="data"

NP_AODA=new((/2,142/),"float")
NP_AODA(0,:)=sat_np_area
NP_AODA(1,:)=aoda_np_area
NP_AODA!0="data"

SP_AODA=new((/2,142/),"float")
SP_AODA(0,:)=sat_sp_area
SP_AODA(1,:)=aoda_sp_area
SP_AODA!0="data"

y=ispan(1,142,1)
y2=ispan(1,82,1)

plot=new(4,graphic)
wks=gsn_open_wks("png",dir0+"Chl_timeseries_"+name(T))
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@gsnMaximize=True
;res@tmYLMode="Manual"
;res@tmYLTickStartF=0
;res@tmYLTickSpacingF=50
;res@tmYLMinorPerMajor=3
res@vpHeightF=0.5
res@vpWidthF=0.8
res@gsnYRefLine=0
res@gsnYRefLineDashPattern=0
res@gsnYRefLineThicknessF=2
res@gsnYRefLineColor=(/"black"/)
res@gsnLeftString=""
res@gsnRightString=""
res@tiXAxisString ="Time"
res@tiXAxisFontHeightF=0.022
res@tiYAxisString ="chl (mg / m~S~3~N~)"
res@tiMainString=""
res@tmXBMode="Explicit"
res@xyMarkLineMode = "MarkLines" 
res@xyMarkers      = (/4,16/)               ; 3 different markers
res@xyMarkerColors := (/"black","green"/) ; 3 different colors
res@tmXBLabelFontHeightF=0.02
res@tmYLLabelFontHeightF=0.02
res@xyLineThicknesses    = (/6,6/)
res@xyMarkerThicknesses= (/6,6/)
res@xyDashPatterns=(/0,0/)
res@xyLineColors=(/"black","green"/)
res@gsnCenterStringFontHeightF=0.025
res@gsnCenterString=name(0)
res@trXMinF  = 0
res@trXMaxF=83
res@tmXBValues=(/0,24,48,72/)
res@tmXBLabels=(/2015,2017,2019,2021/)
plot(0)=gsn_csm_xy(wks,y2,NP_ODA,res)
res@gsnCenterString=name(1)
plot(1)=gsn_csm_xy(wks,y2,SP_ODA,res)
delete([/res@tmXBValues,res@tmXBLabels,res@trXMinF,res@trXMaxF/])
res@trXMinF  = 0
res@trXMaxF=144
res@tmXBValues=(/0,24,48,72,96,120,144/)
res@tmXBLabels=(/2010,2012,2014,2016,2018,2020,2022/)
res@gsnCenterString=name(2)
plot(2)=gsn_csm_xy(wks,y,NP_AODA,res)
res@gsnCenterString=name(3)
plot(3)=gsn_csm_xy(wks,y,SP_AODA,res)

gres = True
gres@YPosPercent = 97    ; expressed as %, 0->100, sets position of top border of legend 
gres@XPosPercent = 65      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
gres@ItemSpacePercent = 6.
lineres = True
lineres@lgLineColors = (/"black","green"/)
lineres@lgLineThicknesses = 5                        ; line thicknesses
lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
textres = True
textres@lgLabelFontHeights = (/0.015,0.015/)                           ; label font heights
textres@lgLabels = (/"OBS","ESM4-PDAF_ocean"/)
plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
gres@XPosPercent = 65      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
textres@lgLabels = (/"OBS","ESM4-PDAF_coupled"/)
plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

draw(plot(T))
frame(wks)

end
