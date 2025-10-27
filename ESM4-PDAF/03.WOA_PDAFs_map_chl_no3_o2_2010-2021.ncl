begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

f1=addfile(dir1+"CHL_201001-202112.nc","r")
chl_0=f1->chlor_a
chl=dim_avg_n_Wrap(chl_0,0)

f2=addfile(dir1+"woa18_all_n00_01.1x1.nc","r")
no3=f2->n_an(0,0,:,:)
no3=no3*(1027./10^6)

f3=addfile(dir1+"woa18_all_o00_01.1x1.nc","r")
o2_1=f3->o_an(0,{200:600},:,:)
o2=dim_avg_n_Wrap(o2_1,0)
o2=o2*(1027./10^6)

g1=addfile(dir2+"chl.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
chl_oda0=g1->chl(:,0,:,:)
chl_oda=dim_avg_n_Wrap(chl_oda0,0)
chl_oda=chl_oda*10^6

h1=addfile(dir3+"chl.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
chl_aoda0=h1->chl(:,0,:,:)
chl_aoda=dim_avg_n_Wrap(chl_aoda0,0)
chl_aoda=chl_aoda*10^6
nmsg = num(ismissing(chl_aoda)) 

g2=addfile(dir2+"no3.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
no3_oda0=g2->no3(:,0,:,:)
no3_oda=dim_avg_n_Wrap(no3_oda0,0)

h2=addfile(dir3+"no3.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
no3_aoda0=h2->no3(:,0,:,:)
no3_aoda=dim_avg_n_Wrap(no3_aoda0,0)

g3=addfile(dir2+"o2.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
o2_oda0=g3->o2(:,{200:600},:,:)
o2_oda1=dim_avg_n_Wrap(o2_oda0,0)
o2_oda=dim_avg_n_Wrap(o2_oda1,0)

h3=addfile(dir3+"o2.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
o2_aoda0=h3->o2(:,{200:600},:,:)
o2_aoda1=dim_avg_n_Wrap(o2_aoda0,0)
o2_aoda=dim_avg_n_Wrap(o2_aoda1,0)

;levs=(/0.01,,,,0.03,,,0.1,,,0.3,,,1,3,,,10,,,30,,,64/)
levs=(/0.01,0.015,0.02,0.025,0.03,0.0475,0.065,0.0825,0.1,0.15,0.20,0.4,0.6,0.8,1,1.5,2.0,2.5,3,4.75,6.5,8.25,10,15,20,25,30,38.5,47,55.5,64/)
LEVS=(/"0.01","","","","0.03","","","","0.1","","","","","","1","","","","3","","","","10","","","","30","","","","64"/)

plot=new(9,graphic)
wks=gsn_open_wks("png",dir0+"WOA_PDAFs_map_surface_chl_no3_o2_2010-2021")
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
res@cnFillPalette          =       "cmocean_algae"
res@gsnCenterString        =   "Chl"
res@gsnLeftString=""
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ExplicitLevels"
res@cnLevels         = levs
res@lbLabelStrings=LEVS
res@lbTitleString    = "mg / m~S~3~N~"                ; title string
plot(0)=gsn_csm_contour_map(wks,chl,res)
res@gsnCenterString        =   ""
plot(3)=gsn_csm_contour_map(wks,chl_oda,res)
plot(6)=gsn_csm_contour_map(wks,chl_aoda,res)
delete(res@cnLevels)
delete(res@lbLabelStrings)
delete(res@cnLevelSelectionMode)
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnFillPalette          =       "MPL_Reds"
res@lbTitleString    = "mol / m~S~3~N~"                ; title string
res@gsnCenterString        =   "NO~B~3~N~_surface"
res@cnMaxLevelValF         =      0.03 
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =       0.002
plot(1)=gsn_csm_contour_map(wks,no3,res)
res@gsnCenterString        =   ""
plot(4)=gsn_csm_contour_map(wks,no3_oda,res)
plot(7)=gsn_csm_contour_map(wks,no3_aoda,res)
res@mpLandFillColor    =   "black"
res@gsnCenterString     = "O~B~2~N~_200-600m_avg"                ; title string
res@lbTitleString    = "mol / m~S~3~N~"                ; title string
res@cnFillPalette          =       "cmp_b2r"
res@cnMaxLevelValF         =      0.3 
res@cnMinLevelValF         =      0
res@cnLevelSpacingF        =       0.02
plot(2)=gsn_csm_contour_map(wks,o2,res)
res@gsnCenterString        =   ""
plot(5)=gsn_csm_contour_map(wks,o2_oda,res)
plot(8)=gsn_csm_contour_map(wks,o2_aoda,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 5 
pres@gsnPanelMainString="BGC (2010-2021)"
pres@gsnPanelMainFontHeightF=0.023
pres@gsnPanelTop       = 0.9 
pres@gsnPanelBottom       = 0.05
pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/3,3/),pres)
txres1               = True
txres1@txFontHeightF = 0.014
txres1@txAngleF      = 90. 
gsn_text_ndc(wks, "OBS",0.03, 0.77, txres1)
gsn_text_ndc(wks, "ESM4-PDAF_ocean",0.03, 0.48, txres1)
gsn_text_ndc(wks, "ESM4-PDAF_coupled",0.03, 0.21, txres1)

frame(wks)

end
