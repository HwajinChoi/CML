begin
N=0

m=(/"ACCESS-ESM1-5","CanESM5","CESM2","CNRM-ESM2-1","MIROC-ES2L","NorESM2-LM","UKESM1-0-LL","GFDL-ESM4"/)
dir1="/media/cmlws/Data1/hjc/CDR/data/1pctCO2/chl_30/surf/"
dir2="/media/cmlws/Data1/hjc/CDR/data/1pctCO2_cdr/chl_30/surf/"
dir3="/media/cmlws/Data1/hjc/CDR/image/"
dir4="/media/cmlws/Data1/hjc/CDR/data/chl_peak_30/surf/"

file1=systemfunc("ls "+dir1+"chl_Omon_"+m(4*N)+"*.nc")
file2=systemfunc("ls "+dir1+"chl_Omon_"+m(4*N+1)+"*.nc")
file3=systemfunc("ls "+dir1+"chl_Omon_"+m(4*N+2)+"*.nc")
file4=systemfunc("ls "+dir1+"chl_Omon_"+m(4*N+3)+"*.nc")

gfile1=systemfunc("ls "+dir2+"chl_Omon_"+m(4*N)+"*.nc")
gfile2=systemfunc("ls "+dir2+"chl_Omon_"+m(4*N+1)+"*.nc")
gfile3=systemfunc("ls "+dir2+"chl_Omon_"+m(4*N+2)+"*.nc")
gfile4=systemfunc("ls "+dir2+"chl_Omon_"+m(4*N+3)+"*.nc")

hfile1=systemfunc("ls "+dir4+"chl_Omon_"+m(4*N)+"*.nc")
hfile2=systemfunc("ls "+dir4+"chl_Omon_"+m(4*N+1)+"*.nc")
hfile3=systemfunc("ls "+dir4+"chl_Omon_"+m(4*N+2)+"*.nc")
hfile4=systemfunc("ls "+dir4+"chl_Omon_"+m(4*N+3)+"*.nc")

;CNRM unit problem

f1=addfile(file1,"r")
f2=addfile(file2,"r")
f3=addfile(file3,"r")
f4=addfile(file4,"r")

g1=addfile(gfile1,"r")
g2=addfile(gfile2,"r")
g3=addfile(gfile3,"r")
g4=addfile(gfile4,"r")

h1=addfile(hfile1,"r")
h2=addfile(hfile2,"r")
h3=addfile(hfile3,"r")
h4=addfile(hfile4,"r")

chl1=f1->chl(:,0,:,:)
chl1@lon2d=f1->longitude
chl1@lat2d=f1->latitude
CHL1=dim_avg_n_Wrap(chl1,0)

cdr_chl1=g1->chl(:,0,:,:)
cdr_chl1@lon2d=g1->longitude
cdr_chl1@lat2d=g1->latitude
cdr_CHL1=dim_avg_n_Wrap(cdr_chl1,0)

peak_chl1=h1->chl(:,0,:,:)
peak_chl1@lon2d=h1->longitude
peak_chl1@lat2d=h1->latitude
peak_CHL1=dim_avg_n_Wrap(peak_chl1,0)

chl2=f2->chl(:,0,:,:)
chl2@lon2d=f2->longitude
chl2@lat2d=f2->latitude
CHL2=dim_avg_n_Wrap(chl2,0)

cdr_chl2=g2->chl(:,0,:,:)
cdr_chl2@lon2d=g2->longitude
cdr_chl2@lat2d=g2->latitude
cdr_CHL2=dim_avg_n_Wrap(cdr_chl2,0)

peak_chl2=h2->chl(:,0,:,:)
peak_chl2@lon2d=h2->longitude
peak_chl2@lat2d=h2->latitude
peak_CHL2=dim_avg_n_Wrap(peak_chl2,0)

chl3=f3->chl(:,0,:,:)
CHL3=dim_avg_n_Wrap(chl3,0)

cdr_chl3=g3->chl(:,0,:,:)
cdr_CHL3=dim_avg_n_Wrap(cdr_chl3,0)

peak_chl3=h3->chl(:,0,:,:)
peak_CHL3=dim_avg_n_Wrap(peak_chl3,0)

