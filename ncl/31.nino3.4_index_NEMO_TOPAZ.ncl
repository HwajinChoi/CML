begin
dir1="/media/cmlws/Data2/hjc/NEMO/r4.0.6/output_pro/"
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;-------------------------------------------OISST-------------------------------------------
f=addfile(dir1+"sst_NEMO_TOPAZ_1950-2009_ONDJF_monthly_ano.nc","r")
temp1=f->temp(2:296,:,:)
temp2=f->temp(297:299,:,:)
dim=dimsizes(temp1)
lat=f->lat({lat_min:lat_max})
lon=f->lon
rad    = 4.0*atan(1.0)/180.0
clat1   = cos(lat*rad)

ONDJF=new((/60,dim(1),dim(2)/),"float")
ch=new((/5,dim(1),dim(2)/),"float")

do i=0,58
 ch=temp1(5*i:5*i+4,:,:)
 ONDJF(i,:,:)=dim_avg_n_Wrap(ch,0)
end do
ch1=dim_avg_n_Wrap(temp2,0)
ONDJF(59,:,:)=ch1
ONDJF!0="time"
time=ispan(1950,2009,1)
ONDJF&time=time

oisst_nino34=ONDJF(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
oisst_nino34_wgt = wgt_areaave_Wrap(oisst_nino34,clat1,1.0,1)
oisst_nino34_wgt!0="time_counter"

 wks = gsn_open_wks("x11",dir3+"Nino3.4_index_NEMO_TOPAZ_1950-2009")             ; send graphics to PNG file
 plot=new(1,graphic)
 plot1=new(1,graphic)
 res   = True
; res@gsnScale = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF = 0.43        ; Changes the aspect ratio
 res@vpWidthF  = 0.7
 res@trYMinF   = -3.5       ; min value on y-axis
 res@trYMaxF   =  3.5        ; max value on y-axis
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnLeftStringFontHeightF=0.025
 res@trXMaxF            = 2009
 res@trXMinF            = 1981          ; set x-axis minimum
 res@tiYAxisString = "~S~o~N~C" ; y-axis label
 res@tiXAxisString = "Year"
 res@tiYAxisFontHeightF=0.02
 res@tiXAxisFontHeightF=0.02
 res@tmYLMode          = "Manual"
 res@tmYLTickSpacingF  =  1
 res@tmYLTickStartF    = -3
 ;res@tmYLTickEndF      = 10
 res@tmYLMinorPerMajor=4

; res@tmXBMode          = "Explicit"
; res@tmXBValues        = (/2000,2005,2010/)
; res@tmXBMinorPerMajor=4
; res@tmXBLabels        = (/2000,2005,2010/)
; res@tmXBMinorValues=(/1997,1998,1999,2001,2002,2003,2004,2006,2007,2008,2009,2011/)
 res@tmYMajorGrid                = True    ; Turn on grid lines
 res@tmYMajorGridLineDashPattern = 2       ; Dashed lines
 res@tmYMajorGridThicknessF      = 1.0
 ;res@tmYLTickSpacingF=0.1
; res@gsnYRefLineColors = (/"black","black","black","black","black"/)
; res@gsnYRefLineDashPatterns=(/0,0,0,0,0/)
 res@gsnYRefLine       = 0
 res@gsnXYBarChart         = True            ; create bar chart
 res@gsnXYBarChartBarWidth=0.5
 res@gsnAboveYRefLineColor = "darkgreen"           ; above ref line fill red
 res@gsnBelowYRefLineColor = "darkgreen"          ; below ref line fill blue
 res@xyLineColors = (/"darkgreen","darkgreen"/)         ; colors for the above/blow
 res@gsnCenterStringFontHeightF=0.025
 res@gsnCenterString="Nino 3.4 index (ONDJF)"
 plot = gsn_csm_xy(wks,time,oisst_nino34_wgt,res)

 txres               = True
 txres@txFontHeightF = 0.014
 txres@txFontColor="red"
 txres@txFontThicknessF=3
; gsn_text_ndc(wks, "EL",  0.282, 0.67, txres)
 gsn_text_ndc(wks, "EL",  0.46, 0.70, txres)
; gsn_text_ndc(wks, "EL",  0.545, 0.665, txres)
 gsn_text_ndc(wks, "EL",  0.58, 0.77, txres)
 gsn_text_ndc(wks, "EL",  0.685, 0.69, txres)
 gsn_text_ndc(wks, "EL",  0.757, 0.78, txres)

 gsn_text_ndc(wks, "EL",  0.817, 0.68, txres)
; gsn_text_ndc(wks, "EL",  0.89, 0.695, txres)

 draw(plot)
 frame(wks)

end
