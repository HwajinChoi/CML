begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
l=(/"1","2"/);lead time
e=(/"0.2","0.7","1.2"/)
e0=(/0.2,0.7,1.2/)
depth=(/"0-100m","100-300m","300-800m"/)
dir0="/data/hjchoi/CMI/data/corr/"
dir1="/data/hjchoi/CMI/PAPER/image/"

 do i=0,1 ;for lead time
 gile0=systemfunc("ls "+dir0+"CORR_CMI_[0-3]*"+e(0)+"_LT_"+l(i)+"_199?-2017.nc")
 gile1=systemfunc("ls "+dir0+"CORR_CMI_[0-3]*"+e(1)+"_LT_"+l(i)+"_199?-2017.nc")
 gile2=systemfunc("ls "+dir0+"CORR_CMI_[0-3]*"+e(2)+"_LT_"+l(i)+"_199?-2017.nc")

 f=addfile(dir0+"CMI_corr_0_100m_0.2_annual_lead_1_1991-2017.nc","r")
 lat=f->lat
 lon=f->lon

 A0=addfiles(gile0,"r")
 A1=addfiles(gile1,"r")
 A2=addfiles(gile2,"r")
 ListSetType(A0,"join")
 ListSetType(A1,"join")
 ListSetType(A2,"join")

 corr0=A0[:]->corr
 corr1=A1[:]->corr
 corr2=A2[:]->corr
 corr0!0="depth"
 corr1!0="depth"
 corr2!0="depth"

 file0=systemfunc("ls "+dir0+"CORR_Temp_*_LT_"+l(i)+"_199?-2017.nc")
 file1=systemfunc("ls "+dir0+"CORR_Temp_*_LT_"+l(i)+"_199?-2017.nc")
 file2=systemfunc("ls "+dir0+"CORR_Temp_*_LT_"+l(i)+"_199?-2017.nc")

 a0=addfiles(file0,"r")
 a1=addfiles(file1,"r")
 a2=addfiles(file2,"r")
 ListSetType(a0,"join")
 ListSetType(a1,"join")
 ListSetType(a2,"join")

 temp0=a0[:]->corr
 temp1=a1[:]->corr
 temp2=a2[:]->corr
 temp0!0="depth"
 temp1!0="depth"
 temp2!0="depth"

 b2 = addfile(file11,"r")
 lsm_t85  = landsea_mask(b2->LSMASK,lat,lon)
;--------------------------------------------------------------------------------
 COR0 = mask(corr0,lsm_t85.eq.1,False)
 COR1 = mask(corr1,lsm_t85.eq.1,False)
 COR2 = mask(corr2,lsm_t85.eq.1,False)

 COR0 := where(COR0 .eq. "nan", -999,COR0)
 COR1 := where(COR1 .eq. "nan", -999,COR1)
 COR2 := where(COR2 .eq. "nan", -999,COR2)
 copy_VarCoords(corr0,COR0)
 copy_VarCoords(corr1,COR1)
 copy_VarCoords(corr2,COR2)

 replace_ieeenan(COR0,-999.,0)
 replace_ieeenan(COR1,-999.,0)
 replace_ieeenan(COR2,-999.,0)

 COR0&lat=lat
 COR0&lon=lon
 COR1&lon=lon
 COR1&lat=lat
 COR2&lon=lon
 COR2&lat=lat
 COR0@_FillValue=-999
 COR1@_FillValue=-999
 COR2@_FillValue=-999
;--------------------------------------------------------------------------------
 TEM0 = mask(temp0,lsm_t85.eq.1,False)
 TEM1 = mask(temp1,lsm_t85.eq.1,False)
 TEM2 = mask(temp2,lsm_t85.eq.1,False)

 TEM0 := where(TEM0 .eq. "nan", -999,TEM0)
 TEM1 := where(TEM1 .eq. "nan", -999,TEM1)
 TEM2 := where(TEM2 .eq. "nan", -999,TEM2)
 copy_VarCoords(temp0,TEM0)
 copy_VarCoords(temp1,TEM1)
 copy_VarCoords(temp2,TEM2)

 replace_ieeenan(TEM0,-999.,0)
 replace_ieeenan(TEM1,-999.,0)
 replace_ieeenan(TEM2,-999.,0)

 TEM0&lat=lat
 TEM0&lon=lon
 TEM1&lon=lon
 TEM1&lat=lat
 TEM2&lon=lon
 TEM2&lat=lat
 TEM0@_FillValue=-999
 TEM1@_FillValue=-999
 TEM2@_FillValue=-999
;--------------------------------------------------------------------------------
 
 diff0=COR0-TEM0
 diff1=COR1-TEM1
 diff2=COR2-TEM2
 copy_VarCoords(COR0,diff0)
 copy_VarCoords(COR1,diff1)
 copy_VarCoords(COR2,diff2)

 plot=new(9,graphic)
 wks=gsn_open_wks("x11",dir1+"DIFF_corr_COBALT_Temp_1991-2017_leadtime_"+l(i))
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
 res@cnMaxLevelValF         =      0.4
 res@cnMinLevelValF         =      -0.4
 res@cnLevelSpacingF        =       0.05
 res@cnFillPalette          =       "temp_19lev"

 j=0
 plot(3*j)=gsn_csm_contour_map(wks,diff0(j,:,:),res)
 plot(3*j+1)=gsn_csm_contour_map(wks,diff1(j,:,:),res)
 plot(3*j+2)=gsn_csm_contour_map(wks,diff2(j,:,:),res)

 do j=1,2

 plot(3*j)=gsn_csm_contour_map(wks,diff0(j,:,:),res)
 plot(3*j+1)=gsn_csm_contour_map(wks,diff1(j,:,:),res)
 plot(3*j+2)=gsn_csm_contour_map(wks,diff2(j,:,:),res)

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
 gsn_text_ndc(wks,"Meta|0.2|",0.24,0.8,txres2)
 gsn_text_ndc(wks,"Meta|0.7|",0.55,0.8,txres2)
 gsn_text_ndc(wks,"Meta|1.2|",0.85,0.8,txres2)

 ;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
 gsn_panel(wks,plot,(/3,3/),pres)
 frame(wks)
 end do


end
