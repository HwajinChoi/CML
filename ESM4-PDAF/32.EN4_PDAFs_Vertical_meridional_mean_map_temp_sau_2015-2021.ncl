load "./taylor_diagram_hj.ncl"
begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/EN4/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"
name=(/"ESM4-PDAF","ECDA","GODAS","ECCO","SODA"/)
colors=(/"red","gold","green","blue","purple"/)
Markers = (/ 4,  8,  0, 9, 12/) ; Marker Indices 

f=addfile(dir4+"weight_Taylor_stats_EN4_PDAFs_reanalysis_Meridional_mean_temp_sal_from_2015.nc","r")
sal_cc=f->sal_cc
temp_cc=f->temp_cc
sal_ratio=f->sal_ratio
temp_ratio=f->temp_ratio

sal_cc2=new(5,"double")
sal_cc2(0)=sal_cc(0)
sal_cc2(1:4)=sal_cc(2:5)

sal_ratio2=new(5,"double")
sal_ratio2(0)=sal_ratio(0)
sal_ratio2(1:4)=sal_ratio(2:5)

temp_cc2=new(5,"double")
temp_cc2(0)=temp_cc(0)
temp_cc2(1:4)=temp_cc(2:5)

temp_ratio2=new(5,"double")
temp_ratio2(0)=temp_ratio(0)
temp_ratio2(1:4)=temp_ratio(2:5)

TEMP_CC=conform_dims((/5,1/),temp_cc2,0)
TEMP_RATIO=conform_dims((/5,1/),temp_ratio2,0)

SAL_CC=conform_dims((/5,1/),sal_cc2,0)
SAL_RATIO=conform_dims((/5,1/),sal_ratio2,0)

f1=addfile(dir1+"EN.4.2.2.r360x180.temperature_201001-202112.nc","r")
en4_temp0=f1->temperature(:,{0:650},{-2:2},:)
depth_en4=f1->depth({0:650})

en4_temp0_15=f1->temperature(60:143,{0:650},{-2:2},:)

en4_temp1=dim_avg_n_Wrap(en4_temp0,2)
en4_temp2=dim_avg_n_Wrap(en4_temp1,0) ; depth x lon

en4_temp1_15=dim_avg_n_Wrap(en4_temp0_15,2)
en4_temp2_15=dim_avg_n_Wrap(en4_temp1_15,0) ; depth x lon

en4_temp2 := en4_temp2(lon|:,depth|:)
en4_temp2_15 := en4_temp2_15(lon|:,depth|:)

f2=addfile(dir1+"EN.4.2.2.r360x180.salinity_201001-202112.nc","r")
en4_sal0=f2->salinity(:,{0:650},{-2:2},:)
en4_sal0_15=f2->salinity(60:143,{0:650},{-2:2},:)

en4_sal1=dim_avg_n_Wrap(en4_sal0,2)
en4_sal2=dim_avg_n_Wrap(en4_sal1,0)

en4_sal1_15=dim_avg_n_Wrap(en4_sal0_15,2)
en4_sal2_15=dim_avg_n_Wrap(en4_sal1_15,0)

en4_sal2 := en4_sal2(lon|:,depth|:)
en4_sal2_15 := en4_sal2_15(lon|:,depth|:)