chl4=f4->chl(:,0,:,:)
chl4@lon2d=f4->lon
chl4@lat2d=f4->lat
CHL4=dim_avg_n_Wrap(chl4,0)

cdr_chl4=g4->chl(:,0,:,:)
cdr_chl4@lon2d=g4->lon
cdr_chl4@lat2d=g4->lat
cdr_CHL4=dim_avg_n_Wrap(cdr_chl4,0)

peak_chl4=h4->chl(:,0,:,:)
peak_chl4@lon2d=h4->lon
peak_chl4@lat2d=h4->lat
peak_CHL4=dim_avg_n_Wrap(peak_chl4,0)

CHL1=CHL1*10^6
CHL2=CHL2*10^6
CHL3=CHL3*10^6
CHL4=CHL4*10^3

cdr_CHL1=cdr_CHL1*10^6
cdr_CHL2=cdr_CHL2*10^6
cdr_CHL3=cdr_CHL3*10^6
cdr_CHL4=cdr_CHL4*10^3

peak_CHL1=peak_CHL1*10^6
peak_CHL2=peak_CHL2*10^6
peak_CHL3=peak_CHL3*10^6
peak_CHL4=peak_CHL4*10^3

diff1=cdr_CHL1-CHL1
copy_VarMeta(CHL1,diff1)
diff2=cdr_CHL2-CHL2
copy_VarMeta(CHL2,diff2)
diff3=cdr_CHL3-CHL3
copy_VarMeta(CHL3,diff3)
diff4=cdr_CHL4-CHL4
copy_VarMeta(CHL4,diff4)

peak_diff1=peak_CHL1-CHL1
copy_VarMeta(CHL1,peak_diff1)
peak_diff2=peak_CHL2-CHL2
copy_VarMeta(CHL2,peak_diff2)
peak_diff3=peak_CHL3-CHL3
copy_VarMeta(CHL3,peak_diff3)
peak_diff4=peak_CHL4-CHL4
copy_VarMeta(CHL4,peak_diff4)

peak_cdr_diff1=peak_CHL1-cdr_CHL1
copy_VarMeta(CHL1,peak_cdr_diff1)
peak_cdr_diff2=peak_CHL2-cdr_CHL2
copy_VarMeta(CHL2,peak_cdr_diff2)
peak_cdr_diff3=peak_CHL3-cdr_CHL3
copy_VarMeta(CHL3,peak_cdr_diff3)
peak_cdr_diff4=peak_CHL4-cdr_CHL4
copy_VarMeta(CHL4,peak_cdr_diff4)

plot=new(12,graphic)
plot0=new(12,graphic)
plot1=new(12,graphic)
wks  = gsn_open_wks("png",dir3+"CHL_map_PEAK_diff_30_years_"+N)
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
res@gsnCenterString="Peak (30 years)"
plot(1) = gsn_csm_contour_map(wks,peak_CHL1,res)
res@gsnCenterString="1pctCO2_cdr (30 years)"
plot(2) = gsn_csm_contour_map(wks,cdr_CHL1,res)
res@gsnCenterString=""
plot(3) = gsn_csm_contour_map(wks,CHL2,res)
plot(4) = gsn_csm_contour_map(wks,peak_CHL2,res)
plot(5) = gsn_csm_contour_map(wks,cdr_CHL2,res)
plot(6) = gsn_csm_contour_map(wks,CHL3,res)
plot(7) = gsn_csm_contour_map(wks,peak_CHL3,res)
plot(8) = gsn_csm_contour_map(wks,cdr_CHL3,res)
plot(9) = gsn_csm_contour_map(wks,CHL4,res)
plot(10) = gsn_csm_contour_map(wks,peak_CHL4,res)
plot(11) = gsn_csm_contour_map(wks,cdr_CHL4,res)

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
plot0(1)=gsn_csm_contour(wks,peak_CHL1,res0)
plot0(2)=gsn_csm_contour(wks,cdr_CHL1,res0)
plot0(3)=gsn_csm_contour(wks,CHL2,res0)
plot0(4)=gsn_csm_contour(wks,peak_CHL2,res0)
plot0(5)=gsn_csm_contour(wks,cdr_CHL2,res0)
plot0(6)=gsn_csm_contour(wks,CHL3,res0)
plot0(7)=gsn_csm_contour(wks,peak_CHL3,res0)
plot0(8)=gsn_csm_contour(wks,cdr_CHL3,res0)
plot0(9)=gsn_csm_contour(wks,CHL4,res0)
plot0(10)=gsn_csm_contour(wks,peak_CHL4,res0)
plot0(11)=gsn_csm_contour(wks,cdr_CHL4,res0)
 do d=0,11
  overlay(plot(d),plot0(d))
 end do

