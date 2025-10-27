#!/bin/bash
for SSS in "ON" "OFF";do
   if [ $SSS = "ON" ];then
  s="on"
  else
  s="off"
 fi
cat > imsi.ncl << EOF
begin
dir3="/media/cmlws/Data2/hjc/MJO/data/on/"
dir4="/media/cmlws/Data2/hjc/MJO/data/off/"
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_${SSS}_Index_PC1_2_20000101-20191231.nc","r")
MJO_INDEX=f->MJO_INDEX
MJO_1=MJO_INDEX(365*5*0:365*5-1)
MJO_2=MJO_INDEX(365*5*1:365*5*2-1)
MJO_3=MJO_INDEX(365*5*2:365*5*3-1)
MJO_4=MJO_INDEX(365*5*3:365*5*4-1)
NBIN=25
mjo1  = pdfx(MJO_1, NBIN, False)
mjo2  = pdfx(MJO_2, NBIN, False)
mjo3  = pdfx(MJO_3, NBIN, False)
mjo4  = pdfx(MJO_4, NBIN, False)

nVar    = 4
nBin    = mjo1@nbins          ; retrieve the number of bins

xx      = new ( (/nVar, nBin/), typeof(mjo1))

xx(0,:) = mjo1@bin_center     ; assign appropriate "x" axis values
xx(1,:) = mjo2@bin_center
xx(2,:) = mjo3@bin_center
xx(3,:) = mjo4@bin_center

yy      = new ( (/nVar, nBin/), typeof(mjo1))
yy(0,:) = (/ mjo1 /)
yy(1,:) = (/ mjo2 /)
yy(2,:) = (/ mjo3 /)
yy(3,:) = (/ mjo4 /)
wks  = gsn_open_wks ("png",dir2+"RMM_amplitude_${SSS}_PDF_4_periods")                ; send graphics to PNG file
res  = True
res@xyLineThicknesses        = (/4.0,4.0,4.0,4.0/)        
res@xyLineColors             = (/"blue","red","green","black"/)  
res@xyMonoDashPattern        = True              ; all solid 
res@tiYAxisString            = "PDF (%)"
res@tiXAxisString            = "square root of (PC1^2+ PC2^2)"
;res@tmXBMode="Manual"
;res@tmXBTickStartF=0
;res@tmXBTickEndF=4

;res@gsnXYBarChart            = True              ; Create bar plot
;res@gsnXYBarChartOutlineOnly = True
res@gsnXRefLine=1
res@gsnXRefLineDashPattern=1
res@trXMaxF=4
res@trXMinF=0
res@trYMaxF=12
res@trYMinF=0

res@pmLegendDisplayMode    = "Always"            ; turn on legend
res@pmLegendSide           = "Top"               ; Change location of 
res@pmLegendParallelPosF   = .85                 ; move units right
res@pmLegendOrthogonalPosF = -0.4                ; move units down
res@pmLegendWidthF         = 0.125               ; Change width and
res@pmLegendHeightF        = 0.15                ; height of legend.
res@lgPerimOn              = True                ; turn off/on box around
res@lgLabelFontHeightF     = .015                ; label font height
res@xyExplicitLegendLabels = (/"00-04","05-09","10-14","15-19"/)  ; create explicit labels

res@tiMainString           = "PDF; ${SSS}; 20001231-20191231"
plot = gsn_csm_xy (wks, xx, yy, res)

end
EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done
