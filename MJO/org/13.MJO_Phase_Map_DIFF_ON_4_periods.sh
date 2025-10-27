#!/bin/bash
for months in "6_8" "12_2" ;do
   if [ $months = "12_2" ];then
    season="DJF"
    A="res@cnMaxLevelValF         =      40"
    B="res@cnMinLevelValF         =      -40"
    C="res@cnLevelSpacingF        =       5"
   else
    season="JJA"
    A="res@cnMaxLevelValF         =      40"
    B="res@cnMinLevelValF         =      -40"
    C="res@cnLevelSpacingF        =       5"
   fi
 for N in $(seq 0 3);do
  if [ $N = 0 ];then
   M="Period 1 (2000-2004)"
  elif [ $N = 1 ];then
   M="Period 2 (2005-2009)"
  elif [ $N = 2 ];then
   M="Period 3 (2010-2014)"
  else
   M="Period 4 (2015-2019)"
  fi
cat > imsi.ncl << EOF
begin
dir3="/media/cmlws/Data2/hjc/MJO/data/on/"
dir4="/media/cmlws/Data2/hjc/MJO/data/off/"
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"OLR_map_ON_${months}_MJO_Phase_8_for_ttest_total_period.nc","r")
g=addfile(dir1+"OLR_map_OFF_${months}_MJO_Phase_8_for_ttest_total_period.nc","r")

on_0=f->olr_pattern ; phase x year x lat x lon
off_0=g->olr_pattern

on=on_0(:,5*$N:5*$N+4,:,:)
off=off_0(:,5*$N:5*$N+4,:,:)

grid_yt=f->grid_yt
grid_xt=f->grid_xt
;---------------------------------------------------------------------------------
rad    = 4.0*atan(1.0)/180.0
clat   = cos(grid_yt*rad)
;---------------------------------------------------------------------------------
on_avg=dim_avg_n_Wrap(on,1)
off_avg=dim_avg_n_Wrap(off,1)
on_var=dim_variance_n_Wrap(on,1)
off_var=dim_variance_n_Wrap(off,1)
sigr = 0.05
on_Eq = equiv_sample_size(on(phase|:,grid_yt|:,grid_xt|:,year|:), sigr,0)
off_Eq = equiv_sample_size(off(phase|:,grid_yt|:,grid_xt|:,year|:), sigr,0)
copy_VarCoords(on(:,0,:,:),on_Eq)
copy_VarCoords(off(:,0,:,:),off_Eq)
xN   = wgt_areaave_Wrap (on_Eq, clat, 1., 0)
yN   = wgt_areaave_Wrap (off_Eq, clat, 1., 0)
iflag= False
Pattern=on_avg-off_avg
copy_VarMeta(on_avg,Pattern)

dim=dimsizes(on)
XN=new((/dim(0),dim(2),dim(3)/),typeof(on))
YN=new((/dim(0),dim(2),dim(3)/),typeof(on))
 do i=0,dim(0)-1
  XN(i,:,:)=xN(i)
  YN(i,:,:)=yN(i)
 end do
copy_VarCoords(on_avg,XN)
copy_VarCoords(on_avg,YN)
prob = ttest(on_avg,on_var,XN, off_avg,off_var,YN, iflag, False)

sig=where(prob .lt. sigr,2.,-100.)
copy_VarCoords(on_avg,sig)
sig@_FillValue =-100.
ZZ=num(sig .eq. 2) ; 20681
;---------------------------------------------------------------------------------
plot=new(8,graphic)
plot1=new(8,graphic)
wks=gsn_open_wks("png",dir2+"MJO_DIFF_${months}_Phase_Map_ON_${N}")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@vpHeightF=0.2
;res@vpWidthF=0.8
res@cnFillOn             = True         ; turn on color fill
res@cnLineLabelsOn         =       False
res@cnLinesOn            = False         ; True is default
res@lbLabelBarOn         = False        ; turn off individual lb's
res@gsnAddCyclic=False
res@mpCenterLonF         = 180.         ; defailt is 0 [GM]
res@mpMinLatF            =-20
res@mpMaxLatF            =20
res@mpMinLonF            = 0
res@mpMaxLonF            = 360
res@mpShapeMode  = "FreeAspect"
res@mpFillDrawOrder      = "PostDraw"
res@mpLandFillColor      = "transparent"
res@tmXBLabelFontHeightF   =       0.012
res@tmYLLabelFontHeightF   =       0.012
;res@tmYLMinorPerMajor=1
res@gsnLeftStringFontHeightF=0.028
res@gsnRightStringFontHeightF=0.025
res@tmYLLabelStride     =       2
res@tmXBLabelStride     =       2
res@pmLabelBarOrthogonalPosF=0.35
res@gsnCenterStringFontHeightF=0.04
res@gsnCenterStringOrthogonalPosF=0.15
res@pmLabelBarWidthF=0.75
res@lbLabelFontHeightF  = 0.03
res@gsnRightString = ""
res@gsnLeftString  =""
res@gsnCenterString  =""
res@cnFillPalette        = "CBR_coldhot"
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnInfoLabelOn = False
$A
$B
$C

res2=True
res2@gsnDraw = False
res2@cnConstFEnableFill=True
res2@gsnFrame = False
res2@gsnAddCyclic = False
res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels = (/0.,3./) ;-- draw only the 5% contour line
res2@cnLinesOn = True ;-- draw contour lines
res2@cnLineLabelsOn = False ;-- do not add line labels
res2@lbLabelBarOn = False ;-- disable labelbar
res2@cnFillColor = "black" ;-- trick to have the fill pattern in colour (choose other than "black")
res2@cnFillDotSizeF=0.0025
res2@cnInfoLabelOn = False
res2@cnNoDataLabelOn =False
res2@cnConstFLabelString = ""
res2@cnConstFLabelOn=False
opt = True
opt@gsnShadeFillType = "pattern" ;-- shading is a pattern fill
opt@gsnShadeMid = 17 ;-- pattern type is dots (#17) for all values <= 0.05
opt@gsnShadeFillScaleF = 0.75
opt@cnInfoLabelOn = False

resP                     = True         ; modify the panel plot
resP@gsnMaximize         = False         ; large format
resP@gsnPanelLabelBar    = True         ; add common colorbar
resP@gsnPanelMainString  = "Diff(ON-OFF); ${season}; ${M}"
resP@lbLabelFontHeightF  = 0.012
;resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelLeft=0.12
resP@gsnPanelBottom=0.05

do K=0,7
plot(K) = gsn_csm_contour_map(wks,Pattern(K,:,:),res)
plot1(K)=gsn_csm_contour(wks,sig(K,:,:),res2)
plot1(K)=gsn_contour_shade(plot1(K),0,3,opt)
overlay(plot(K),plot1(K))
end do

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.018
gsn_text_ndc(wks,"Phase 1",0.09,0.90,txres1)
gsn_text_ndc(wks,"Phase 2",0.09,0.79,txres1)
gsn_text_ndc(wks,"Phase 3",0.09,0.68,txres1)
gsn_text_ndc(wks,"Phase 4",0.09,0.57,txres1)
gsn_text_ndc(wks,"Phase 5",0.09,0.46,txres1)
gsn_text_ndc(wks,"Phase 6",0.09,0.35,txres1)
gsn_text_ndc(wks,"Phase 7",0.09,0.245,txres1)
gsn_text_ndc(wks,"Phase 8",0.09,0.135,txres1)
gsn_panel(wks,plot,(/8,1/),resP)     ; draw all 'neof' as one plot

end
EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl
 done
done

