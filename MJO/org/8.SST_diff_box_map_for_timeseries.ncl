begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
dir1="/media/cmlws/Data2/hjc/MJO/data/on/"
dir2="/media/cmlws/Data2/hjc/MJO/data/off/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

b2 = addfile(file11,"r")

f=addfile(dir1+"tos_0_360_200001-201912.nc","r")
tos_on=f->tos ; 240
yh=f->yh
xh=f->xh
lsm_t85  = landsea_mask(b2->LSMASK,yh,xh)
rad    = 4.0*atan(1.0)/180.0
clat   = cos(yh*rad)
tos_on_DJF=month_to_season(tos_on,"DJF")
tos_on_JJA=month_to_season(tos_on,"JJA")
tos_on_annual=month_to_annual(tos_on,1)

tos_on_DJF2=dim_avg_n_Wrap(tos_on_DJF,0); average of DJF
tos_on_JJA2=dim_avg_n_Wrap(tos_on_JJA,0) ; average of JJA
tos_on_annual2=dim_avg_n_Wrap(tos_on_annual,0)

g=addfile(dir2+"tos_0_360_200001-201912.nc","r")
tos_off=g->tos
tos_off_DJF=month_to_season(tos_off,"DJF")
tos_off_JJA=month_to_season(tos_off,"JJA")
tos_off_annual=month_to_annual(tos_off,1)

tos_off_DJF2=dim_avg_n_Wrap(tos_off_DJF,0) ; average of DJF
tos_off_JJA2=dim_avg_n_Wrap(tos_off_JJA,0) ; average of JJA
tos_off_annual2=dim_avg_n_Wrap(tos_off_annual,0)

tos_diff_annual=tos_on_annual2-tos_off_annual2
tos_diff_DJF=tos_on_DJF2-tos_off_DJF2
tos_diff_JJA=tos_on_JJA2-tos_off_JJA2
copy_VarMeta(tos_on_annual2,tos_diff_annual)
copy_VarMeta(tos_on_DJF2,tos_diff_DJF)
copy_VarMeta(tos_on_JJA2,tos_diff_JJA)

;-- For t-test ------
iflag= False                        ; population variance similar
sigr = 0.05                        ; critical sig lvl for r
on_Eqv = equiv_sample_size (tos_on_DJF(yh|:,xh|:,time|:), sigr,0)
off_Eqv = equiv_sample_size (tos_off_DJF(yh|:,xh|:,time|:), sigr,0)

on_N=wgt_areaave(on_Eqv, clat, 1., 0)    ; wgty could be gaussian weights 
off_N=wgt_areaave(off_Eqv, clat, 1., 0) 

tos_on_DJF_var=dim_variance_n_Wrap(tos_on_DJF,0) ; time(20) x lat x lon
tos_off_DJF_var=dim_variance_n_Wrap(tos_off_DJF,0)
tos_on_JJA_var=dim_variance_n_Wrap(tos_on_JJA,0) ; time(20) x lat x lon
tos_off_JJA_var=dim_variance_n_Wrap(tos_off_JJA,0)

tos_on_annual_var=dim_variance_n_Wrap(tos_on_annual,0) ; time(20) x lat x lon
tos_off_annual_var=dim_variance_n_Wrap(tos_off_annual,0)

DJF_prob = ttest(tos_on_DJF2,tos_on_DJF_var,on_N,tos_off_DJF2,tos_off_DJF_var,off_N,iflag, False) 
JJA_prob = ttest(tos_on_JJA2,tos_on_JJA_var,on_N,tos_off_JJA2,tos_off_JJA_var,off_N,iflag, False) 
annual_prob = ttest(tos_on_annual2,tos_on_annual_var,on_N,tos_off_annual2,tos_off_annual_var,off_N,iflag, False) 
copy_VarMeta(tos_on_DJF2,DJF_prob)
copy_VarMeta(tos_on_JJA2,JJA_prob)
copy_VarMeta(tos_on_annual2,annual_prob)

DJF_sig=where(DJF_prob .lt. sigr,2.,-100.)
copy_VarCoords(DJF_prob,DJF_sig)
DJF_sig@_FillValue =-100.
DJF_sig2= mask(DJF_sig,lsm_t85 .eq.1,False)
copy_VarCoords(DJF_sig,DJF_sig2)
dim=dimsizes(DJF_sig2)
test=new((/dim(0),dim(1)/),"float")
copy_VarCoords(DJF_sig2,test)
test=2
test2=new((/dim(0),dim(1)/),"float")
copy_VarCoords(DJF_sig2,test2)
test2=0

;print(DJF_sig2({-30:30},:))
;exit

JJA_sig=where(JJA_prob .lt. sigr,2.,-100.)
copy_VarCoords(JJA_prob,JJA_sig)
JJA_sig@_FillValue =-100.
JJA_sig2= mask(JJA_sig,lsm_t85.eq.1,False)
copy_VarCoords(JJA_sig,JJA_sig2)

annual_sig=where(annual_prob .lt. sigr,2.,-100. )
copy_VarCoords(annual_prob,annual_sig)
annual_sig@_FillValue =-100.
annual_sig2= mask(annual_sig,lsm_t85.eq.1,False)
copy_VarCoords(annual_sig,annual_sig2)