res2@cnMaxLevelValF         =      0.1
res2@cnMinLevelValF         =      -0.1
res2@cnLevelSpacingF        =       0.02
res2@cnFillPalette ="CBR_coldhot"
res2@gsnCenterString="Diff (Peak - 1pctCO2)"
plot1(0)=gsn_csm_contour_map(wks,peak_diff1,res2)
res2@gsnCenterString="Diff (Peak - 1pctCO2_cdr)"
plot1(1)=gsn_csm_contour_map(wks,peak_cdr_diff1,res2)
res2@gsnCenterString="Diff (1pctCO2_cdr - 1pctCO2)"
plot1(2)=gsn_csm_contour_map(wks,diff1,res2)
res2@gsnCenterString=""
plot1(3)=gsn_csm_contour_map(wks,peak_diff2,res2)
plot1(4)=gsn_csm_contour_map(wks,peak_cdr_diff2,res2)
plot1(5)=gsn_csm_contour_map(wks,diff2,res2)
plot1(6)=gsn_csm_contour_map(wks,peak_diff3,res2)
plot1(7)=gsn_csm_contour_map(wks,peak_cdr_diff3,res2)
plot1(8)=gsn_csm_contour_map(wks,diff3,res2)
plot1(9)=gsn_csm_contour_map(wks,peak_diff4,res2)
plot1(10)=gsn_csm_contour_map(wks,peak_cdr_diff4,res2)
plot1(11)=gsn_csm_contour_map(wks,diff4,res2)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelMainString=""
pres@gsnPanelBottom=0.05
pres@gsnPanelLeft=0.05
pres@gsnPanelRight=0.5
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 1
pres@pmLabelBarWidthF = 0.45 ; label bar width
pres@pmLabelBarOrthogonalPosF=0.005
pres@lbLabelFontHeightF=0.01
pres@pmLabelBarHeightF = 0.05
pres@lbTitleString="mg/m~S~3~N"
pres@lbTitleFontHeightF=0.012
pres@lbTitlePosition="Bottom"
gsn_panel(wks,plot,(/4,3/),pres)

pres2                       =   True
pres2@gsnFrame         = False
pres2@gsnPanelMainString=""
pres2@gsnPanelBottom=0.12
pres2@gsnPanelTop=0.93
pres2@gsnPanelLeft=0.5
pres2@gsnPanelRight=0.95
pres2@gsnPanelLabelBar      = True
pres2@gsnMaximize        =       False
pres2@gsnPanelYWhiteSpacePercent = 1
pres2@pmLabelBarWidthF = 0.45 ; label bar width
pres2@pmLabelBarOrthogonalPosF=0.005
pres2@lbLabelFontHeightF=0.01
pres2@pmLabelBarHeightF = 0.05
pres2@lbTitleString="mg/m~S~3~N"
pres2@lbTitleFontHeightF=0.012
pres2@lbTitlePosition="Bottom"
gsn_panel(wks,plot1,(/4,3/),pres2)

txres               = True
txres@txFontHeightF = 0.009
txres@txAngleF      = 90.
gsn_text_ndc(wks, m(4*N),  0.025, 0.68, txres)
gsn_text_ndc(wks, m(4*N+1),  0.025, 0.58, txres)
gsn_text_ndc(wks, m(4*N+2) , 0.025, 0.48, txres)
gsn_text_ndc(wks, m(4*N+3) , 0.025, 0.37, txres)

frame(wks)

end
