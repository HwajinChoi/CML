; ==============>  prototype plot procedure  <================= 
; create Hovmueller plots
; =============================================================
undef ("band_pass_hovmueller_plot")
procedure band_pass_hovmueller_plot( x[*][*]:numeric    \  ; (time,lon)
                                   , pltDir[1]:string   \
                                   , pltType[1]:string  \
                                   , pltName[1]:string  \
                                   , opt[1]:logical  )

local date, yrfrac, TIME, ntim, yyyy, mm, dd, hh, pltPath \
    , resH, hplt, nt, ntm, monNam, tValL, tLabL           \
    , tValR, tLabR
begin
  pltPath = pltDir+"/"+pltName
  wks     = gsn_open_wks(pltType , pltPath)
  resH                       = True     ; plot mods desired
  resH@vpWidthF = 0.8
  resH@vpHeightF = 0.4
  ;resH@pmLabelBarOrthogonalPosF=0.3
  resH@cnLevelSelectionMode="ManualLevels"
  resH@cnFillOn              = True     ; turn on color fill
  resH@cnLinesOn             = False    ; turn of contour lines
  resH@cnLineLabelsOn        = False    ; turn of contour line labels
  resH@cnFillPalette	     = "GMT_polar" 
  resH@tmYLLabelFontHeightF   =       0.02
  resH@tiYAxisString="SST (MJO Phase)"
  resH@tiXAxisString=""
  resH@gsnCenterString="00-19 DecFeb MJO (OFF), Comp. (0-15N)"

  resH@pmLabelBarHeightF     = 0.08      ; default is taller
  resH@pmLabelBarWidthF=0.8
  resH@trYReverse            = False     ; reverse the y (time) axis
  resH@gsnMaximize           = True
  resH@gsnPaperOrientation   = "portrait"
  resH@cnLevelSpacingF=0.025
  resH@cnMinLevelValF=-0.25
  resH@cnMaxLevelValF=0.25

  resH@tmYLMode              = "Explicit"
  resH@tmYLValues            = ispan(1,16,1) 
  resH@tmYLLabels            = (/"1","2","3","4","5","6","7","8","1","2","3","4","5","6","7","8"/)
  resH@tmXBMode="Explicit"
  resH@tmXBValues =ispan(30,240,30)
  resH@tmXBLabels=(/"30E","60E","90E","120E","160E","180","150W","120W"/)      
  
  hplt   = gsn_csm_contour(wks, x, resH)

end
; ====================================================
