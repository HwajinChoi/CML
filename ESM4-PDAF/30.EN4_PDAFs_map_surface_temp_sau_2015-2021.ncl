load "./taylor_diagram_hj.ncl"
begin

dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/EN4/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"
;name=(/"ESM4-PDAF_ocean","ESM4-PDAF_coupled","ECDA","GODAS","ECCO","SODA"/)
name=(/"ESM4-PDAF","ECDA","GODAS","ECCO","SODA"/)
colors=(/"red","gold","green","blue","purple"/)
Markers = (/ 4,  8,  0, 9, 12/) ; Marker Indices 

f=addfile(dir4+"Taylor_stats_EN4_PDAFs_reanalysis_SURFACE_temp_sal_from_2015.nc","r")
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
en4_temp0=f1->temperature(:,0,:,:)
en4_temp0_15=f1->temperature(60:143,0,:,:)

en4_temp=dim_avg_n_Wrap(en4_temp0,0)
en4_temp_15=dim_avg_n_Wrap(en4_temp0_15,0)

f2=addfile(dir1+"EN.4.2.2.r360x180.salinity_201001-202112.nc","r")
en4_sal0=f2->salinity(:,0,:,:)
en4_sal0_15=f2->salinity(60:143,0,:,:)

en4_sal=dim_avg_n_Wrap(en4_sal0,0)
en4_sal_15=dim_avg_n_Wrap(en4_sal0_15,0)

g1=addfile(dir2+"tos.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
tos_oda0=g1->tos
tos_oda=dim_avg_n_Wrap(tos_oda0,0)
diff_tos_oda=tos_oda-en4_temp_15
copy_VarCoords(tos_oda,diff_tos_oda)

h1=addfile(dir3+"tos.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
tos_aoda0=h1->tos(60:143,:,:)
tos_aoda=dim_avg_n_Wrap(tos_aoda0,0)
diff_tos_aoda=tos_aoda-en4_temp_15
copy_VarCoords(tos_aoda,diff_tos_aoda)

g2=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
so_oda0=g2->so(:,0,:,:)
so_oda=dim_avg_n_Wrap(so_oda0,0)
diff_so_oda=so_oda-en4_sal_15
copy_VarCoords(so_oda,diff_so_oda)

h2=addfile(dir3+"so.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
so_aoda0=h2->so(60:143,0,:,:)
so_aoda=dim_avg_n_Wrap(so_aoda0,0)
diff_so_aoda=so_aoda-en4_sal_15
copy_VarCoords(so_aoda,diff_so_aoda)

plot=new(6,graphic)
wks=gsn_open_wks("pdf",dir0+"figure4_EN4_PDAFs_map_surface_temp_sau_2015-2021")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn              =       False
res@cnLineLabelsOn         =       False
;----ROBINSION------
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@gsnCenterStringFontHeightF= 0.025
;-------------------------------------------------
res@lbLabelBarOn           = True
res@lbLabelFontHeightF  = 0.018
res@lbLabelStride     =   2   
;res@pmLabelBarWidthF=0.6
;res@pmLabelBarHeightF=0.05
res@lbTitleOn        =  True                ; turn on title
res@lbTitleString    = ""                ; title string
res@lbTitlePosition  = "Bottom"              ; title position
res@lbTitleFontHeightF= 0.020     
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       2   
res@tmYLLabelStride     =       2   
res@mpCenterLonF       =       180 
;res@gsnCenterStringOrthogonalPosF=0.1
res@mpLandFillColor    =   "black"
;res@cnMaxLevelValF         =      0.4 
;res@cnMinLevelValF         =      -0.4
;res@cnLevelSpacingF        =       0.05
res@cnFillPalette          =       "cmp_b2r"
res@gsnCenterString        =   "(a) Temp~B~sfc~N~(EN4)"
res@gsnLeftString=""
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      30 
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =       2.
plot(0)=gsn_csm_contour_map(wks,en4_temp_15,res)
;res@lbTitleString    = "psu"                ; title string
res@gsnCenterString        =   "(b) Salinity~B~sfc~N~(EN4)"
res@cnMaxLevelValF         =      38 
res@cnMinLevelValF         =      30
res@cnLevelSpacingF        =       0.5
plot(1)=gsn_csm_contour_map(wks,en4_sal_15,res)
;res@lbTitleString    = "~S~o~N~C"                ; title string
res@gsnCenterString        =   "(c)    Temp~B~sfc~N~(ESM4-PDAF - EN4)"
res@cnFillPalette          =       "temp_19lev"
res@cnMaxLevelValF         =      3 
res@cnMinLevelValF         =      -3
res@cnLevelSpacingF        =       0.5
plot(2)=gsn_csm_contour_map(wks,diff_tos_oda,res)
res@gsnCenterString        =   "(d)    Salinity~B~sfc~N~(ESM4-PDAF - EN4)"
;res@lbTitleString    = "psu"                ; title string
res@cnMaxLevelValF         =      3 
res@cnMinLevelValF         =      -3
res@cnLevelSpacingF        =       0.5
plot(3)=gsn_csm_contour_map(wks,diff_so_oda,res)

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

ty_opt@tiMainString  = "(e) Temp~B~sfc~N~"           ; title
ty_opt@stnRad        = (/ 0.5, 1.5 /)     ; additional standard radii
ty_opt@ccRays        = (/ 0.6, 0.9 /)     ; correllation rays
ty_opt@centerDiffRMS = True               ; RMS 'circles'

plot(4)  = taylor_diagram(wks,TEMP_RATIO,TEMP_CC,ty_opt)
ty_opt@tiMainString  = "(f) Salinity~B~sfc~N~"           ; title
plot(5)  = taylor_diagram(wks,SAL_RATIO,SAL_CC,ty_opt)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 5 
pres@gsnPanelMainString=""
pres@gsnPanelMainFontHeightF=0.023
pres@gsnPanelTop       = 0.9 
pres@gsnPanelBottom       = 0.15
pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/3,2/),pres)
txres1               = True
txres1@txFontHeightF = 0.012
gsn_text_ndc(wks, "~S~o~N~C",0.52, 0.69, txres1)
gsn_text_ndc(wks, "psu",0.83, 0.69, txres1)
gsn_text_ndc(wks, "~S~o~N~C",0.52, 0.44, txres1)
gsn_text_ndc(wks, "psu",0.83, 0.44, txres1)

frame(wks)

end
