begin
N=0

m=(/"ACCESS-ESM1-5","CanESM5","CESM2","CNRM-ESM2-1","MIROC-ES2L","NorESM2-LM","UKESM1-0-LL","GFDL-ESM4"/)
dir1="/media/cmlws/Data1/hjc/CDR/data/1pctCO2/chl_int_30/"
dir2="/media/cmlws/Data1/hjc/CDR/data/1pctCO2_cdr/chl_int_30/"
dir3="/media/cmlws/Data1/hjc/CDR/image/"
dir4="/media/cmlws/Data1/hjc/CDR/data/chl_peak_int_30/"

file1=systemfunc("ls "+dir1+"chl_Omon_*.nc")
gfile1=systemfunc("ls "+dir2+"chl_Omon_*.nc")
hfile1=systemfunc("ls "+dir4+"chl_Omon_*.nc")

;CNRM unit problem

f1=addfiles(file1,"r")
ListSetType(f1,"join")
chl=f1[:]->chl
chl := chl(:,:,0,:,:)
chl!0="model"
chl=chl*10^6
chl(3,:,:,:)=chl(3,:,:,:)/(10^3)

g1=addfiles(gfile1,"r")
ListSetType(g1,"join")
chl_cdr=g1[:]->chl
chl_cdr := chl_cdr(:,:,0,:,:)
chl_cdr!0="model"
chl_cdr=chl_cdr*10^6
chl_cdr(3,:,:,:)=chl_cdr(3,:,:,:)/(10^3)
h1=addfiles(hfile1,"r")
ListSetType(h1,"join")
chl_peak=h1[:]->chl
chl_peak := chl_peak(:,:,0,:,:)
chl_peak!0="model"
chl_peak=chl_peak*10^6
chl_peak(3,:,:,:)=chl_peak(3,:,:,:)/(10^3)
;------------------------------------------------------------------------------
CHL=dim_avg_n_Wrap(chl,1)
CHL_mean=dim_avg_n_Wrap(CHL,0)

CHL_cdr=dim_avg_n_Wrap(chl_cdr,1)
CHL_cdr_mean=dim_avg_n_Wrap(CHL_cdr,0)

CHL_peak=dim_avg_n_Wrap(chl_peak,1)
CHL_peak_mean=dim_avg_n_Wrap(CHL_peak,0)
;-----------------------------------------------------------------
diff=CHL_cdr-CHL
copy_VarMeta(CHL,diff)
diff_mean=dim_avg_n_Wrap(diff,0)

peak_diff=CHL_peak-CHL
copy_VarMeta(CHL,peak_diff)
peak_diff_mean=dim_avg_n_Wrap(peak_diff,0)

peak_cdr_diff=CHL_peak-CHL_cdr
copy_VarMeta(CHL,peak_cdr_diff)
peak_cdr_diff_mean=dim_avg_n_Wrap(peak_cdr_diff,0)
;-----------------------------------------------------------------
diff_mask=where(diff .gt. 0 ,1,0) 
peak_diff_mask=where(peak_diff .gt. 0 ,1,0) 
peak_cdr_diff_mask=where(peak_cdr_diff .gt. 0 ,1,0) 
copy_VarCoords(diff,diff_mask)
copy_VarCoords(peak_diff,peak_diff_mask)
copy_VarCoords(peak_cdr_diff,peak_cdr_diff_mask)

diff_MASK=dim_sum_n_Wrap(diff_mask,0)
peak_diff_MASK=dim_sum_n_Wrap(peak_diff_mask,0)
peak_cdr_diff_MASK=dim_sum_n_Wrap(peak_cdr_diff_mask,0)

DIFF=where(diff_MASK .ge. 5 .or. diff_MASK .le. 3 , 1, -1)
copy_VarCoords(diff_MASK,DIFF)
PEAK_DIFF=where(peak_diff_MASK .ge. 5 .or. peak_diff_MASK .le. 3 , 1, -1)
copy_VarCoords(diff_MASK,PEAK_DIFF)
PEAK_CDR_DIFF=where(peak_cdr_diff_MASK .ge. 5 .or. peak_cdr_diff_MASK .le. 3 , 1, -1)
copy_VarCoords(diff_MASK,PEAK_CDR_DIFF)

;print(DIFF)
;exit

;-----------------------------------------------------------------
plot=new(3,graphic)
plot0=new(3,graphic)
plot1=new(3,graphic)
plot2=new(3,graphic)
wks  = gsn_open_wks("png",dir3+"CHL_map_model_AVG_PEAK_diff_30_years_"+N)
res                     = True
res@lbLabelBarOn               = False
res@mpProjection="Robinson"
res@mpPerimOn              = False
res@lbBoxEndCapStyle           = "TriangleBothEnds"
res@lbOrientation              = "Horizontal"        ; orientation
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn           = False
res@cnLineLabelsOn      = False
res@gsnLeftString=""
res@mpLandFillColor    =   "white"
res@gsnRightString=""
res@gsnCenterStringFontHeightF= 0.035
res@gsnCenterStringOrthogonalPosF=0.1
res@tiXAxisString=""
;res@tmXBLabelFontHeightF   =       0.025
;res@tmYLLabelFontHeightF   =       0.025
;res@tmXBLabelStride     =       2
;res@tmYLLabelStride     =       2
res@mpCenterLonF       =       180
res@cnLevelSelectionMode   =       "ManualLevels"
res2	=	res
sres	=	res
res@cnMaxLevelValF         =      0.3
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =       0.02
res@cnFillPalette ="MPL_YlGnBu"
res@gsnCenterString="1pctCO2 (30 years)"
plot(0) = gsn_csm_contour_map(wks,CHL_mean,res)
res@gsnCenterString="Peak (30 years)"
plot(1) = gsn_csm_contour_map(wks,CHL_peak_mean,res)
res@gsnCenterString="1pctCO2_cdr (30 years)"
plot(2) = gsn_csm_contour_map(wks,CHL_cdr_mean,res)

