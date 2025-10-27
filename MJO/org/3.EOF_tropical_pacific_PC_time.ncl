begin
dir1="/media/cmlws/Data2/hjc/MJO/data/on/"
dir2="/media/cmlws/Data2/hjc/MJO/data/off/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"COBALT_EOF_Tropical_Pacific_PC_timeseries_on_off.nc","r")
tos_on_eof_ts=f->tos_on_eof_ts;3 x 240
tos_off_eof_ts=f->tos_off_eof_ts
y=ispan(1,240,1)

plot=new(6,graphic)
wks=gsn_open_wks("png",dir3+"EOF_on_off_tropical_pacific_PC_timeseries")
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
res@gsnRightString=""
res@tiXAxisString ="Time"
res@tiXAxisFontHeightF=0.025
res@tiYAxisString =""
res@trXMinF  = 0
res@trXMaxF=240
res@tmXBMode="Explicit"
res@tmXBValues=(/0,60,120,180,240/)
res@tmXBLabels=(/"2000","2005","2010","2015","2020"/)
res@tmXBLabelFontHeightF=0.025
res@tmYLLabelFontHeightF=0.025
res@xyLineThicknessF    = 4
res@xyDashPattern=0
res@xyLineColor="black"
res@gsnLeftStringFontHeightF=0.03
res@gsnLeftString="EOF1"
res@trYMinF  = -400
res@trYMaxF=400
plot(0)=gsn_csm_xy(wks,y,tos_on_eof_ts(0,:),res)
plot(1)=gsn_csm_xy(wks,y,tos_off_eof_ts(0,:),res)
res@gsnLeftString="EOF2"
plot(2)=gsn_csm_xy(wks,y,tos_on_eof_ts(1,:),res)
plot(3)=gsn_csm_xy(wks,y,tos_off_eof_ts(1,:),res)
res@gsnLeftString="EOF3"
;res@tmYLMode="Manual"
;res@tmYLTickStartF=0
;res@tmYLTickSpacingF=50
res@trYMinF  = -160
res@trYMaxF=160
plot(4)=gsn_csm_xy(wks,y,tos_on_eof_ts(2,:),res)
plot(5)=gsn_csm_xy(wks,y,tos_off_eof_ts(2,:),res)

resP                     = True         ; modify the panel plot
resP@gsnMaximize         = True   
;resP@gsnPanelYWhiteSpacePercent = 7
resP@gsnPanelMainString  = ""
resP@gsnPanelTop=0.95

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.016
gsn_text_ndc(wks,"COBALT On",0.28,0.97,txres1)
gsn_text_ndc(wks,"COBALT Off",0.78,0.97,txres1)
gsn_panel(wks,plot,(/3,2/),resP)     ; draw all 'neof' as one plot

end
