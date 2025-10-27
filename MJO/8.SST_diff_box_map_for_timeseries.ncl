begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
dir1="/media/cmlws/Data2/hjc/MJO/data/RE/cobalt/"
dir2="/media/cmlws/Data2/hjc/MJO/data/off/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

b2 = addfile(file11,"r")

f=addfile(dir1+"tos.199001-200912.nc","r")
tos=f->tos ; 240
yh=f->yh
xh=f->xh
lsm_t85  = landsea_mask(b2->LSMASK,yh,xh)
rad    = 4.0*atan(1.0)/180.0
clat   = cos(yh*rad)
tos_DJF=month_to_season(tos,"DJF")
tos_JJA=month_to_season(tos,"JJA")
tos_annual=month_to_annual(tos,1)

tos_DJF2=dim_avg_n_Wrap(tos_DJF,0); average of DJF
tos_JJA2=dim_avg_n_Wrap(tos_JJA,0) ; average of JJA
tos_annual2=dim_avg_n_Wrap(tos_annual,0)

plot=new(3,graphic)
wks=gsn_open_wks("png",dir3+"tos_BOX_coabalt_DJF_JJA_tropical_map_90-09")
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
res@cnFillPalette        = "matlab_jet"
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     32
res@cnMinLevelValF         =     20 
res@cnLevelSpacingF        =       1
plot(0) = gsn_csm_contour_map(wks,tos_annual2,res)
res@gsnCenterString  ="JJA"
plot(1) = gsn_csm_contour_map(wks,tos_JJA2,res)
res@gsnCenterString  ="DJF"
plot(2) = gsn_csm_contour_map(wks,tos_DJF2,res)
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
