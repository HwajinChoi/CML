begin
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_cobalt_Index_PC1_2_19900101-20091231.nc","r")
MJO_co=f->MJO_INDEX

g=addfile(dir1+"MJO_daily_chl_Index_PC1_2_19900101-20091231.nc","r")
MJO_daily=g->MJO_INDEX

h=addfile(dir1+"MJO_clim_chl_Index_PC1_2_19900101-20091231.nc","r")
MJO_clim=h->MJO_INDEX

NBIN=25
mjo1  = pdfx(MJO_co, NBIN, False)
mjo2  = pdfx(MJO_daily, NBIN, False)
mjo3  = pdfx(MJO_clim, NBIN, False)

nVar    = 4
nBin    = mjo1@nbins          ; retrieve the number of bins

xx      = new ( (/3,nBin/), typeof(mjo1))
xx(0,:) = mjo1@bin_center     ; assign appropriate "x" axis values
xx(1,:) = mjo2@bin_center     ; assign appropriate "x" axis values
xx(2,:) = mjo3@bin_center     ; assign appropriate "x" axis values

yy      = new ( (/3, nBin/), typeof(mjo1))
yy(0,:) = (/ mjo1 /)
yy(1,:) = (/ mjo2 /)
yy(2,:) = (/ mjo3 /)
;print(mjo2@bin_center)
;exit

co_avg=avg(MJO_co)
daily_avg=avg(MJO_daily)
clim_avg=avg(MJO_clim)

wks  = gsn_open_wks ("png",dir2+"RMM_amplitude_3scenarios_PDF_total")                ; send graphics to PNG file
res  = True
res@trXMaxF=4.5
res@trXMinF=0
res@trYMaxF=12
res@trYMinF=0
res@xyLineThicknesses        = (/4.0,4.0,4.0/)
res@xyLineColors             = (/"black","red","blue"/)
res@xyMonoDashPattern        = True              ; all solid 
res@tiYAxisString            = "PDF (%)"
res@tiXAxisString            = "square root of (PC1^2+ PC2^2)"
;res@tmXBMode="Manual"
;res@tmXBTickStartF=0
;res@tmXBTickEndF=4

;res@gsnXYBarChart            = True              ; Create bar plot
;res@gsnXYBarChartOutlineOnly = True
res@gsnXRefLine=(/1/)
res@gsnXRefLineColors=(/"gray50"/)
res@gsnXRefLineDashPatterns=(/1/)

res@pmLegendDisplayMode    = "always"            ; turn on legend
res@pmLegendSide           = "Top"               ; Change location of 
res@pmLegendParallelPosF   = .85                 ; move units right
res@pmLegendOrthogonalPosF = -0.4                ; move units down
res@pmLegendWidthF         = 0.125               ; Change width and
res@pmLegendHeightF        = 0.15                ; height of legend.
res@lgPerimOn              = True                ; turn off/on box around
res@lgLabelFontHeightF     = .015                ; label font height
res@xyExplicitLegendLabels = (/"COBALT","Daily","Clim"/)  ; create explicit labels

res@tiMainString           = "PDF; 19901231-20091231"
plot = gsn_csm_xy (wks, xx, yy, res)

end
