begin
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_cobalt_Index_PC1_2_19900101-20091231.nc","r")
MJO_co_1=f->MJO_INDEX

g=addfile(dir1+"MJO_daily_chl_Index_PC1_2_19900101-20091231.nc","r")
MJO_daily_1=g->MJO_INDEX

h=addfile(dir1+"MJO_clim_chl_Index_PC1_2_19900101-20091231.nc","r")
MJO_clim_1=h->MJO_INDEX
;------------------------------------------------------------------
mjo_co1=new(6,typeof(MJO_co_1))
mjo_co1(0)=num(MJO_co_1.ge.1 .and. MJO_co_1.lt.1.5)
mjo_co1(1)=num(MJO_co_1.ge.1.5 .and. MJO_co_1.lt.2)
mjo_co1(2)=num(MJO_co_1.ge.2 .and. MJO_co_1.lt.2.5)
mjo_co1(3)=num(MJO_co_1.ge.2.5 .and. MJO_co_1.lt.3)
mjo_co1(4)=num(MJO_co_1.ge.3 .and. MJO_co_1.lt.3.5)
mjo_co1(5)=num(MJO_co_1.ge.3.5 .and. MJO_co_1.lt.4)
;------------------------------------------------------------------
mjo_daily1=new(6,typeof(MJO_daily_1))
mjo_daily1(0)=num(MJO_daily_1.ge.1 .and. MJO_daily_1.lt.1.5)
mjo_daily1(1)=num(MJO_daily_1.ge.1.5 .and. MJO_daily_1.lt.2)
mjo_daily1(2)=num(MJO_daily_1.ge.2 .and. MJO_daily_1.lt.2.5)
mjo_daily1(3)=num(MJO_daily_1.ge.2.5 .and. MJO_daily_1.lt.3)
mjo_daily1(4)=num(MJO_daily_1.ge.3 .and. MJO_daily_1.lt.3.5)
mjo_daily1(5)=num(MJO_daily_1.ge.3.5 .and. MJO_daily_1.lt.4)
;------------------------------------------------------------------
mjo_clim1=new(6,typeof(MJO_clim_1))
mjo_clim1(0)=num(MJO_clim_1.ge.1 .and. MJO_clim_1.lt.1.5)
mjo_clim1(1)=num(MJO_clim_1.ge.1.5 .and. MJO_clim_1.lt.2)
mjo_clim1(2)=num(MJO_clim_1.ge.2 .and. MJO_clim_1.lt.2.5)
mjo_clim1(3)=num(MJO_clim_1.ge.2.5 .and. MJO_clim_1.lt.3)
mjo_clim1(4)=num(MJO_clim_1.ge.3 .and. MJO_clim_1.lt.3.5)
mjo_clim1(5)=num(MJO_clim_1.ge.3.5 .and. MJO_clim_1.lt.4)
;------------------------------------------------------------------
stdarr = new((/6,3/),"float")
stdarr(:,0) = (/mjo_co1 /)
stdarr(:,1) = (/mjo_daily1/)
stdarr(:,2) = (/mjo_clim1/)
;------------------------------------------------------------------
;--- T-test---
siglvl  = 0.05
aveX    = avg (mjo_co1)      
aveY1    = avg (mjo_daily1)  
aveY2    = avg (mjo_clim1)  
varX    = variance (mjo_co1)
varY1    = variance (mjo_daily1)
varY2    = variance (mjo_clim1)
sX      = dimsizes (mjo_co1)  
sY1      = dimsizes (mjo_daily1)
sY2      = dimsizes (mjo_clim1)
                                                 ; Following not used; FYI only
diffXY1  = aveX - aveY1                            ; 4.378
diffXY2  = aveX - aveY2                            ; 4.378

iflag   = True                                   ; population variance similar
tval_opt= False                                  ; p-value only
prob1 = ttest(aveX,varX,sX, aveY1,varY1,sY1, iflag, True) 
prob2 = ttest(aveX,varX,sX, aveY2,varY2,sY2, iflag, True) 
print(prob1)
print(prob2)
exit
;------------------------------------------------------------------

     wks  = gsn_open_wks ("png",dir2+"RMM_amplitude_total_periods")                ; send graphics to PNG file
     sres = True
     sres@vpWidthF = 0.7
     sres@vpHeightF = 0.5
     sres@vpXF = .15
     sres@trXMinF = 0.4
     sres@trXMaxF = 6.6
     sres@trYMinF = 0
     sres@trYMaxF = 2200
     sres@gsnDraw = True
     sres@gsnFrame = False
     sres@gsnXYBarChart = True
     sres@gsnXYBarChartBarWidth = 0.15           ; change bar widths
     sres@tmXBMode          = "Explicit"         ; explicit labels
     sres@tmXBValues        = (/1,2,3,4,5,6/)
     sres@tmXBLabels = (/"1-1.5","1.5-2","2-2.5","2.5-3","3-3.5","3.5-4"/)
     sres@tmXBLabelFontHeightF = 0.0205
     sres@tmXTLabelFontHeightF = 0.0205
     sres@tmYLLabelFontHeightF = 0.0225
     sres@tiMainFontHeightF = 0.025
     sres@tiMainString = "19900101-20091231"
     sres@gsnRightString = ""
     sres@tiYAxisString = "Frequency"
     sres@tiXAxisString = "square root of (PC1^2+ PC2^2)"
        
     sres@gsnXYBarChartColors = (/"black"/)	
     plot1 = gsn_csm_xy(wks,fspan(.775,5.775,6),stdarr(:,0),sres)		; draw each time series
     sres@gsnXYBarChartColors = (/"red"/)					; seperately, not
     plot2 = gsn_csm_xy(wks,fspan(.925,5.925,6),stdarr(:,1),sres)		; advancing the frame
     sres@gsnXYBarChartColors = (/"blue"/)					; but tweaking where
     plot3 = gsn_csm_xy(wks,fspan(1.075,6.075,6),stdarr(:,2),sres)		; each time series is

     lbres                    = True          ; labelbar only resources
     lbres@vpWidthF           = 0.12           ; labelbar width
     lbres@vpHeightF          = 0.12           ; labelbar height
     lbres@lbBoxMajorExtentF  = 0.12          ; puts space between color boxes
     lbres@lbFillColors       = (/"black","red","blue"/)
     lbres@lbMonoFillPattern  = True          ; Solid fill pattern
     lbres@lbLabelFontHeightF = 0.02         ; font height. default is small
     lbres@lbLabelJust        = "centerleft"  ; left justify labels
     lbres@lbPerimOn          = False
     lbres@lgPerimColor 	 = "white"
     labels = (/"COBALT","Daily","Clim"/)
     gsn_labelbar_ndc(wks,3,labels,0.68,0.80,lbres)	; draw right labelbar column
     frame(wks)      

end
