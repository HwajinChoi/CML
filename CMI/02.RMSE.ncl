begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
l=(/"1","2"/);lead time
e=(/"0.2","0.7","1.2"/)
e0=(/0.2,0.7,1.2/)
depth=(/"0-100m","100-300m","300-800m"/)
dir0="/media/cmlws/Data2/hjc/CMI/predict/"
dir1="/media/cmlws/Data2/hjc/CMI/COBALT/"

 do i=0,1 ;for lead time
 gile0=systemfunc("ls "+dir0+"CMI_prediction_[0-3]*"+e(0)+"_*_"+l(i)+"_199?-2017.nc")
 gile1=systemfunc("ls "+dir0+"CMI_prediction_[0-3]*"+e(1)+"_*_"+l(i)+"_199?-2017.nc")
 gile2=systemfunc("ls "+dir0+"CMI_prediction_[0-3]*"+e(2)+"_*_"+l(i)+"_199?-2017.nc")

 f=addfile(dir0+"CMI_prediction_0_100m_0.2_annual_lead_1_1991-2017.nc","r")
 lat=f->lat
 lon=f->lon

 A0=addfiles(gile0,"r")
 A1=addfiles(gile1,"r")
 A2=addfiles(gile2,"r")
 ListSetType(A0,"join")
 ListSetType(A1,"join")
 ListSetType(A2,"join")

 LT_0=A0[:]->CMI
 LT_1=A1[:]->CMI
 LT_2=A2[:]->CMI
 LT_0!0="depth"
 LT_1!0="depth"
 LT_2!0="depth"
 LT_0 :=dble2flt(LT_0)
 LT_1 :=dble2flt(LT_1)
 LT_2 :=dble2flt(LT_2)
;CMI_COBALT_0-100m_0.2_annual_1990-2017.nc
 file0=systemfunc("ls "+dir1+"CMI_COBALT_[0-3]*"+e(0)+"_*_199"+(i)+"-2017.nc")
 file1=systemfunc("ls "+dir1+"CMI_COBALT_[0-3]*"+e(0)+"_*_199"+(i)+"-2017.nc")
 file2=systemfunc("ls "+dir1+"CMI_COBALT_[0-3]*"+e(0)+"_*_199"+(i)+"-2017.nc")

 a0=addfiles(file0,"r")
 a1=addfiles(file1,"r")
 a2=addfiles(file2,"r")
 ListSetType(a0,"join")
 ListSetType(a1,"join")
 ListSetType(a2,"join")

 CO_0=a0[:]->CMI
 CO_1=a1[:]->CMI
 CO_2=a2[:]->CMI
 CO_0!0="depth"
 CO_1!0="depth"
 CO_2!0="depth"
 dim0=dimsizes(CO_0)
 CO_0 := CO_0(:,1:dim0(1)-1,:,:)
 CO_1 := CO_1(:,1:dim0(1)-1,:,:)
 CO_2 := CO_2(:,1:dim0(1)-1,:,:)

 RM_0=dim_rmsd_n_Wrap(CO_0,LT_0,1)
 RM_1=dim_rmsd_n_Wrap(CO_1,LT_1,1)
 RM_2=dim_rmsd_n_Wrap(CO_2,LT_2,1)

 b2 = addfile(file11,"r")
 lsm_t85  = landsea_mask(b2->LSMASK,lat,lon)
;--------------------------------------------------------------------------------
 COR0 = mask(RM_0,lsm_t85.eq.1,False)
 COR1 = mask(RM_1,lsm_t85.eq.1,False)
 COR2 = mask(RM_2,lsm_t85.eq.1,False)
;printMinMax(COR0,0)
;printMinMax(COR1,0)
;printMinMax(COR2,0)
;exit
;
; COR0 := where(COR0 .eq. "nan", -999,COR0)
; COR1 := where(COR1 .eq. "nan", -999,COR1)
; COR2 := where(COR2 .eq. "nan", -999,COR2)
 copy_VarCoords(RM_0,COR0)
 copy_VarCoords(RM_1,COR1)
 copy_VarCoords(RM_2,COR2)

; replace_ieeenan(COR0,-999.,0)
; replace_ieeenan(COR1,-999.,0)
; replace_ieeenan(COR2,-999.,0)

 plot=new(9,graphic)
 wks=gsn_open_wks("png","./RMSE_COBALT_prediction_199"+(i+1)+"-2017_leadtime_"+l(i))
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 ;res@cnFillMode                =   "AreaFill"
 res@lbLabelBarOn           =      False
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
; res@gsnLeftStringFontHeightF= 0.035
; res@gsnLeftString
; res@gsnLeftStringOrthogonalPosF=0.1
 res@lbLabelBarOn           = False
; res@tmXBLabelFontHeightF  =       0.025
; res@tmYLLabelFontHeightF  =       0.025
; res@tmXBLabelStride     =       2
; res@tmYLLabelStride     =       2
 sres                   =   res
 res@mpCenterLonF       =       180
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.1
 res@cnMinLevelValF         =      0
 res@cnLevelSpacingF        =       0.01
 res@cnFillPalette          =       "cmocean_deep"

 do j=0,2

 plot(3*j)=gsn_csm_contour_map(wks,COR0(j,:,:),res)
 plot(3*j+1)=gsn_csm_contour_map(wks,COR1(j,:,:),res)
 plot(3*j+2)=gsn_csm_contour_map(wks,COR2(j,:,:),res)

 end do

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.015
 pres@lbLabelStride     =   2
 pres@gsnPanelLeft  =0.1
 pres@pmLabelBarOrthogonalPosF=-0.03
 pres@pmLabelBarHeightF=0.08

 txres1               = True
 txres1@txFontHeightF = 0.016
 txres1@txAngleF=90
 gsn_text_ndc(wks,"0 - 100m",0.05,0.69,txres1)
 gsn_text_ndc(wks,"100 - 300m",0.05,0.52,txres1)
 gsn_text_ndc(wks,"300 - 800m",0.05,0.34,txres1)

 txres2               = True
 txres2@txFontHeightF = 0.018
 gsn_text_ndc(wks,"High",0.24,0.8,txres2)
 gsn_text_ndc(wks,"Medium",0.55,0.8,txres2)
 gsn_text_ndc(wks,"Low",0.85,0.8,txres2)

 ;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
 gsn_panel(wks,plot,(/3,3/),pres)
 frame(wks)
 delete([/COR0,COR1,COR2,LT_0,LT_1,LT_2/])
 end do


end
