begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

g1=addfile(dir2+"uo.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
uo_oda0=g1->uo(:,{0:200},{-2:2},{120:280})
z=g1->z_l({0:200})
lon=g1->lon({120:280})
uo_oda1=dim_avg_n_Wrap(uo_oda0,2)
uo_oda2=dim_avg_n_Wrap(uo_oda1,0)

h1=addfile(dir3+"uo.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
uo_aoda0=h1->uo(:,{0:200},{-2:2},{120:280})
uo_aoda1=dim_avg_n_Wrap(uo_aoda0,2)
uo_aoda2=dim_avg_n_Wrap(uo_aoda1,0)

f1=addfile(dir1+"ECDA/u_ATMassim_10NS_100err_WOA_0.1_2nd.201001-201712.nc","r")
u_ecda=f1->u(:,{0:200},{-2:2},{120:280})
z_ecda=f1->st_ocean({0:200})
u_ecda0=dim_avg_n_Wrap(u_ecda,2)
u_ecda1=dim_avg_n_Wrap(u_ecda0,0)

f2=addfile(dir1+"GODAS/ucur.r360x180.2010-2021.nc","r")
u_godas=f2->ucur(:,{0:200},{-2:2},{120:280})
z_godas=f2->level({0:200})
u_godas0=dim_avg_n_Wrap(u_godas,2)
u_godas1=dim_avg_n_Wrap(u_godas0,0)

f3=addfile(dir1+"ECCO/u_ECCO_r360x180_201001-201712.nc","r")
u_ecco=f3->EVEL(:,{-0:-200},{-2:2},{120:280})
Z=f3->Z({-0:-200})
Z := -Z
u_ecco&Z=Z
u_ecco0=dim_avg_n_Wrap(u_ecco,2)
u_ecco1=dim_avg_n_Wrap(u_ecco0,0)

f4=addfile(dir1+"SODA/u.soda3.15.2_r360x180_2010-2021.nc","r")
u_soda=f4->u(:,{0:200},{-2:2},{120:280})
z_soda=f4->st_ocean({0:200})
u_soda0=dim_avg_n_Wrap(u_soda,2)
u_soda1=dim_avg_n_Wrap(u_soda0,0)

plot=new(6,graphic)
wks=gsn_open_wks("png",dir0+"PDAFs_ECDA_GODAS_ECCO_SODA_equatorial_undercurr_2010-2021")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn              =       False
res@cnLineLabelsOn         =       False
res@lbLabelBarOn           = True
res@lbLabelFontHeightF  = 0.018
res@lbLabelStride     =   2   
;res@pmLabelBarWidthF=0.6
;res@pmLabelBarHeightF=0.5
res@lbTitleOn        =  False                ; turn on title
res@vpHeightF          = 0.4               ; change aspect ratio of plot
res@vpWidthF           = 0.6
res@lbTitleString    = "m/s"                ; title string
res@lbTitlePosition  = "Bottom"              ; title position
res@lbOrientation        = "vertical" ; vertical label bar
res@tmYLMode="Manual"
res@tmYLTickStartF=0
res@tmYLTickSpacingF=20
res@tmYLMinorPerMajor=1
res@lbTitleFontHeightF= 0.020     
res@sfXArray             = lon
res@sfYArray		 = z
res@gsnYAxisIrregular2Linear = True
res@trYReverse               = True   ; reverses y-axis
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
;res@tmXBMode="Manual"
;res@tmXBTickStartF=120
;res@tmXBTickSpacingF=60
;res@tmXBMinorPerMajor=2
res@tmXBMode="Explicit"
;res@tmXBValues =(/120,140,160,180,200,220,240,260,280/)
;res@tmXBLabels =(/"120E","140E","160E","180","160W","140W","120W","100W","80W"/)

res@tmXBValues =(/120,180,240/)
res@tmXBLabels =(/"120E","180","120W"/)

;res@tmXBLabelStride     =       0   
res@tmYLLabelStride     =       2   
res@gsnCenterStringOrthogonalPosF=0.05
res@cnFillPalette          =       "cmp_b2r"
res@gsnCenterString        =   "ESM4-PDAF_ocean"
res@gsnLeftString=""
res@gsnCenterStringFontHeightF=0.03
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      0.7 
res@cnMinLevelValF         =      -0.7
res@cnLevelSpacingF        =       0.1
res@tiXAxisString =""
res@tiYAxisString =""
plot(0)=gsn_csm_contour(wks,uo_oda2,res)
res@gsnCenterString        =   "ESM4-PDAF_coupled"
plot(1)=gsn_csm_contour(wks,uo_aoda2,res)
delete(res@sfYArray)
res@sfYArray             =z_ecda
res@gsnCenterString        =   "ECDA"
plot(2)=gsn_csm_contour(wks,u_ecda1,res)
delete(res@sfYArray)
res@sfYArray             =z_godas
res@gsnCenterString        =   "GODAS"
plot(3)=gsn_csm_contour(wks,u_godas1,res)
delete(res@sfYArray)
res@sfYArray             = Z
res@gsnCenterString        =   "ECCO"
plot(4)=gsn_csm_contour(wks,u_ecco1,res)
delete(res@sfYArray)
res@sfYArray             = z_soda
res@gsnCenterString        =   "SODA"
plot(5)=gsn_csm_contour(wks,u_soda1,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 1 
pres@gsnPanelMainString="Equatorial undercurrent (2010-2021)"
pres@gsnPanelMainFontHeightF=0.023
;pres@gsnPanelTop       = 0.9 
;pres@gsnPanelBottom       = 0.05
;pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/2,3/),pres)
;txres1               = True
;txres1@txFontHeightF = 0.014
;txres1@txAngleF      = 90. 
;gsn_text_ndc(wks, "EN4",0.055, 0.77, txres1)
;gsn_text_ndc(wks, "ESM4-PDAF_ocean",0.055, 0.48, txres1)
;gsn_text_ndc(wks, "ESM4-PDAF_coupled",0.055, 0.20, txres1)
;
txres2               = True
txres2@txFontHeightF = 0.010
txres2@txAngleF      = 0. 
gsn_text_ndc(wks, "(m)",0.027, 0.67, txres2)
gsn_text_ndc(wks, "(m)",0.027, 0.455, txres2)

gsn_text_ndc(wks, "(m)",0.36, 0.67, txres2)
gsn_text_ndc(wks, "(m)",0.36, 0.455, txres2)

gsn_text_ndc(wks, "(m)",0.695, 0.67, txres2)
gsn_text_ndc(wks, "(m)",0.695, 0.455, txres2)
;
gsn_text_ndc(wks, "m/s",0.3, 0.495, txres2)
gsn_text_ndc(wks, "m/s",0.635, 0.495, txres2)
gsn_text_ndc(wks, "m/s",0.965, 0.495, txres2)

gsn_text_ndc(wks, "m/s",0.3, 0.28, txres2)
gsn_text_ndc(wks, "m/s",0.635, 0.28, txres2)
gsn_text_ndc(wks, "m/s",0.965, 0.28, txres2)

frame(wks)

end
