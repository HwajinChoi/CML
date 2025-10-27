begin
dir1="/media/cmlws/Data2/hjc/satellite/seawifs_modis/"
dir2="/media/cmlws/Data2/hjc/image/"
;------------------------------------------------------------------------------------------
lat_min=-5
lat_max=5
;-----------------NINO3.4 (5N-5S, 170W-120W)--------------------------------------------------------------------
nino34_lon_min=-170
nino34_lon_max=-120
;-------------------------------------------OISST-------------------------------------------
k=addfile(dir1+"LME.r180x90.masked.nc","r")
masked=dble2flt(k->mask); 1 ->open ocean

f=addfile(dir1+"chl_clim_seawifs_modis_regrid_199710-202112.nc","r");clim
chl_clim=f->chlor_a(:,); 12*90*180
chl_clim@_FillValue=-32767
lon=f->lon
lat=f->lat({lat_min:lat_max})
dim1=dimsizes(chl_clim)
masked_12=new((/dim1(0),dim1(1),dim1(2)/),typeof(chl_clim))
 do j=0,dim1(0)-1
  masked_12(j,:,:)=masked
 end do
masked_12!0="time"
chl_clim_m=where(masked_12 .eq. 1,chl_clim,chl_clim@_FillValue)
copy_VarMeta(chl_clim,chl_clim_m)

g=addfile(dir1+"chl_r180x90_199710-202112.nc","r");
chl_inter=g->chlor_a(3:290,:,:);291*90*180
chl_inter@_FillValue=-32767
time=g->time(3:290)
dim2=dimsizes(chl_inter)

masked_288=new((/dim2(0),dim2(1),dim2(2)/),typeof(chl_inter))
 do j=0,dim2(0)-1
  masked_288(j,:,:)=masked
 end do
masked_288!0="time"
chl_inter_m=where(masked_288 .eq. 1,chl_inter,chl_inter@_FillValue)
copy_VarMeta(chl_inter,chl_inter_m)

h=addfile(dir1+"const_chl_r180x90_199710-202112.nc","r")
t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
chl_const=h->chlor_a(3:290,:,:)
chl_const_m=where(masked_288 .eq. 1,chl_const,chl_const@_FillValue)
copy_VarMeta(chl_const,chl_const_m)

rad    = 4.0*atan(1.0)/180.0
re     = 6371220.0
rr     = re*rad
clat   = cos(lat*rad)

const = wgt_areaave_Wrap(chl_const_m, clat, 1.0, 1)
clim = wgt_areaave_Wrap(chl_clim_m, clat, 1.0, 1)
inter = wgt_areaave_Wrap(chl_inter_m, clat, 1.0, 1)

CHL=new((/3,288/),"float")
 do i=0,23
  CHL(0,12*i:12*i+11)=clim
 end do
CHL(1,:)=const
CHL(2,:)=inter
year=ispan(1998,2021,4)

wks = gsn_open_wks("png",dir2+"only_open_sea_prescribed_chl_area_averaged_timeseries")
  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
  res@trXMaxF            = 2021
  res@trXMinF            = 1998              ; set x-axis minimum
  res@trYMinF            = 0.04              ; set x-axis minimum
  res@trYMaxF            = 0.20 
  res@tmYLMode           = "Manual"
  res@tmYLTickSpacingF   =  0.05
  res@tmYLTickStartF     =  0.05
  res@tmYLTickEndF       = 0.4
  res@tmYLMinorPerMajor=4
;---------For anomaly----------
;  res@gsnYRefLine       =0.05
;  res@gsnYRefLineColor = "blue"
;  res@gsnYRefLineDashPattern=0
;-------------------------------
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = (/"Red","Blue","Green"/) ; colors chosen
  res@xyLineThicknesses  = (/3.,3.,3./)      ; line thicknesses
  res@xyDashPatterns     = (/0,0.,0./)      ; make all lines solid
  res@tiYAxisString      = "mg / m-3"      ; add an axis title
  res@txFontHeightF      = 0.0195            ; change title font heights
  res@tmXBMode          = "Explicit"
  res@tmXBValues        = year
  res@tmXBLabels        = year
  res@tiMainString="Global Chlorophyll Concentration (1998-2021)"
  plot = gsn_csm_xy (wks,yfrac,CHL,res)       ; create line plot

  gres = True
  gres@YPosPercent = 25.    ; expressed as %, 0->100, sets position of top border of legend
  gres@XPosPercent = 80      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres = True
  lineres@lgLineColors = (/"red","blue","green"/) ; line colors
  lineres@lgLineThicknesses = 3                        ; line thicknesses
  lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
  textres = True
  textres@lgLabels = (/"CLIM","CONST","INTER"/)  ; legend labels (required)
  plot = simple_legend(wks,plot,gres,lineres,textres)

 draw(plot)    ; This will draw all three curves
 frame(wks)

end
