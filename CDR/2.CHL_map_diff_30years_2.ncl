begin
N=1

m=(/"ACCESS-ESM1-5","CanESM5","CESM2","CNRM-ESM2-1","MIROC-ES2L","NorESM2-LM","UKESM1-0-LL"/)
dir1="/media/cmlws/Data1/hjc/CDR/data/1pctCO2/chl_30/surf/"
dir2="/media/cmlws/Data1/hjc/CDR/data/1pctCO2_cdr/chl_30/surf/"
dir3="/media/cmlws/Data1/hjc/CDR/image/"

file1=systemfunc("ls "+dir1+"chl_Omon_"+m(4*N)+"*.nc")
file2=systemfunc("ls "+dir1+"chl_Omon_"+m(4*N+1)+"*.nc")
file3=systemfunc("ls "+dir1+"chl_Omon_"+m(4*N+2)+"*.nc")

gfile1=systemfunc("ls "+dir2+"chl_Omon_"+m(4*N)+"*.nc")
gfile2=systemfunc("ls "+dir2+"chl_Omon_"+m(4*N+1)+"*.nc")
gfile3=systemfunc("ls "+dir2+"chl_Omon_"+m(4*N+2)+"*.nc")

;CNRM unit problem

f1=addfile(file1,"r")
f2=addfile(file2,"r")
f3=addfile(file3,"r")

g1=addfile(gfile1,"r")
g2=addfile(gfile2,"r")
g3=addfile(gfile3,"r")

chl1=f1->chl(:,0,:,:)
chl1@lon2d=f1->longitude
chl1@lat2d=f1->latitude
CHL1=dim_avg_n_Wrap(chl1,0)

cdr_chl1=g1->chl(:,0,:,:)
cdr_chl1@lon2d=g1->longitude
cdr_chl1@lat2d=g1->latitude
cdr_CHL1=dim_avg_n_Wrap(cdr_chl1,0)

chl2=f2->chl(:,0,:,:)
chl2@lon2d=f2->longitude
chl2@lat2d=f2->latitude
CHL2=dim_avg_n_Wrap(chl2,0)

cdr_chl2=g2->chl(:,0,:,:)
cdr_chl2@lon2d=g2->longitude
cdr_chl2@lat2d=g2->latitude
cdr_CHL2=dim_avg_n_Wrap(cdr_chl2,0)

chl3=f3->chl(:,0,:,:)
chl3@lon2d=f3->longitude
chl3@lat2d=f3->latitude
CHL3=dim_avg_n_Wrap(chl3,0)

cdr_chl3=g3->chl(:,0,:,:)
cdr_chl3@lon2d=g3->longitude
cdr_chl3@lat2d=g3->latitude
cdr_CHL3=dim_avg_n_Wrap(cdr_chl3,0)

CHL1=CHL1*10^6
CHL2=CHL2*10^6
CHL3=CHL3*10^6
printMinMax(CHL1,0)
printMinMax(CHL2,0)
printMinMax(CHL3,0)
exit

cdr_CHL1=cdr_CHL1*10^6
cdr_CHL2=cdr_CHL2*10^6
cdr_CHL3=cdr_CHL3*10^6

diff1=cdr_CHL1-CHL1
copy_VarMeta(CHL1,diff1)
diff2=cdr_CHL2-CHL2
copy_VarMeta(CHL2,diff2)
diff3=cdr_CHL3-CHL3
copy_VarMeta(CHL3,diff3)

plot=new(6,graphic)
plot0=new(6,graphic)
plot1=new(3,graphic)
plot2=new(6,graphic)
wks  = gsn_open_wks("png",dir3+"CHL_map_diff_30_years_"+N)
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
res@cnMaxLevelValF         =      0.3
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =       0.02
res@cnFillPalette ="MPL_YlGnBu"
res@gsnCenterString="1pctCO2 (30 years)"
plot(0) = gsn_csm_contour_map(wks,CHL1,res)
res@gsnCenterString="1pctCO2_cdr (30 years)"
plot(1) = gsn_csm_contour_map(wks,cdr_CHL1,res)
res@gsnCenterString=""
plot(2) = gsn_csm_contour_map(wks,CHL2,res)
plot(3) = gsn_csm_contour_map(wks,cdr_CHL2,res)
plot(4) = gsn_csm_contour_map(wks,CHL3,res)
plot(5) = gsn_csm_contour_map(wks,cdr_CHL3,res)

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

plot0(0)=gsn_csm_contour(wks,CHL1,res0)
plot0(1)=gsn_csm_contour(wks,cdr_CHL1,res0)
plot0(2)=gsn_csm_contour(wks,CHL2,res0)
plot0(3)=gsn_csm_contour(wks,cdr_CHL2,res0)
plot0(4)=gsn_csm_contour(wks,CHL3,res0)
plot0(5)=gsn_csm_contour(wks,cdr_CHL3,res0)
 do d=0,5
  overlay(plot(d),plot0(d))
 end do

res2@cnMaxLevelValF         =      0.1
res2@cnMinLevelValF         =      -0.1
res2@cnLevelSpacingF        =       0.02
res2@cnFillPalette ="CBR_coldhot"
res2@gsnCenterString="Diff (1pctCO2_cdr - 1pctCO2)"
plot1(0)=gsn_csm_contour_map(wks,diff1,res2)
res2@gsnCenterString=""
plot1(1)=gsn_csm_contour_map(wks,diff2,res2)
plot1(2)=gsn_csm_contour_map(wks,diff3,res2)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelMainString=""
pres@gsnPanelBottom=0.05
pres@gsnPanelLeft=0.05
pres@gsnPanelRight=0.6
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 1
pres@pmLabelBarWidthF = 0.5 ; label bar width
pres@pmLabelBarOrthogonalPosF=0.005
pres@lbLabelFontHeightF=0.01
pres@pmLabelBarHeightF = 0.05
pres@lbTitleString="mg/m~S~3~N"
pres@lbTitleFontHeightF=0.012
pres@lbTitlePosition="Bottom"
gsn_panel(wks,plot,(/3,2/),pres)

pres2                       =   True
pres2@gsnFrame         = False
pres2@gsnPanelMainString=""
pres2@gsnPanelBottom=0.2
pres2@gsnPanelTop=0.83
pres2@gsnPanelLeft=0.6
pres2@gsnPanelRight=0.95
pres2@gsnPanelLabelBar      = True
pres2@gsnMaximize        =       False
pres2@gsnPanelYWhiteSpacePercent = 1
pres2@pmLabelBarWidthF = 0.3 ; label bar width
pres2@pmLabelBarOrthogonalPosF=0.005
pres2@lbLabelFontHeightF=0.01
pres2@pmLabelBarHeightF = 0.05
pres2@lbTitleString="mg/m~S~3~N"
pres2@lbTitleFontHeightF=0.012
pres2@lbTitlePosition="Bottom"
gsn_panel(wks,plot1,(/3,1/),pres2)

txres               = True
txres@txFontHeightF = 0.013
txres@txAngleF      = 90.
gsn_text_ndc(wks, m(4*N),  0.02, 0.73, txres)
gsn_text_ndc(wks, m(4*N+1),  0.025, 0.53, txres)
gsn_text_ndc(wks, m(4*N+2) , 0.025, 0.33, txres)

frame(wks)

end
