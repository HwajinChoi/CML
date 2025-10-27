begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;-------------------------------------------OISST-------------------------------------------
f=addfile(dir1+"oisst.monthly_ano.ONDJF.r180x90.199601-201112.nc","r")
oisst1=f->oisst(2:76,:,:)
oisst2=f->oisst(77:79,:,:)
dim=dimsizes(oisst1)
lat_oisst=f->lat({lat_min:lat_max})
lon_oisst=f->lon
rad    = 4.0*atan(1.0)/180.0
clat1   = cos(lat_oisst*rad)

oisst_ONDJF=new((/16,dim(1),dim(2)/),"float")
ch=new((/5,dim(1),dim(2)/),"float")

do i=0,14
 ch=oisst1(5*i:5*i+4,:,:)
 oisst_ONDJF(i,:,:)=dim_avg_n_Wrap(ch,0)
end do
ch1=dim_avg_n_Wrap(oisst2,0)
oisst_ONDJF(15,:,:)=ch1
oisst_ONDJF!0="time"
time=ispan(1997,2012,1)
oisst_ONDJF&time=time

oisst_nino34=oisst_ONDJF(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max})
oisst_nino34_wgt = wgt_areaave_Wrap(oisst_nino34,clat1,1.0,1)
oisst_nino34_wgt!0="time_counter"

 wks = gsn_open_wks("x11",dir3+"Nino3.4_index_OISST_1997-2011")             ; send graphics to PNG file
 plot=new(1,graphic)
 plot1=new(1,graphic)
 res   = True
; res@gsnScale = True
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF = 0.43        ; Changes the aspect ratio
 res@vpWidthF  = 0.7
 res@trYMinF   = -3.        ; min value on y-axis
 res@trYMaxF   =  3.        ; max value on y-axis
 res@gsnCenterStringOrthogonalPosF=0.05
 res@gsnLeftStringFontHeightF=0.025
 res@trXMaxF            = 2011
 res@trXMinF            = 1997          ; set x-axis minimum
 res@tiYAxisString = "~S~o~N~C" ; y-axis label
 res@tiXAxisString = "Year"
 res@tiYAxisFontHeightF=0.02
 res@tiXAxisFontHeightF=0.02
 res@tmXBMode          = "Explicit"
 res@tmXBValues        = (/2000,2005,2010/)
 res@tmXBMinorPerMajor=4
 res@tmXBLabels        = (/2000,2005,2010/)
 res@tmXBMinorValues=(/1997,1998,1999,2001,2002,2003,2004,2006,2007,2008,2009,2011/)
 res@tmYMajorGrid                = True    ; Turn on grid lines
 res@tmYMajorGridLineDashPattern = 2       ; Dashed lines
 res@tmYMajorGridThicknessF      = 1.0
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
 gsn_text_ndc(wks, "EL",  0.25, 0.76, txres)
 gsn_text_ndc(wks, "EL",  0.5, 0.69, txres)
 gsn_text_ndc(wks, "EL",  0.85, 0.718, txres)

 draw(plot)
 frame(wks)

end
