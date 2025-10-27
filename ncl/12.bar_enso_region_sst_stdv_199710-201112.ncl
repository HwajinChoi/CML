begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
dir4="/media/cmlws/Data2/hjc/image/"
;--------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3 (5N-5S, 150W-90W)-----------------------------------------------------------------------
nino3_lon_min=-150
nino3_lon_max=-90
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;-----------------NINO4 (5N-5S, 160E-150W); It is neended to lonflip--------------------------------------------
nino4_lon_min=160
nino4_lon_max=210
;-------------------------------------------OISST-------------------------------------------
f=addfile(dir1+"oisst-avhrr-v02r01.r180x90.198109-201912.nc","r")
sst=f->sst(0:363,0,:,:)
sst := short2flt(sst)
sst_lonflip=lonFlip(sst)
;---------------------------------------------------------------------------------------------
sst_nino3=sst(193:363,{lat_min:lat_max},{nino3_lon_min:nino3_lon_max}) ;1997.10~ 2011.12
sst_nino34=sst(193:363,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max}) ;1997.10~ 2011.12
sst_nino4=sst_lonflip(193:363,{lat_min:lat_max},{nino4_lon_min:nino4_lon_max}) ;1997.10~ 2011.12
;---------------------------------------------------------------------------------------------
sst_nino3_1=dim_avg_n_Wrap(sst_nino3,1)
sst_nino3_2=dim_avg_n_Wrap(sst_nino3_1,1)
sst_nino34_1=dim_avg_n_Wrap(sst_nino34,1)
sst_nino34_2=dim_avg_n_Wrap(sst_nino34_1,1)
sst_nino4_1=dim_avg_n_Wrap(sst_nino4,1)
sst_nino4_2=dim_avg_n_Wrap(sst_nino4_1,1)
;---------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
sst_nino3_stdv=dim_stddev_n_Wrap(sst_nino3_2,0)
sst_nino34_stdv=dim_stddev_n_Wrap(sst_nino34_2,0)
sst_nino4_stdv=dim_stddev_n_Wrap(sst_nino4_2,0)
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;---------CHL_clim----------------------------------------------------------------------------
g2=addfile(dir3+"tos_regrid_clim_199710-201112.nc","r")
tos_clim=g2->tos
tos_clim_lonflip=lonFlip(tos_clim)
;-------------------------------------------------------------------------------------------------
tos_clim_nino3=tos_clim(:,{lat_min:lat_max},{nino3_lon_min:nino3_lon_max}) ;1997.10~ 2011.12
tos_clim_nino34=tos_clim(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max}) ;1997.10~ 2011.12
tos_clim_nino4=tos_clim_lonflip(:,{lat_min:lat_max},{nino4_lon_min:nino4_lon_max}) ;1997.10~ 2011.12
;---------------------------------------------------------------------------------------------
tos_clim_nino3_1=dim_avg_n_Wrap(tos_clim_nino3,1)
tos_clim_nino3_2=dim_avg_n_Wrap(tos_clim_nino3_1,1)
tos_clim_nino34_1=dim_avg_n_Wrap(tos_clim_nino34,1)
tos_clim_nino34_2=dim_avg_n_Wrap(tos_clim_nino34_1,1)
tos_clim_nino4_1=dim_avg_n_Wrap(tos_clim_nino4,1)
tos_clim_nino4_2=dim_avg_n_Wrap(tos_clim_nino4_1,1)
;---------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
tos_clim_nino3_stdv=dim_stddev_n_Wrap(tos_clim_nino3_2,0)
tos_clim_nino34_stdv=dim_stddev_n_Wrap(tos_clim_nino34_2,0)
tos_clim_nino4_stdv=dim_stddev_n_Wrap(tos_clim_nino4_2,0)
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir3+"tos_regrid_const_199710-201112.nc","r")
tos_const=h1->tos
tos_const_lonflip=lonFlip(tos_const)
tos_const_nino3=tos_const(:,{lat_min:lat_max},{nino3_lon_min:nino3_lon_max}) ;1997.10~ 2011.12
tos_const_nino34=tos_const(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max}) ;1997.10~ 2011.12
tos_const_nino4=tos_const_lonflip(:,{lat_min:lat_max},{nino4_lon_min:nino4_lon_max}) ;1997.10~ 2011.12
;---------------------------------------------------------------------------------------------
tos_const_nino3_1=dim_avg_n_Wrap(tos_const_nino3,1)
tos_const_nino3_2=dim_avg_n_Wrap(tos_const_nino3_1,1)
tos_const_nino34_1=dim_avg_n_Wrap(tos_const_nino34,1)
tos_const_nino34_2=dim_avg_n_Wrap(tos_const_nino34_1,1)
tos_const_nino4_1=dim_avg_n_Wrap(tos_const_nino4,1)
tos_const_nino4_2=dim_avg_n_Wrap(tos_const_nino4_1,1)
;---------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
tos_const_nino3_stdv=dim_stddev_n_Wrap(tos_const_nino3_2,0)
tos_const_nino34_stdv=dim_stddev_n_Wrap(tos_const_nino34_2,0)
tos_const_nino4_stdv=dim_stddev_n_Wrap(tos_const_nino4_2,0)
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir3+"tos_regrid_inter_199710-201112.nc","r")
tos_inter=h2->tos
tos_inter_lonflip=lonFlip(tos_inter)
tos_inter_nino3=tos_inter(:,{lat_min:lat_max},{nino3_lon_min:nino3_lon_max}) ;1997.10~ 2011.12
tos_inter_nino34=tos_inter(:,{lat_min:lat_max},{nino34_lon_min:nino34_lon_max}) ;1997.10~ 2011.12
tos_inter_nino4=tos_inter_lonflip(:,{lat_min:lat_max},{nino4_lon_min:nino4_lon_max}) ;1997.10~ 2011.12
;---------------------------------------------------------------------------------------------
tos_inter_nino3_1=dim_avg_n_Wrap(tos_inter_nino3,1)
tos_inter_nino3_2=dim_avg_n_Wrap(tos_inter_nino3_1,1)
tos_inter_nino34_1=dim_avg_n_Wrap(tos_inter_nino34,1)
tos_inter_nino34_2=dim_avg_n_Wrap(tos_inter_nino34_1,1)
tos_inter_nino4_1=dim_avg_n_Wrap(tos_inter_nino4,1)
tos_inter_nino4_2=dim_avg_n_Wrap(tos_inter_nino4_1,1)
;---------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
tos_inter_nino3_stdv=dim_stddev_n_Wrap(tos_inter_nino3_2,0)
tos_inter_nino34_stdv=dim_stddev_n_Wrap(tos_inter_nino34_2,0)
tos_inter_nino4_stdv=dim_stddev_n_Wrap(tos_inter_nino4_2,0)
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------

 plot=new(3,graphic)
 wks  = gsn_open_wks("x11",dir4+"bar_enso_region_sst_stdv_199710-201112")    ; send graphics to PNG file
 x=(/1,2,3,4/)
 y_nino3=(/sst_nino3_stdv,tos_clim_nino3_stdv,tos_const_nino3_stdv,tos_inter_nino3_stdv/)
 y_nino34=(/sst_nino34_stdv,tos_clim_nino34_stdv,tos_const_nino34_stdv,tos_inter_nino34_stdv/)
 y_nino4=(/sst_nino4_stdv,tos_clim_nino4_stdv,tos_const_nino4_stdv,tos_inter_nino4_stdv/)

 res			=	True
 res@gsnFrame              = False                ; don't advance frame yet
 res@gsnDraw                =       False
 res@gsnXYBarChart         = True                 ; turn on bar chart
 res@gsnXYBarChartBarWidth = 0.75                 ; change bar widths
 res@gsnXYBarChartColors = (/"black","black","black","black"/)  
 res@trXMinF               = 0                    ; adds space on either end
 res@trXMaxF               = 5                    ; of the 1st and last bars
 res@vpHeightF=0.4
 res@vpWidthF=0.6
 res@gsnLeftStringFontHeightF=0.022
 res@gsnLeftStringOrthogonalPosF=0.05
 res@tmXBMode                 = "Explicit"
 res@tmXBValues               = ispan(1,4,1)
 res@tmXBLabels		=(/"OISST","CLIM","CONST","INTER"/)
 res@gsnLeftString		= "STDV NINO3"
 res@gsnRightString		= ""
 res@trYMinF               = 1.0                   ; bring bars down to zero
 res@tmYLMode		=	"Manual"
 res@tmYLTickSpacingF		=0.1
 res@trYMaxF               = 1.3                   ; bring bars down to zero
 plot(0) = gsn_csm_xy (wks,x,y_nino3,res)
 res@gsnLeftString		= "STDV NINO34"
 res@trYMinF               = 0.9                   ; bring bars down to zero
 res@trYMaxF               = 1.1                   ; bring bars down to zero
 plot(1) = gsn_csm_xy (wks,x,y_nino34,res)
 res@trYMinF               = 0.7                   ; bring bars down to zero
 res@trYMaxF               = 0.95                   ; bring bars down to zero
 res@gsnLeftString		= "STDV NINO4"
 plot(2) = gsn_csm_xy (wks,x,y_nino4,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Standard deviation of SST (199710 - 201112)"
; pres@gsnPanelBottom=0.1
; pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 5
 gsn_panel(wks,plot,(/3,1/),pres)
 txres               = True
 txres@txFontHeightF = 0.014
; txres@txAngleF      = 90.
; gsn_text_ndc(wks, "OISST",  0.1, 0.83, txres)
; gsn_text_ndc(wks, "CLIM",  0.105, 0.628, txres)
; gsn_text_ndc(wks, "CONST", 0.1, 0.41, txres)
; gsn_text_ndc(wks, "INTER", 0.105, 0.205, txres)
 
 frame(wks)

end
