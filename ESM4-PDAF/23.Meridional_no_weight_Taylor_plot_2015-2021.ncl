load "./taylor_diagram_hj.ncl"

begin
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
name=(/"ESM4-PDAF_ocean","ESM4-PDAF_coupled","ECDA","GODAS","ECCO","SODA"/)
colors=(/"red","magenta","gold","green","blue","purple"/)
Markers = (/ 4, 6, 8,  0, 9, 12/) ; Marker Indices 

f=addfile(dir1+"no_weight_Taylor_stats_EN4_PDAFs_reanalysis_Meridional_mean_temp_sal_from_2015.nc","r")
sal_cc=f->sal_cc
temp_cc=f->temp_cc
sal_ratio=f->sal_ratio
temp_ratio=f->temp_ratio
;print(sal_cc)
;print(sal_ratio)
;exit

TEMP_CC=conform_dims((/6,1/),temp_cc,0)
TEMP_RATIO=conform_dims((/6,1/),temp_ratio,0)

SAL_CC=conform_dims((/6,1/),sal_cc,0)
SAL_RATIO=conform_dims((/6,1/),sal_ratio,0)

;**********************************
; create plot
;**********************************
 plot=new(2,graphic)

  ty_opt   = True                           ; taylor diagram with options
        
  ty_opt@Markers       = Markers 
  ty_opt@Colors        = colors 
  ty_opt@varLabels     = ""
  ty_opt@caseLabels    = name 

  ty_opt@varLabelsYloc = 1.5                ; Move location of variable labels [default 0.45]
  ty_opt@caseLabelsFontHeightF = 0.2       ; make slight larger   [default=0.12 ]
  ty_opt@varLabelsFontHeightF  = 0.015      ; make slight smaller  [default=0.013]
  ty_opt@gsMarkerSizeF =  0.01
  ty_opt@gsMarkerThicknessF=5.0
 
  ty_opt@tiMainString  = "Temperature"           ; title
  ty_opt@stnRad        = (/ 0.5, 1.5 /)     ; additional standard radii
  ty_opt@ccRays        = (/ 0.6, 0.9 /)     ; correllation rays
  ty_opt@centerDiffRMS = True               ; RMS 'circles'

  wks   = gsn_open_wks("png",dir2+"Taylor_plot_Meridional_mean_no_weight_temp_sal_from_2015")      ; send graphics to PNG file
  plot(0)  = taylor_diagram(wks,TEMP_RATIO,TEMP_CC,ty_opt)
  ty_opt@tiMainString  = "Salinity"           ; title
  plot(1)  = taylor_diagram(wks,SAL_RATIO,SAL_CC,ty_opt)

  resP                     = True         ; modify the panel plot
  resP@gsnMaximize         = False  
  resP@gsnPanelBottom=0.02
  resP@gsnPanelTop=0.98
  resP@gsnPanelYWhiteSpacePercent=5
  gsn_panel(wks,plot,(/2,1/),resP)

end
