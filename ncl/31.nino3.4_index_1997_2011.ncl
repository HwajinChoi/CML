begin
dir1="/media/cmlws/Data2/hjc/OISST/"
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid_mask_land/"
dir3="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
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
f=addfile(dir1+"oisst-avhrr-v02r01.r180x90.ONDJF.199701-201112.nc","r")
sst=f->sst(:,0,{lat_min:lat_max},:)
oisst = short2flt(sst)
oisst_lonflip = lonFlip(oisst)
lat_oisst=f->lat({lat_min:lat_max})
lon_oisst=f->lon
rad    = 4.0*atan(1.0)/180.0
clat1   = cos(lat_oisst*rad)
;--------------------------------------------------------------------------------------------
oisst_nino34=oisst(:,:,{nino34_lon_min:nino34_lon_max})
oisst_nino34_wgt = wgt_areaave_Wrap(oisst_nino34,clat1,1.0,1)
oisst_nino34_wgt!0="time_counter"
;---------------------------------------------------------------------------------------------
g2=addfile(dir2+"tos_regrid_clim_ONDJF_1997-2011.nc","r")
tos_clim=g2->tos(:,{lat_min:lat_max},:)
lon_nemo=g2->lon
lat_nemo=g2->lat({lat_min:lat_max})
tos_clim_lonflip = lonFlip(tos_clim)
clat2   = cos(lat_nemo*rad)
time=g2->time_counter
tos_clim_nino34=tos_clim(:,:,{nino34_lon_min:nino34_lon_max})
tos_clim_nino34_wgt = wgt_areaave_Wrap(tos_clim_nino34,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h1=addfile(dir2+"tos_regrid_const_ONDJF_1997-2011.nc","r")
tos_const=h1->tos(:,{lat_min:lat_max},:)
tos_const_lonflip = lonFlip(tos_const)
tos_const_nino34=tos_const(:,:,{nino34_lon_min:nino34_lon_max})
tos_const_nino34_wgt = wgt_areaave_Wrap(tos_const_nino34,clat2,1.0,1)
;---------------------------------------------------------------------------------------------
h2=addfile(dir2+"tos_regrid_inter_ONDJF_1997-2011.nc","r")
tos_inter=h2->tos(:,{lat_min:lat_max},:)
tos_inter_lonflip = lonFlip(tos_inter)
tos_inter_nino34=tos_inter(:,:,{nino34_lon_min:nino34_lon_max})
tos_inter_nino34_wgt = wgt_areaave_Wrap(tos_inter_nino34,clat2,1.0,1)
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
dim=dimsizes(tos_const)
;----------------------------------area average------------------------------------------------
SST_nino34_wgt=new((/4,dim(0)/),"float")
SST_nino34_wgt(0,:)=oisst_nino34_wgt
SST_nino34_wgt(1,:)=tos_clim_nino34_wgt
SST_nino34_wgt(2,:)=tos_const_nino34_wgt
SST_nino34_wgt(3,:)=tos_inter_nino34_wgt
SST_nino34_wgt!0="data"

year2=ispan(1997,2011,1)

clim_SST_wgt=dim_avg_n_Wrap(SST_nino34_wgt,1)
clim_SST=new((/4,15/),"float")
ano_SST=new((/4,15/),"float")

do i=0,14
 clim_SST(:,i)=clim_SST_wgt
end do
copy_VarMeta(SST_nino34_wgt,clim_SST)
ano_SST=SST_nino34_wgt-clim_SST
copy_VarMeta(SST_nino34_wgt,ano_SST)
print(ano_SST(0,:))
;exit
;--------------------------------------------------------------------------------------------------
 wks = gsn_open_wks("x11",dir3+"Nino3.4_index_1997-2011")             ; send graphics to PNG file
 plot=new(4,graphic)
 res   = True
; res@gsnScale = True      
 res@gsnDraw            = False             ; don't draw yet
 res@gsnFrame           = False             ; don't advance frame yet
 res@vpHeightF = 0.43        ; Changes the aspect ratio
 res@vpWidthF  = 0.85
 res@gsnXYBarChartBarWidth=0.7
 res@trYMinF   = -3.        ; min value on y-axis
 res@trYMaxF   =  3.5        ; max value on y-axis
 res@gsnLeftStringOrthogonalPosF=0.08
 res@gsnLeftStringFontHeightF=0.025
 res@trXMaxF            = 2011
 res@trXMinF            = 1997          ; set x-axis minimum
 res@tiYAxisString = "~S~o~N~C" ; y-axis label
 res@tiXAxisString = "Year"      
 res@tmXBMode          = "Explicit"
 res@tmXBValues        = (/2000,2005,2010/)
 res@tmXBMinorPerMajor=4
 res@tmXBLabels        = (/2000,2005,2010/)
 res@tmXBMinorValues=(/1997,1998,1999,2001,2002,2003,2004,2006,2007,2008,2009,2011/)

 res@gsnYRefLine           = 0.              ; reference line   
 res@gsnYRefLineColor = "black"
 res@gsnYRefLineDashPattern=0

 res@gsnXYBarChart         = True            ; create bar chart 
 res@gsnAboveYRefLineColor = "darkgreen"           ; above ref line fill red
 res@gsnBelowYRefLineColor = "darkgreen"          ; below ref line fill blue
 res@xyLineColors = (/"darkgreen","darkgreen"/)         ; colors for the above/blow
 res@gsnLeftString="OISST"
 plot(0) = gsn_csm_xy (wks,year2,ano_SST(0,:),res)
 res@gsnLeftString="CLIM"
 plot(1) = gsn_csm_xy (wks,year2,ano_SST(1,:),res)
 res@gsnLeftString="CONST"
 plot(2) = gsn_csm_xy (wks,year2,ano_SST(2,:),res)
 res@gsnLeftString="INTER"
 plot(3) = gsn_csm_xy (wks,year2,ano_SST(3,:),res)
 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelMainString="Nino 3.4 index (ONDJF)"
; pres@gsnPanelBottom=0.1
; pres@gsnPanelLeft=0.05
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 2
 gsn_panel(wks,plot,(/4,1/),pres)
 frame(wks)


end
