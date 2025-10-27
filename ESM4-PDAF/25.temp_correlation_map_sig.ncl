begin

file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
l=(/"1","2"/);lead time
depth=(/"0-100m","100-300m","300-800m"/)
dir0="/data/hjchoi/CMI/data/corr/"
dir1="/data/hjchoi/CMI/PAPER/image/"

 file0=systemfunc("ls "+dir0+"CORR_Temp_[0-3]*m__LT_1_1991-2017.nc") ; LEAD 1
 gfile0=systemfunc("ls "+dir0+"CORR_Temp_[0-3]*m__LT_2_1992-2017.nc") ; LEAD 2
 f=addfile(dir0+"CMI_corr_0_100m_0.2_annual_lead_1_1991-2017.nc","r")
 lon=f->lon
 lat=f->lat

 a0=addfiles(file0,"r")
 ListSetType(a0,"join")
 c0=addfiles(gfile0,"r")
 ListSetType(c0,"join")

 b2 = addfile(file11,"r")
 lsm_t85  = landsea_mask(b2->LSMASK,lat,lon)

 corr0=a0[:]->corr
 corr0!0="depth"
 gcorr0=c0[:]->corr
 gcorr0!0="depth"

 COR0 = mask(corr0,lsm_t85.eq.1,False)
 COR1 = mask(gcorr0,lsm_t85.eq.1,False)

 COR0 := where(COR0 .eq. "nan", -999,COR0)
 COR1 := where(COR1 .eq. "nan", -999,COR1)
 copy_VarCoords(corr0,COR0)
 copy_VarCoords(gcorr0,COR1)

 replace_ieeenan(COR0,-999.,0)
 replace_ieeenan(COR1,-999.,0)

 COR0&lat=lat
 COR0&lon=lon
 COR1&lon=lon
 COR1&lat=lat
 COR0@_FillValue=-999
 COR1@_FillValue=-999

 sig0=a0[:]->pval
 sig1=c0[:]->pval
 sig0!0="depth"
 sig1!0="depth"
 sig0@_FillValue=-999
 sig1@_FillValue=-999
 SIG0 = mask(sig0,lsm_t85.eq.1,False)
 SIG1 = mask(sig1,lsm_t85.eq.1,False)
 copy_VarCoords(sig0,SIG0)
 copy_VarCoords(sig1,SIG1)
 dim0=dimsizes(sig0)

 S0=new((/dim0(0),dim0(1),dim0(2)/),"double")
 copy_VarCoords(sig0,S0)
 S1=new((/dim0(0),dim0(1),dim0(2)/),"double")
 copy_VarCoords(sig0,S1)
 siglvl=0.05 ; 95%
 S0=where(SIG0 .le. siglvl,2,-1); significance of correlation
 S1=where(SIG1 .le. siglvl,2,-1); significance of correlation

 plot=new(6,graphic)
 plot1=new(6,graphic)
 wks=gsn_open_wks("png",dir1+"CORR_Temp_COBALT_predi_1992-2017_leadtime_total")
 res						=	True
 res@gsnFrame				=       False
 res@gsnDraw				=       False
 res@cnFillOn				=       True
 res@cnInfoLabelOn			=	False
 res@cnLinesOn				=       False
 res@cnLineLabelsOn			=       False
 res@lbLabelBarOn			=	   False
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@lbLabelBarOn			= False
 res@tmXBLabelFontHeightF	=       0.025
 res@tmYLLabelFontHeightF	=		0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 sres					=	res
 sres@mpPerimOn = False
 res@mpCenterLonF		=		180
 res@mpLandFillColor	=	"black"
 res@cnLevelSelectionMode	=       "ManualLevels"
 res@cnMaxLevelValF			=      1.0
 res@cnMinLevelValF			=      -1.0 
 res@cnLevelSpacingF		=		0.1
 res@cnFillPalette			=		"temp_19lev"

 sres@cnConstFEnableFill	=	True
 sres@cnMonoFillColor	=	True
 sres@cnFillColor		=	"black"
 sres@cnFillOn				=       True
 sres@cnMonoFillPattern	=	True
 sres@cnFillScaleF		=	1
 sres@cnFillPattern		=	17	
 sres@cnLinesOn				=       False
 sres@cnLevelSelectionMode = "ExplicitLevels"
 sres@cnLevels = (/0.,3/)
 sres@cnInfoLabelOn = False
 sres@tiMainOn = False
 sres@gsnCenterString	= ""
 sres@lbLabelBarOn		=	False
 sres@cnFillDotSizeF=0.0025
 sres@cnConstFLabelOn=False
 sres@trGridType="TriangularMesh"

 do j=0,2
 res@gsnCenterString		=	""
 plot(2*j)=gsn_csm_contour_map(wks,COR0(j,:,:),res)
 plot1(2*j)=gsn_csm_contour(wks,S0(j,:,:),sres)
 plot1(2*j)=ShadeGtContour(plot1(2*j),2,17)
 overlay(plot(2*j),plot1(2*j))
 end do

 do j=0,2
 res@gsnCenterString		=	""
 plot(2*j+1)=gsn_csm_contour_map(wks,COR1(j,:,:),res)
 plot1(2*j+1)=gsn_csm_contour(wks,S1(j,:,:),sres)
 plot1(2*j+1)=ShadeGtContour(plot1(2*j+1),2,17)
 overlay(plot(2*j+1),plot1(2*j+1))
 end do

 pres						=	True
 pres@gsnFrame         = False 
 pres@gsnPanelLabelBar 		= True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.010 
 pres@lbLabelStride		=	2
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.016
 pres@lbLabelStride     =   2
 pres@gsnPanelLeft  =0.05
 pres@gsnPanelBottom  =0.05
 pres@pmLabelBarOrthogonalPosF=0.
 pres@pmLabelBarWidthF=0.75
 pres@pmLabelBarHeightF=0.12
 pres@gsnPanelMainString = "Temperature"
 pres@gsnPanelMainFontHeightF=0.025
 pres@gsnPanelMainPosYF=0.96

 txres1               = True
 txres1@txFontHeightF = 0.016
 txres1@txAngleF=90
 gsn_text_ndc(wks,"0 - 100m",0.022,0.772,txres1)
 gsn_text_ndc(wks,"100 - 300m",0.022,0.538,txres1)
 gsn_text_ndc(wks,"300 - 800m",0.022,0.264,txres1)

 txres2               = True
 txres2@txFontHeightF = 0.018
 gsn_text_ndc(wks,"LT = 1",0.285,0.92,txres2)
 gsn_text_ndc(wks,"LT = 2",0.77,0.92,txres2)

 gsn_panel(wks,plot,(/3,2/),pres)
 frame(wks)
 delete([/res,sres,SIG0,sig0,file0,a0,plot,corr0/])
; end do
end
