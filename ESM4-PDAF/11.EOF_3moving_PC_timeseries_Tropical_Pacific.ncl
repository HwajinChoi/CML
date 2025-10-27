begin

dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
colors=(/"red","magenta","gold","green","blue","purple"/)
name=(/"ESM4-PDAF_ocean","ESM4-PDAF_coupled","ECDA","GODAS","ECCO","SODA"/)
T="Tropical_Pacific"

f1=addfile(dir1+"Tropical_Pacific_tos_EOF_1st_3moving_ano_PC_timeseries_2010-2021.nc","r")
PC=f1->pc_timeseries ; data(ODA, AODA, ECDA, GODAS, ECCO, SODA)

A=new(6,"float")
A=6.0
B=new(6,"integer")
B=0
y=ispan(1,142,1)

plot=new(1,graphic)
wks=gsn_open_wks("png",dir2+"EOF_1st_PC_timeseries_"+T)
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
res@tiYAxisString =""
res@tiMainString=T
res@trXMinF  = 0
res@trXMaxF=144
res@tmXBMode="Explicit"
res@tmXBValues=(/0,24,48,72,96,120,144/)
res@tmXBLabels=(/2010,2012,2014,2016,2018,2020,2022/)
res@tmXBLabelFontHeightF=0.02
res@tmYLLabelFontHeightF=0.02
res@xyLineThicknesses    = A 
res@xyDashPatterns=B
res@xyLineColors=colors
plot(0)=gsn_csm_xy(wks,y,PC,res)

gres = True
gres@YPosPercent = 97    ; expressed as %, 0->100, sets position of top border of legend 
gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
gres@ItemSpacePercent = 4.
lineres = True
lineres@lgLineColors = colors
lineres@lgLineThicknesses = 5                        ; line thicknesses
lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
textres = True
textres@lgLabelFontHeights = (/0.014,0.014,0.014,0.014/)                           ; label font heights
textres@lgLabels = name
plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

draw(plot)
frame(wks)

end
