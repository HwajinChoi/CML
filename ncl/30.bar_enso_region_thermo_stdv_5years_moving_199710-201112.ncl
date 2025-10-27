begin
dir1="/media/cmlws/Data2/hjc/NEMO/r4.0.6/output_pro/"
dir4="/media/cmlws/Data2/hjc/image/"
;--------------------------------------------------------------------------------------------
f=addfile(dir1+"thermo_nino_region_5_moving_199801-201112.nc","r")
sst_nino3_mv=f->sst_nino3_mv;data(oisst,clim,const,inter)
sst_nino34_mv=f->sst_nino34_mv
sst_nino4_mv=f->sst_nino4_mv

y_nino3=dim_stddev_n_Wrap(sst_nino3_mv,1)
y_nino34=dim_stddev_n_Wrap(sst_nino34_mv,1)
y_nino4=dim_stddev_n_Wrap(sst_nino4_mv,1)
;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------

 plot=new(3,graphic)
 wks  = gsn_open_wks("png",dir4+"bar_enso_region_thermo_stdv_5_moving_199801-201112")    ; send graphics to PNG file
 x=(/1,2,3/)

 res			=	True
 res@gsnFrame              = False                ; don't advance frame yet
 res@gsnDraw                =       False
 res@gsnXYBarChart         = True                 ; turn on bar chart
 res@gsnXYBarChartBarWidth = 0.75                 ; change bar widths
 res@gsnXYBarChartColors = (/"black","black","black"/)  
 res@vpHeightF=0.4
 res@vpWidthF=0.6
 res@trXMinF               = 0                    ; adds space on either end
 res@trXMaxF               = 4                    ; of the 1st and last bars
 res@gsnLeftStringFontHeightF=0.022
 res@gsnLeftStringOrthogonalPosF=0.05
 res@tmXBMode                 = "Explicit"
 res@tmXBValues               = ispan(1,3,1)
 res@tmXBLabels		=(/"CLIM","CONST","INTER"/)
 res@gsnLeftString		= "STDV NINO3"
 res@tiYAxisString		= ""
 res@gsnRightString		= ""
 res@tmYLMode		=	"Manual"
 res@tmYLTickSpacingF		=1
 res@trYMinF               = 0                   ; bring bars down to zero
 res@trYMaxF               = 4                   ; bring bars down to zero
 plot(0) = gsn_csm_xy (wks,x,y_nino3,res)
 res@gsnLeftString		= "STDV NINO34"
 res@trYMinF               = 0                   ; bring bars down to zero
 res@trYMaxF               = 3                   ; bring bars down to zero
 plot(1) = gsn_csm_xy (wks,x,y_nino34,res)
 res@trYMinF               = 0                   ; bring bars down to zero
 res@trYMaxF               = 3                   ; bring bars down to zero
 res@gsnLeftString		= "STDV NINO4"
 plot(2) = gsn_csm_xy (wks,x,y_nino4,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Standard deviation of 5 moving thermocline depth (199801 - 201112)"
; pres@gsnPanelBottom=0.1
; pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 5
 gsn_panel(wks,plot,(/3,1/),pres)
 txres               = True
 txres@txFontHeightF = 0.014
; txres@txAngleF      = 90.
; gsn_text_ndc(wks, "OISST",  0.1, 0.83, txres)
; gsn_text_ndc(wks, "CLIM",  0.105, 0.628, txres)
; gsn_text_ndc(wks, "CONST", 0.1, 0.41, txres)
; gsn_text_ndc(wks, "INTER", 0.105, 0.205, txres)
 
 frame(wks)

end