plot=new(3,graphic)
plot1=new(3,graphic)
wks=gsn_open_wks("png",dir3+"tos_BOX_diff_clim_DJF_JJA_tropical_map")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@vpHeightF=0.2
;res@vpWidthF=0.8
res@cnFillOn             = True         ; turn on color fill
res@cnLineLabelsOn         =       False
res@cnLinesOn            = False         ; True is default
res@lbLabelBarOn         = True        ; turn off individual lb's
res@gsnAddCyclic=False
res@mpCenterLonF         = 180.         ; defailt is 0 [GM]
;res@mpMinLatF            =-30 
;res@mpMaxLatF            =30
;res@mpMinLonF            = 0
;res@mpMaxLonF            = 360
sres=res
res@mpShapeMode  = "FreeAspect"
res@mpFillDrawOrder      = "PostDraw"
res@mpLandFillColor      = "black"
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
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
res@gsnAddCyclic         = False 

sres@cnConstFEnableFill    =   True
sres@cnMonoFillColor   =   True
sres@cnFillColor       =   "magenta"
sres@cnFillOn              =       True
sres@cnMonoFillPattern =   True
sres@cnFillScaleF      =   2   
sres@cnFillPattern     =   3  
sres@cnLinesOn             =       False
sres@cnLevelSelectionMode = "ExplicitLevels"
sres@cnLevels = (/0.,3/)
sres@cnInfoLabelOn = False
sres@tiMainOn = False
sres@gsnCenterString   = ""
sres@lbLabelBarOn      =   False
sres@cnFillDotSizeF=0.005
sres@cnMonoLineThickness = True ;
sres@cnLineThicknessF = 4
sres@cnConstFLabelOn=False
sres@trGridType="TriangularMesh"

opt            =   True
opt@gsnShadeLow         = 17
opt@gsnShadeFillType     = "pattern"
opt@gsnShadeFillScaleF   = 0.5 
opt@gsnShadeFillDotSizeF = 0.06

; panel plot only resources
resP                     = True         ; modify the panel plot
resP@gsnMaximize         = True         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
;resP@lbLabelFontHeightF  = 0.012
;resP@gsnPanelYWhiteSpacePercent = 5
;resP@gsnPanelLeft=0.12

resP@gsnPanelMainString  = ""
res@gsnRightString = "" 
res@gsnLeftString  ="" 
res@gsnCenterString  ="Annual"
;plot(0) = gsn_csm_contour_map(wks,tos_on_annual2,res)
;res@gsnAddCyclic=False
;plot(1) = gsn_csm_contour_map(wks,tos_on_JJA2,res)
;plot(2) = gsn_csm_contour_map(wks,tos_on_DJF2,res)
;res@gsnCenterString  =""
;plot(3) = gsn_csm_contour_map(wks,tos_off_annual2,res)
;;plot(4) = gsn_csm_contour_map(wks,tos_off_JJA2,res)
;plot(5) = gsn_csm_contour_map(wks,tos_off_DJF2,res)
res@cnFillPalette        = "BlueDarkRed18"
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      0.5
res@cnMinLevelValF         =      -0.5
res@cnLevelSpacingF        =       0.1
plot(0) = gsn_csm_contour_map(wks,tos_diff_annual,res)
plot1(0)=gsn_csm_contour(wks,annual_sig2,sres)
plot1(0)=ShadeGtContour(plot1(0),2,14)
overlay(plot(0),plot1(0))
res@gsnCenterString  ="JJA"
plot(1) = gsn_csm_contour_map(wks,tos_diff_JJA,res)
plot1(1)=gsn_csm_contour(wks,JJA_sig2,sres)
plot1(1)=ShadeGtContour(plot1(1),2,14)
overlay(plot(1),plot1(1))
res@gsnCenterString  ="DJF"
plot(2) = gsn_csm_contour_map(wks,tos_diff_DJF,res)
plot1(2)=gsn_csm_contour(wks,DJF_sig2,sres)
plot1(2)=ShadeGtContour(plot1(2),2,14)
overlay(plot(2),plot1(2))
;------------India-------------
ypts = (/-20,-20, 20,20,-20/)
xpts = (/100,130,130,100,100/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 3.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(3,graphic)
 do I=0,2
  dum2(I)=gsn_add_polyline(wks,plot(I),xpts,ypts,resp)
 end do
;---------------------------------------------------------------
ypts = (/-20,-20, 0,0,-20/)
xpts = (/50,80,80,50,50/)
dum3 = new(3,graphic)
 do I=0,2
  dum3(I)=gsn_add_polyline(wks,plot(I),xpts,ypts,resp)
 end do
;----Tropical Pacific-----------------------------------------------------------
ypts = (/-10,-10, 10,10,-10/)
xpts = (/160,240,240,160,160/)
dum4 = new(3,graphic)
 do I=0,2
  dum4(I)=gsn_add_polyline(wks,plot(I),xpts,ypts,resp)
 end do
;----Eastern Pacific ocean-----------------------------------------------------------
ypts = (/-30,-30, 0,0,-30/)
xpts = (/250,280,280,250,250/)
dum5 = new(3,graphic)
 do I=0,2
  dum5(I)=gsn_add_polyline(wks,plot(I),xpts,ypts,resp)
 end do


;txres1               = True                      ; text mods desired
;txres1@txFontHeightF = 0.012
;gsn_text_ndc(wks,"COBALT On",0.06,0.79,txres1)
;gsn_text_ndc(wks,"COBALT Off",0.06,0.52,txres1)
;gsn_text_ndc(wks,"Diff(On - Off)",0.06,0.26,txres1)
gsn_panel(wks,plot,(/3,1/),resP)     ; draw all 'neof' as one plot

end