res0	=	True
res0@cnMonoLineColor=True
res0@cnLineColor="black"
res0@gsnDraw        = False
res0@gsnFrame       = False
res0@cnFillOn               = False
res0@cnInfoLabelOn          = False
res0@cnLineLabelsOn         = False
res0@cnLevelSelectionMode   = "ExplicitLevels"     ; manual contour levels
res0@cnMonoLineThickness       = True 
res0@cnLineThicknessF=3
res0@cnLineDashSegLenF  = 0.18
res0@gsnLeftString=""
res0@gsnRightString=""
res0@cnMonoLineDashPattern=0
res0@cnLevels       =  0.07

plot0(0)=gsn_csm_contour(wks,CHL_mean,res0)
plot0(1)=gsn_csm_contour(wks,CHL_peak_mean,res0)
plot0(2)=gsn_csm_contour(wks,CHL_cdr_mean,res0)
 do d=0,2
  overlay(plot(d),plot0(d))
 end do

res2@cnMaxLevelValF         =      0.1
res2@cnMinLevelValF         =      -0.1
res2@cnLevelSpacingF        =       0.02
res2@cnFillPalette ="CBR_coldhot"
res2@gsnCenterString="Diff (Peak - 1pctCO2)"
plot1(0)=gsn_csm_contour_map(wks,peak_diff_mean,res2)
res2@gsnCenterString="Diff (Peak - 1pctCO2_cdr)"
plot1(1)=gsn_csm_contour_map(wks,peak_cdr_diff_mean,res2)
res2@gsnCenterString="Diff (1pctCO2_cdr - 1pctCO2)"
plot1(2)=gsn_csm_contour_map(wks,diff_mean,res2)

sres@cnConstFEnableFill    =   True
sres@cnMonoFillColor   =   True
sres@cnFillColor       =   "black"
sres@cnFillOn              =       True
sres@cnMonoFillPattern =   True
sres@cnFillScaleF      =   1   
sres@cnFillPattern     =   17  
sres@cnLinesOn             =       False
sres@cnLevelSelectionMode = "ExplicitLevels"
sres@cnLevels = (/0.,3/)
sres@cnInfoLabelOn = False
sres@tiMainOn = False
sres@gsnCenterString   = ""
sres@lbLabelBarOn      =   False
sres@cnFillDotSizeF=0.0025
sres@cnConstFLabelOn=False
sres@trGridType="TriangularMesh"

opt            =   True
opt@gsnShadeHigh         = 17
opt@gsnShadeFillType     = "pattern"
opt@gsnShadeFillScaleF   = 0.5 
opt@gsnShadeFillDotSizeF = 0.06

plot2(0)=gsn_csm_contour(wks,PEAK_DIFF,sres)
plot2(0)=ShadeGtContour(plot2(0),2,17)
plot2(1)=gsn_csm_contour(wks,PEAK_CDR_DIFF,sres)
plot2(1)=ShadeGtContour(plot2(1),2,17)
plot2(2)=gsn_csm_contour(wks,DIFF,sres)
plot2(2)=ShadeGtContour(plot2(2),2,17)

 do d=0,2
  overlay(plot1(d),plot2(d))
 end do

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelMainString=""
pres@gsnPanelTop=0.95
pres@gsnPanelBottom=0.4
pres@gsnPanelLeft=0.05
pres@gsnPanelRight=0.95
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 1
pres@pmLabelBarWidthF = 0.8 ; label bar width
pres@pmLabelBarOrthogonalPosF=0.005
pres@lbLabelFontHeightF=0.01
pres@pmLabelBarHeightF = 0.05
pres@lbTitleString="mg/m~S~3~N"
pres@lbTitleFontHeightF=0.012
pres@lbTitlePosition="Bottom"
gsn_panel(wks,plot,(/1,3/),pres)

pres2                       =   True
pres2@gsnFrame         = False
pres2@gsnPanelMainString=""
pres2@gsnPanelBottom=0.05
pres2@gsnPanelTop=0.6
pres2@gsnPanelLeft=0.05
pres2@gsnPanelRight=0.95
pres2@gsnPanelLabelBar      = True
pres2@gsnMaximize        =       False
pres2@gsnPanelYWhiteSpacePercent = 1
pres2@pmLabelBarWidthF = 0.8 ; label bar width
pres2@pmLabelBarOrthogonalPosF=0.005
pres2@lbLabelFontHeightF=0.01
pres2@pmLabelBarHeightF = 0.05
pres2@lbTitleString="mg/m~S~3~N"
pres2@lbTitleFontHeightF=0.012
pres2@lbTitlePosition="Bottom"
gsn_panel(wks,plot1,(/1,3/),pres2)

frame(wks)

end
