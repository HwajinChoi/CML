begin
dir1="/media/cmlws/Data3/hjc/1pctCO2/co2/"
dir2="/media/cmlws/Data3/hjc/1pctCO2_cdr/co2/"
dir3="/media/cmlws/Data1/hjc/CDR/image/"

f0=addfile(dir1+"co2_Amon_CanESM5_1pctCO2_r1i1p2f1_gn_1850-2000.nc","r")
co2_can=f0->co2(:,{100000},:,:)
lon_can=f0->lon
lat_can=f0->lat
x_can=ispan(1850,2000,1)
can_co2=co2_can(:,{0},{150})
;can_co2=wgt_areaave_Wrap(co2_can,lat_can,lon_can,0)

g0=addfile(dir1+"co2_Amon_CNRM-ESM2-1_1pctCO2_r1i1p1f2_gr_1850-1999.nc","r")
g1=addfile(dir2+"co2_Amon_CNRM-ESM2-1_1pctCO2-cdr_r1i1p1f2_gr_1990-2189.nc","r")
lat_cnrm=g0->lat
lon_cnrm=g0->lon
co2_cnrm=g0->co2(:,{100000},:,:)
x_cnrm=ispan(1850,1999,1)
x_cdr_cnrm=ispan(1990,2189,1)
co2_cdr_cnrm=g1->co2(:,{100000},:,:)
;cnrm_co2=wgt_areaave_Wrap(co2_cnrm,lat_cnrm,lon_cnrm,0)
;cnrm_co2_cdr=wgt_areaave_Wrap(co2_cdr_cnrm,lat_cnrm,lon_cnrm,0)

cnrm_co2=co2_cnrm(:,{0},{150})
cnrm_co2_cdr=co2_cdr_cnrm(:,{0},{150})

h0=addfile(dir1+"co2_Amon_CESM2_1pctCO2_r1i1p1f1_gn_0001-0150.nc","r")
h1=addfile(dir2+"co2_Amon_CESM2_1pctCO2-cdr_r1i1p1f1_gn_0001-0200.nc","r")
lat_cesm=h0->lat
lon_cesm=h0->lon
co2_cesm=h0->co2(:,{100000},:,:)
x_cesm=ispan(1,150,1)
co2_cdr_cesm=h1->co2(:,{100000},:,:)
x_cdr_cesm=ispan(1,200,1)
;cesm_co2=wgt_areaave_Wrap(co2_cesm,lat_cesm,lon_cesm,0)
;cesm_co2_cdr=wgt_areaave_Wrap(co2_cdr_cesm,lat_cesm,lon_cesm,0)

cesm_co2=co2_cesm(:,{0},{150})
cesm_co2_cdr=co2_cdr_cesm(:,{0},{150})

k0=addfile(dir1+"co2_Amon_NorESM2-LM_1pctCO2_r1i1p1f1_gn_0001-0150.nc","r")
k1=addfile(dir2+"co2_Amon_NorESM2-LM_1pctCO2-cdr_r1i1p1f1_gn_0141-0399.nc","r")
lat_nor=k0->lat
lon_nor=k0->lon
co2_nor=k0->co2(:,{100000},:,:)
x_nor=ispan(1,150,1)
co2_cdr_nor=k1->co2(:,{100000},:,:)
x_cdr_nor=ispan(141,399,1)
;nor_co2=wgt_areaave_Wrap(co2_nor,lat_nor,lon_nor,0)
;nor_co2_cdr=wgt_areaave_Wrap(co2_cdr_nor,lat_nor,lon_nor,0)

nor_co2=co2_nor(:,{0},{150})
nor_co2_cdr=co2_cdr_nor(:,{0},{150})
;printVarSummary(nor_co2)
;printMinMax(nor_co2,0)
;exit

wks = gsn_open_wks("png",dir3+"CO2_timeseries")             ; send graphics to PNG file
plot=new(7,graphic)
res   = True
; res@gsnScale = True      
res@gsnDraw            = False             ; don't draw yet
res@gsnFrame           = False             ; don't advance frame yet
res@vpHeightF = 0.43        ; Changes the aspect ratio
res@vpWidthF  = 0.85
;res@trYMinF   = -3.        ; min value on y-axis
;res@trYMaxF   =  3.5        ; max value on y-axis
;res@gsnLeftStringOrthogonalPosF=0.08
;res@gsnLeftStringFontHeightF=0.025
;res@trXMaxF            = 2000
res@trXMaxF            = 1990
res@trXMinF            = 1850          ; set x-axis minimum
res@tiXAxisString = "Year"

res@trYMinF   = 0.0002        ; min value on y-axis
res@trYMaxF   =  0.0014        ; max value on y-axis
res@tiYAxisString = "CNRM-ESM2-1" ; y-axis label
plot(0) = gsn_csm_xy (wks,x_cnrm,cnrm_co2,res)
res@tiYAxisString = "" ; y-axis label
res@trXMaxF            = 2190
res@trXMinF            = 1990          ; set x-axis minimum
plot(1) = gsn_csm_xy (wks,x_cdr_cnrm,cnrm_co2_cdr,res)
res@tiYAxisString = "CESM2" ; y-axis label
res@trXMaxF            = 150
res@trXMinF            = 1          ; set x-axis minimum
delete([/res@trYMaxF,res@trYMinF/])
plot(2) = gsn_csm_xy (wks,x_cesm,cesm_co2,res)
res@trXMaxF            = 200
res@tiYAxisString = "" ; y-axis label
plot(3) = gsn_csm_xy (wks,x_cdr_cesm,cesm_co2_cdr,res)
res@tiYAxisString = "NorESM2-L" ; y-axis label
res@trXMaxF            = 150
res@trXMinF            = 1          ; set x-axis minimum
plot(4) = gsn_csm_xy (wks,x_nor,nor_co2,res)
res@tiYAxisString = "" ; y-axis label
res@trXMaxF            = 400
res@trXMinF            = 140          ; set x-axis minimum
plot(5) = gsn_csm_xy (wks,x_cdr_nor,nor_co2_cdr,res)
res@tiYAxisString = "CanESM5" ; y-axis label
res@trXMaxF            = 2000
res@trXMinF            = 1850          ; set x-axis minimum
plot(6) = gsn_csm_xy (wks,x_can,can_co2,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelMainString="CO2 concentration"
 pres@gsnPanelBottom=0.1
 pres@gsnPanelLeft=0.05
pres@gsnPanelRowSpec=True
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 2
gsn_panel(wks,plot,(/2,2,2,1/),pres)
frame(wks)


end