g1=addfile(dir2+"thetao.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
thetao_oda0=g1->thetao(:,{0:650},{-2:2},:)
z=g1->z_l({0:650})
lon=g1->lon
thetao_oda1=dim_avg_n_Wrap(thetao_oda0,2)
thetao_oda2=dim_avg_n_Wrap(thetao_oda1,0)

h1=addfile(dir3+"thetao.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
thetao_aoda0=h1->thetao(60:143,{0:650},{-2:2},:)
thetao_aoda1=dim_avg_n_Wrap(thetao_aoda0,2)
thetao_aoda2=dim_avg_n_Wrap(thetao_aoda1,0)

g2=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
so_oda0=g2->so(:,{0:650},{-2:2},:)
so_oda1=dim_avg_n_Wrap(so_oda0,2)
so_oda2=dim_avg_n_Wrap(so_oda1,0)

h2=addfile(dir3+"so.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
so_aoda0=h2->so(60:143,{0:650},{-2:2},:)
so_aoda1=dim_avg_n_Wrap(so_aoda0,2)
so_aoda2=dim_avg_n_Wrap(so_aoda1,0)
;-----For depth interporation-------------
en4_temp3=int2p_n_Wrap(depth_en4,en4_temp2,z,-1,1)
en4_temp3_15=int2p_n_Wrap(depth_en4,en4_temp2_15,z,-1,1)

en4_sal3=int2p_n_Wrap(depth_en4,en4_sal2,z,-1,1)
en4_sal3_15=int2p_n_Wrap(depth_en4,en4_sal2_15,z,-1,1)

en4_temp3 := en4_temp3(z_l|:,lon|:)
en4_temp3_15 := en4_temp3_15(z_l|:,lon|:)

en4_sal3 := en4_sal3(z_l|:,lon|:)
en4_sal3_15 := en4_sal3_15(z_l|:,lon|:)
;--------------------------------------
diff_thetao_oda=thetao_oda2-en4_temp3_15
copy_VarCoords(thetao_oda2,diff_thetao_oda)

diff_thetao_aoda=thetao_aoda2-en4_temp3_15
copy_VarCoords(thetao_aoda2,diff_thetao_aoda)

diff_so_oda=so_oda2-en4_sal3_15
copy_VarCoords(so_oda2,diff_so_oda)

diff_so_aoda=so_aoda2-en4_sal3_15
copy_VarCoords(so_aoda2,diff_so_aoda)

plot=new(6,graphic)
wks=gsn_open_wks("pdf",dir0+"figure6_EN4_PDAFs_Vertical_map_temp_sau_2015-2021")
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
res@lbTitleString    = ""                ; title string
res@lbTitlePosition  = "Bottom"              ; title position
res@lbOrientation        = "vertical" ; vertical label bar
res@tmYLMode="Manual"
res@tmYLTickStartF=0
res@tmYLTickSpacingF=100
res@tmYLMinorPerMajor=1
res@gsnCenterStringFontHeightF=0.025
res@lbTitleFontHeightF= 0.020     
res@sfXArray             = lon
res@sfYArray		 = z
res@gsnYAxisIrregular2Linear = True
res@trYReverse               = True   ; reverses y-axis
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       2   
res@tmYLLabelStride     =       2   
;res@gsnCenterStringOrthogonalPosF=0.1
;res@cnMaxLevelValF         =      0.4 
;res@cnMinLevelValF         =      -0.4
;res@cnLevelSpacingF        =       0.05
res@cnFillPalette          =       "MPL_jet"
res@gsnCenterString        =   "(a) Temp~B~eq~N~(EN4)"
res@gsnLeftString=""
res@gsnCenterStringFontHeightF=0.025
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      30. 
res@cnMinLevelValF         =      20.
res@cnLevelSpacingF        =       1.
res@tiXAxisString =""
res@tiYAxisString =""
plot(0)=gsn_csm_contour(wks,en4_temp3_15,res)
res@lbTitleString    = ""                ; title string
res@gsnCenterString        =   "(b) Salinity~B~eq~N~(EN4)"
res@cnMaxLevelValF         =      37.
res@cnMinLevelValF         =      34.5
res@cnLevelSpacingF        =       0.25
plot(1)=gsn_csm_contour(wks,en4_sal3_15,res)
res@cnFillPalette          =       "BlueDarkRed18"
res@lbTitleString    = ""                ; title string
res@gsnCenterString        =   ""
res@cnMaxLevelValF         =      3. 
res@cnMinLevelValF         =      -3.
res@cnLevelSpacingF        =       0.5
res@gsnCenterString        =   "(c)    Temp~B~eq~N~(ESM4-PDAF - EN4)"
plot(2)=gsn_csm_contour(wks,diff_thetao_oda,res)
res@lbTitleString    = "psu"                ; title string
res@cnMaxLevelValF         =      0.5 
res@cnMinLevelValF         =      -0.5
res@cnLevelSpacingF        =       0.1
res@gsnCenterString        =   "(d)    Salinity~B~eq~N~(ESM4-PDAF - EN4)"
plot(3)=gsn_csm_contour(wks,diff_so_oda,res)

ty_opt   = True                           ; taylor diagram with options
ty_opt@gsnFrame               =       False
ty_opt@gsnDraw                =       False
ty_opt@Markers       = Markers
ty_opt@Colors        = colors
ty_opt@varLabels     = ""
ty_opt@caseLabels    = name

ty_opt@varLabelsYloc = 1.5                ; Move location of variable labels [default 0.45]
ty_opt@caseLabelsFontHeightF = 0.2       ; make slight larger   [default=0.12 ]
ty_opt@varLabelsFontHeightF  = 0.015      ; make slight smaller  [default=0.013]
ty_opt@gsMarkerSizeF =  0.01
ty_opt@gsMarkerThicknessF=5.0

ty_opt@tiMainString  = "(e) Temp~B~eq~N~"           ; title
ty_opt@stnRad        = (/ 0.5, 1.5 /)     ; additional standard radii
ty_opt@ccRays        = (/ 0.6, 0.9 /)     ; correllation rays
ty_opt@centerDiffRMS = True               ; RMS 'circles'

plot(4)  = taylor_diagram(wks,TEMP_RATIO,TEMP_CC,ty_opt)
ty_opt@tiMainString  = "(f) Salinity~B~eq~N~"           ; title
plot(5)  = taylor_diagram(wks,SAL_RATIO,SAL_CC,ty_opt)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 1 
pres@gsnPanelMainString=""
pres@gsnPanelMainFontHeightF=0.023
pres@gsnPanelTop       = 0.9 
pres@gsnPanelBottom       = 0.15
pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/3,2/),pres)
txres1               = True
txres1@txFontHeightF = 0.012

txres2               = True
txres2@txFontHeightF = 0.010
gsn_text_ndc(wks, "(m)",0.157, 0.87, txres2)
gsn_text_ndc(wks, "(m)",0.157, 0.62, txres2)

gsn_text_ndc(wks, "(m)",0.555, 0.87, txres2)
gsn_text_ndc(wks, "(m)",0.555, 0.62, txres2)

gsn_text_ndc(wks, "~S~o~N~C",0.483, 0.68, txres2)
gsn_text_ndc(wks, "~S~o~N~C",0.483, 0.43, txres2)

gsn_text_ndc(wks, "psu",0.882, 0.68, txres2)
gsn_text_ndc(wks, "psu",0.882, 0.43, txres2)

frame(wks)

end
