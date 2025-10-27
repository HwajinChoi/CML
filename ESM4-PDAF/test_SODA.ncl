begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/EN4/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir5="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"

f2=addfile(dir1+"EN.4.2.2.r360x180.salinity_201001-202112.nc","r")
en4_sal0=f2->salinity(:,{0:650},:,{150:240})

en4_sal1=dim_avg_n_Wrap(en4_sal0,3)
en4_sal2=dim_avg_n_Wrap(en4_sal1,0)

;en4_sal2 := en4_sal2(lat|:,depth|:)
;------------------------------------------------------------------------
h2=addfile(dir3+"so.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
so_aoda0=h2->so(:,{0:650},:,{150:240})
so_aoda1=dim_avg_n_Wrap(so_aoda0,3)
so_aoda2=dim_avg_n_Wrap(so_aoda1,0)

s2=addfile(dir4+"ECDA/salt_ATMassim_10NS_100err_WOA_0.1_2nd.201001-201712.nc","r")
so_ecda0=s2->salt(:,{0:650},:,{150:240})
so_ecda1=dim_avg_n_Wrap(so_ecda0,3)
so_ecda2=dim_avg_n_Wrap(so_ecda1,0)
st_ocean=s2->st_ocean
;so_ecda2 := so_ecda2(yt_ocean|:,st_ocean|:)

k2=addfile(dir4+"GODAS/salt.2010-2021.nc","r")
so_godas0=k2->salt(:,{0:650},:,{150:240})
so_godas1=dim_avg_n_Wrap(so_godas0,3)
so_godas2=dim_avg_n_Wrap(so_godas1,0)
lat_godas=k2->lat
so_godas2=so_godas2*1000
z=k2->level
;so_godas2 := so_godas2(lat|:,level|:)

d2=addfile(dir4+"ECCO/SALT_ECCO_r360x180_201001-201712.nc","r")
so_ecco0=d2->SALT(:,{0:-650},:,{150:240})
so_ecco1=dim_avg_n_Wrap(so_ecco0,3)
so_ecco2=dim_avg_n_Wrap(so_ecco1,0)
Z=d2->Z
;so_ecco2 := so_ecco2(lat|:,Z|:)

b2=addfile(dir4+"SODA/salt.soda3.15.2_r360x180_2010-2021.nc","r")
so_soda0=b2->salt(:,{0:650},:,{150:240})
so_soda1=dim_avg_n_Wrap(so_soda0,3)
so_soda2=dim_avg_n_Wrap(so_soda1,0)
;so_soda2 := so_soda2(lat|:,st_ocean|:)
st_ocean=b2->st_ocean

;printVarSummary()
plot=new(6,graphic)
wks=gsn_open_wks("png","./test_soda_sal")
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
res@gsnCenterStringFontHeightF=0.025
res@lbTitleFontHeightF= 0.020
res@sfXArray             = lat_godas
res@sfYArray             = z
res@gsnYAxisIrregular2Linear = True
res@trYReverse               = True   ; reverses y-axis
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       1
res@tmYLLabelStride     =       2
;res@gsnCenterStringOrthogonalPosF=0.1
;res@cnMaxLevelValF         =      0.4 
;res@cnMinLevelValF         =      -0.4
;res@cnLevelSpacingF        =       0.05
res@cnFillPalette          =       "MPL_jet"
res@gsnCenterString        =   "GODAS"
res@gsnLeftString=""
res@gsnCenterStringFontHeightF=0.025
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      36.
res@cnMinLevelValF         =      33.
res@cnLevelSpacingF        =       0.2
res@tiXAxisString =""
res@tiXAxisString =""
res@tiYAxisString =""
plot(0)=gsn_csm_contour(wks,so_godas2,res)
delete(res@sfYArray)
res@sfYArray             = st_ocean
res@lbTitleString    = "psu"                ; title string
res@gsnCenterString        =   "SODA"
;res@cnMaxLevelValF         =      36.
;res@cnMinLevelValF         =      33.
;res@cnLevelSpacingF        =       0.2
plot(1)=gsn_csm_contour(wks,so_soda2,res)
delete(res@sfYArray)
res@sfYArray             = st_ocean
res@gsnCenterString        =   "ECDA"
plot(2)=gsn_csm_contour(wks,so_ecda2,res)
delete(res@sfYArray)
res@gsnCenterString        =   "ECCO"
res@sfYArray             = Z
plot(3)=gsn_csm_contour(wks,so_ecco2,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 1
pres@gsnPanelMainString="Test"
pres@gsnPanelMainFontHeightF=0.023
pres@gsnPanelTop       = 0.9
pres@gsnPanelBottom       = 0.05
pres@gsnPanelLeft=0.05

gsn_panel(wks,plot,(/2,2/),pres)
frame(wks)

;-----For depth interporation-------------
;en4_sal3=int2p_n_Wrap(depth_en4,en4_sal2,z,-1,1)
;en4_sal3 := en4_sal3(z_l|:,lat|:)
;so_ecda3=int2p_n_Wrap(depth_ecda,so_ecda2,z,-1,1)
;so_godas3=int2p_n_Wrap(depth_godas,so_godas2,z,-1,1)
;so_ecco3=int2p_n_Wrap(depth_ecco,so_ecco2,z,-1,1)
;so_soda3=int2p_n_Wrap(depth_soda,so_soda2,z,-1,1)

;so_ecda3 := so_ecda3(z_l|:,yt_ocean|:)
;so_godas3 := so_godas3(z_l|:,lat|:)
;so_ecco3 := so_ecco3(z_l|:,lat|:)
;so_soda3 := so_soda3(z_l|:,lat|:)
;--- z weighting---------------------------------
; z_w=new(15,double)
; z_w(0)=2.5/600
; do i=0,13
;  z_w(i+1)=(z(i+1)-z(i))/600.
; end do
;printVarSummary(z_w)
;exit
;--------------------------------------
;taylor_weight_sal_oda=taylor_stats(so_oda2,en4_sal3_15,z_w,0)
;taylor_weight_sal_aoda=taylor_stats(so_aoda2,en4_sal3,z_w,0)
;taylor_weight_sal_ecda=taylor_stats(so_ecda3,en4_sal3_1017,z_w,0)
;taylor_weight_sal_godas=taylor_stats(so_godas3,en4_sal3,z_w,0)
;taylor_weight_sal_ecco=taylor_stats(so_ecco3,en4_sal3_1017,z_w,0)
;taylor_weight_sal_soda=taylor_stats(so_soda3,en4_sal3,z_w,0)

;--------------------------------------
;taylor_sal_oda=taylor_stats(so_oda2,en4_sal3_15,1.,0)
;taylor_sal_aoda=taylor_stats(so_aoda2,en4_sal3,1.,0)
;taylor_sal_ecda=taylor_stats(so_ecda3,en4_sal3_1017,1.,0)
;taylor_sal_godas=taylor_stats(so_godas3,en4_sal3,1.,0)
;taylor_sal_ecco=taylor_stats(so_ecco3,en4_sal3_1017,1.,0)
;taylor_sal_soda=taylor_stats(so_soda3,en4_sal3,1.,0)
;--------------------------------------
;sal_ratio=new(6,double)
;sal_ratio(0)=taylor_sal_oda(1)
;sal_ratio(1)=taylor_sal_aoda(1)
;sal_ratio(2)=taylor_sal_ecda(1)
;sal_ratio(3)=taylor_sal_godas(1)
;sal_ratio(4)=taylor_sal_ecco(1)
;sal_ratio(5)=taylor_sal_soda(1)
;sal_ratio!0="data"

;sal_cc=new(6,double)
;sal_cc(0)=taylor_sal_oda(0)
;sal_cc(1)=taylor_sal_aoda(0)
;sal_cc(2)=taylor_sal_ecda(0)
;sal_cc(3)=taylor_sal_godas(0)
;sal_cc(4)=taylor_sal_ecco(0)
;sal_cc(5)=taylor_sal_soda(0)
;sal_cc!0="data"
;print(sal_ratio)
;print(sal_cc)
;exit
;--------------------------------------
;system("rm -f "+dir5+"no_weight_Taylor_stats_EN4_PDAFs_reanalysis_Zonal_mean_Pacific_temp_sal_total_period.nc")
;out=addfile(dir5+"no_weight_Taylor_stats_EN4_PDAFs_reanalysis_Zonal_mean_Pacific_temp_sal_total_period.nc","c")
;out->sal_ratio=sal_ratio
;out->temp_ratio=temp_ratio
;out->sal_cc=sal_cc
;out->temp_cc=temp_cc

;sal_weight_ratio=new(6,double)
;sal_weight_ratio(0)=taylor_weight_sal_oda(1)
;sal_weight_ratio(1)=taylor_weight_sal_aoda(1)
;sal_weight_ratio(2)=taylor_weight_sal_ecda(1)
;sal_weight_ratio(3)=taylor_weight_sal_godas(1)
;sal_weight_ratio(4)=taylor_weight_sal_ecco(1)
;sal_weight_ratio(5)=taylor_weight_sal_soda(1)
;sal_weight_ratio!0="data"

;sal_weight_cc=new(6,double)
;sal_weight_cc(0)=taylor_weight_sal_oda(0)
;sal_weight_cc(1)=taylor_weight_sal_aoda(0)
;sal_weight_cc(2)=taylor_weight_sal_ecda(0)
;sal_weight_cc(3)=taylor_weight_sal_godas(0)
;sal_weight_cc(4)=taylor_weight_sal_ecco(0)
;sal_weight_cc(5)=taylor_weight_sal_soda(0)
;sal_weight_cc!0="data"
;--------------------------------------
;system("rm -f "+dir5+"weight_Taylor_stats_EN4_PDAFs_reanalysis_Zonal_mean_Pacific_temp_sal_total_period.nc")
;out=addfile(dir5+"weight_Taylor_stats_EN4_PDAFs_reanalysis_Zonal_mean_Pacific_temp_sal_total_period.nc","c")
;out->sal_ratio=sal_weight_ratio
;out->temp_ratio=temp_weight_ratio
;out->sal_cc=sal_weight_cc
;out->temp_cc=temp_weight_cc
;;--------------------------------------

end
