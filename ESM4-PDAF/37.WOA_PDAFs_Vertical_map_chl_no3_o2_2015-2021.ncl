begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"

f2=addfile(dir1+"woa18_all_n00_01.1x1.nc","r")
no3=f2->n_an(0,{0:650},{-2:2},:)
depth_woa=f2->depth({0:650})
no3=no3*(1027./10^6)
no3_1=dim_avg_n_Wrap(no3,1); depth x lon
no3_1 := no3_1(lon|:,depth|:)

f3=addfile(dir1+"woa18_all_o00_01.1x1.nc","r")
o2=f3->o_an(0,{0:650},{-2:2},:)
o2=o2*(1027./10^6)
o2_1=dim_avg_n_Wrap(o2,1) ; depth x lon
o2_1 := o2_1(lon|:,depth|:)

g2=addfile(dir2+"no3.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
z=g2->z_l({0:650})
lon=g2->lon
no3_oda0=g2->no3(:,{0:650},{-2:2},:)
no3_oda1=dim_avg_n_Wrap(no3_oda0,0)
no3_oda2=dim_avg_n_Wrap(no3_oda1,1)

g3=addfile(dir2+"o2.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
o2_oda0=g3->o2(:,{0:650},{-2:2},:)
o2_oda1=dim_avg_n_Wrap(o2_oda0,0)
o2_oda2=dim_avg_n_Wrap(o2_oda1,1)

;-----For depth interporation-------------
no3_2=int2p_n_Wrap(depth_woa,no3_1,z,-1,1)
o2_2=int2p_n_Wrap(depth_woa,o2_1,z,-1,1)

no3_2 := no3_2(z_l|:,lon|:)
o2_2 := o2_2(z_l|:,lon|:)
;--------------------------------------
;diff_no3_oda=no3_oda2-no3_2
;copy_VarCoords(no3_oda2,diff_no3_oda)
;diff_no3_aoda=no3_aoda2-no3_2
;copy_VarCoords(no3_aoda2,diff_no3_aoda)
;diff_o2_oda=o2_oda2-o2_2
;copy_VarCoords(o2_oda2,diff_o2_oda)
;diff_o2_aoda=o2_aoda2-o2_2
;copy_VarCoords(o2_aoda2,diff_o2_aoda)

plot=new(4,graphic)
wks=gsn_open_wks("pdf",dir0+"figure12_WOA_PDAFs_Vertical_map_no3_o2_2015-2021")
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
res@lbTitleString    = "~S~o~N~C"                ; title string
res@lbTitlePosition  = "Bottom"              ; title position
res@lbOrientation        = "vertical" ; vertical label bar
res@tmYLMode="Manual"
res@tmYLTickStartF=0
res@tmYLTickSpacingF=100
res@tmYLMinorPerMajor=1
res@gsnCenterStringFontHeightF=0.028
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
res@cnFillPalette          =       "cmp_b2r"
res@gsnCenterString        =   "(a) NO~B~3~N~ (WOA)"
res@gsnLeftString=""
res@gsnCenterStringFontHeightF=0.025
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      0.03
res@cnMinLevelValF         =      0.
res@cnLevelSpacingF        =       0.002
res@tiXAxisString =""
res@tiYAxisString =""
plot(0)=gsn_csm_contour(wks,no3_2,res)
res@gsnCenterString        =   "(b) NO~B~3~N~ (ESM4-PDAF)"
plot(1)=gsn_csm_contour(wks,no3_oda2,res)
res@gsnCenterString        =   "(c) O~B~2~N~ (WOA)"
res@cnMaxLevelValF         =      0.3
res@cnMinLevelValF         =      0.
res@cnLevelSpacingF        =       0.02
plot(2)=gsn_csm_contour(wks,o2_2,res)
res@gsnCenterString        =   "(d) O~B~2~N~ (ESM4-PDAF)"
plot(3)=gsn_csm_contour(wks,o2_oda2,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 1 
pres@gsnPanelMainString=""
pres@gsnPanelMainFontHeightF=0.023
pres@gsnPanelTop       = 0.9 
pres@gsnPanelBottom       = 0.05
pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/3,2/),pres)
txres1               = True
txres1@txFontHeightF = 0.014
txres1@txAngleF      = 90. 

txres2               = True
txres2@txFontHeightF = 0.010
txres2@txAngleF      = 0. 
gsn_text_ndc(wks, "(m)",0.105, 0.87, txres2)
gsn_text_ndc(wks, "(m)",0.105, 0.587, txres2)

gsn_text_ndc(wks, "(m)",0.56, 0.87, txres2)
gsn_text_ndc(wks, "(m)",0.56, 0.587, txres2)

gsn_text_ndc(wks, "mol / m~S~3~N~",0.48, 0.66, txres2)
gsn_text_ndc(wks, "mol / m~S~3~N~",0.48, 0.375, txres2)

gsn_text_ndc(wks, "mol / m~S~3~N~",0.935, 0.66, txres2)
gsn_text_ndc(wks, "mol / m~S~3~N~",0.935, 0.375, txres2)

frame(wks)

end
