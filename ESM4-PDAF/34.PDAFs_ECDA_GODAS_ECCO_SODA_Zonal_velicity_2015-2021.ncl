begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

g1=addfile(dir2+"uo.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
uo_oda0=g1->uo(:,{0:300},{-2:2},{120:280})
z=g1->z_l({0:300})
lon=g1->lon
uo_oda1=dim_avg_n_Wrap(uo_oda0,2)
uo_oda2=dim_avg_n_Wrap(uo_oda1,0)
uo_oda3=dim_avg_n_Wrap(uo_oda2,1)

f1=addfile(dir1+"ECDA/u_ATMassim_10NS_100err_WOA_0.1_2nd.201001-201712.nc","r")
u_ecda=f1->u(60:95,{0:300},{-2:2},{120:280})
z_ecda=f1->st_ocean({0:300})
u_ecda0=dim_avg_n_Wrap(u_ecda,2)
u_ecda1=dim_avg_n_Wrap(u_ecda0,0)
u_ecda2=dim_avg_n_Wrap(u_ecda1,1)

f2=addfile(dir1+"GODAS/ucur.r360x180.2010-2021.nc","r")
u_godas=f2->ucur(60::,{0:300},{-2:2},{120:280})
z_godas=f2->level({0:300})
u_godas0=dim_avg_n_Wrap(u_godas,2)
u_godas1=dim_avg_n_Wrap(u_godas0,0)
u_godas2=dim_avg_n_Wrap(u_godas1,1)

f3=addfile(dir1+"ECCO/u_ECCO_r360x180_201001-201712.nc","r")
u_ecco=f3->EVEL(60::,{-0:-300},{-2:2},{120:280})
Z=f3->Z({-0:-300})
Z := -Z
u_ecco&Z=Z
u_ecco0=dim_avg_n_Wrap(u_ecco,2)
u_ecco1=dim_avg_n_Wrap(u_ecco0,0)
u_ecco2=dim_avg_n_Wrap(u_ecco1,1)

f4=addfile(dir1+"SODA/u.soda3.15.2_r360x180_2010-2021.nc","r")
u_soda=f4->u(60::,{0:300},{-2:2},{120:280})
z_soda=f4->st_ocean({0:300})
u_soda0=dim_avg_n_Wrap(u_soda,2)
u_soda1=dim_avg_n_Wrap(u_soda0,0)
u_soda2=dim_avg_n_Wrap(u_soda1,1)
colors=(/"red","gold","green","blue","purple"/)
name=(/"ESM4-PDAF","ECDA","GODAS","ECCO","SODA"/)

plot=new(5,graphic)
wks=gsn_open_wks("png",dir0+"figure8_PDAF_ECDA_GODAS_ECCO_SODA_Zonal_velicity_2010-2021")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@pmLabelBarWidthF=0.6
;res@pmLabelBarHeightF=0.5
;res@vpHeightF          = 0.4               ; change aspect ratio of plot
;res@vpWidthF           = 0.6
res@tmYLMode="Manual"
res@tmYLTickStartF=0
res@tmYLTickSpacingF=50
res@tmYLMinorPerMajor=3
;res@gsnYAxisIrregular2Linear = True
res@trYReverse               = True   ; reverses y-axis
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
;res@tmXBLabelStride     =       2   
;res@tmYLLabelStride     =       2   
res@trXMinF                  = -0.4
res@trXMaxF                  =0.4
res@tiMainString="Equatorial undercurrent"
res@gsnXRefLine=0
res@gsnXRefLineDashPattern=0
res@gsnXRefLineThicknessF=2
res@gsnXRefLineColor=(/"black"/)
res@gsnLeftString=""
res@gsnRightString=""
res@tiXAxisString ="Zonal velocity (m/s)"
res@tiYAxisString ="Depth (m)"
res@xyLineThicknessF    = 8.0
res@xyDashPattern=0
res@xyLineColor         = colors(0) 
plot(0)=gsn_csm_xy(wks,uo_oda3,z,res)
res@tiMainString=""
res@xyLineColor         = colors(1) 
plot(1)=gsn_csm_xy(wks,u_ecda2,z_ecda,res)
res@xyLineColor         = colors(2) 
plot(2)=gsn_csm_xy(wks,u_godas2,z_godas,res)
res@xyLineColor         = colors(3) 
plot(3)=gsn_csm_xy(wks,u_ecco2,Z,res)
res@xyLineColor         = colors(4) 
plot(4)=gsn_csm_xy(wks,u_soda2,z_soda,res)

gres = True
gres@YPosPercent = 94    ; expressed as %, 0->100, sets position of top border of legend 
gres@XPosPercent = 5      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
gres@ItemSpacePercent = 5.
lineres = True
lineres@lgLineColors = colors 
lineres@lgLineThicknesses = 5                        ; line thicknesses
lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
textres = True
;textres@lgLabelFontHeights = (/0.015,0.015,0.015,0.015/)                           ; label font heights
textres@lgLabels = name 
plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

overlay(plot(0),plot(1))
overlay(plot(0),plot(2))
overlay(plot(0),plot(3))
overlay(plot(0),plot(4))

draw(plot(0))
frame(wks)

end
