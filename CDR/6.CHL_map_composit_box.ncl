begin
N=0

m=(/"ACCESS-ESM1-5","CanESM5","CESM2","CNRM-ESM2-1","MIROC-ES2L","NorESM2-LM","UKESM1-0-LL","GFDL-ESM4"/)
dir1="/media/cmlws/Data1/hjc/CDR/data/1pctCO2/chl_int_30/"
dir2="/media/cmlws/Data1/hjc/CDR/data/1pctCO2_cdr/chl_int_30/"
dir3="/media/cmlws/Data1/hjc/CDR/image/"
dir4="/media/cmlws/Data1/hjc/CDR/data/chl_peak_int_30/"

file1=systemfunc("ls "+dir1+"chl_Omon_*.nc")
ffile1=systemfunc("ls "+dir1+"chl_Omon_*.nc | head -1")
gfile1=systemfunc("ls "+dir2+"chl_Omon_*.nc")
hfile1=systemfunc("ls "+dir4+"chl_Omon_*.nc")

File=addfile(ffile1,"r")
lat=File->lat
lon=File->lon
Nlat = dimsizes(lat)
Nlon = dimsizes(lon)

;CNRM unit problem

f1=addfiles(file1,"r")
ListSetType(f1,"join")
chl=f1[:]->chl
chl := chl(:,:,0,:,:)
chl!0="model"
chl=chl*10^6
chl(3,:,:,:)=chl(3,:,:,:)/(10^3)

g1=addfiles(gfile1,"r")
ListSetType(g1,"join")
chl_cdr=g1[:]->chl
chl_cdr := chl_cdr(:,:,0,:,:)
chl_cdr!0="model"
chl_cdr=chl_cdr*10^6
chl_cdr(3,:,:,:)=chl_cdr(3,:,:,:)/(10^3)
h1=addfiles(hfile1,"r")
ListSetType(h1,"join")
chl_peak=h1[:]->chl
chl_peak := chl_peak(:,:,0,:,:)
chl_peak!0="model"
chl_peak=chl_peak*10^6
chl_peak(3,:,:,:)=chl_peak(3,:,:,:)/(10^3)
;------------------------------------------------------------------------------
CHL=dim_avg_n_Wrap(chl,1)
CHL_mean=dim_avg_n_Wrap(CHL,0)

CHL_cdr=dim_avg_n_Wrap(chl_cdr,1)
CHL_cdr_mean=dim_avg_n_Wrap(CHL_cdr,0)

CHL_peak=dim_avg_n_Wrap(chl_peak,1)
CHL_peak_mean=dim_avg_n_Wrap(CHL_peak,0)
;-----------------------------------------------------------------
diff=CHL_cdr-CHL
copy_VarMeta(CHL,diff)
diff_mean=dim_avg_n_Wrap(diff,0)

peak_diff=CHL_peak-CHL
copy_VarMeta(CHL,peak_diff)
peak_diff_mean=dim_avg_n_Wrap(peak_diff,0)

peak_cdr_diff=CHL_peak-CHL_cdr
copy_VarMeta(CHL,peak_cdr_diff)
peak_cdr_diff_mean=dim_avg_n_Wrap(peak_cdr_diff,0)
;-----------------------------------------------------------------
diff_mask=where(diff .gt. 0 ,1,0) 
peak_diff_mask=where(peak_diff .gt. 0 ,1,0) 
peak_cdr_diff_mask=where(peak_cdr_diff .gt. 0 ,1,0) 
copy_VarCoords(diff,diff_mask)
copy_VarCoords(peak_diff,peak_diff_mask)
copy_VarCoords(peak_cdr_diff,peak_cdr_diff_mask)

diff_MASK=dim_sum_n_Wrap(diff_mask,0)
peak_diff_MASK=dim_sum_n_Wrap(peak_diff_mask,0)
peak_cdr_diff_MASK=dim_sum_n_Wrap(peak_cdr_diff_mask,0)

DIFF=where(diff_MASK .ge. 5 .or. diff_MASK .le. 3 , 1, -1)
copy_VarCoords(diff_MASK,DIFF)
PEAK_DIFF=where(peak_diff_MASK .ge. 5 .or. peak_diff_MASK .le. 3 , 1, -1)
copy_VarCoords(diff_MASK,PEAK_DIFF)
PEAK_CDR_DIFF=where(peak_cdr_diff_MASK .ge. 5 .or. peak_cdr_diff_MASK .le. 3 , 1, -1)
copy_VarCoords(diff_MASK,PEAK_CDR_DIFF)

;-----------------------------------------------------------------
plot1=new(3,graphic)
plot2=new(3,graphic)
wks  = gsn_open_wks("png",dir3+"CHL_map_BOX_region__AVG_PEAK_diff_30_years")
res                     = True
res@lbLabelBarOn               = False
res@mpProjection="Robinson"
res@mpPerimOn              = False
res@lbBoxEndCapStyle           = "TriangleBothEnds"
res@lbOrientation              = "Horizontal"        ; orientation
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn           = False
res@cnLineLabelsOn      = False
res@gsnLeftString=""
res@mpLandFillColor    =   "white"
res@gsnRightString=""
res@gsnCenterStringFontHeightF= 0.035
res@gsnCenterStringOrthogonalPosF=0.1
res@tiXAxisString=""
;res@tmXBLabelFontHeightF   =       0.025
;res@tmYLLabelFontHeightF   =       0.025
;res@tmXBLabelStride     =       2
;res@tmYLLabelStride     =       2
res@mpCenterLonF       =       180
res@cnLevelSelectionMode   =       "ManualLevels"
res2	=	res
sres	=	res

res2@cnMaxLevelValF         =      0.1
res2@cnMinLevelValF         =      -0.1
res2@cnLevelSpacingF        =       0.02
res2@cnFillPalette ="CBR_coldhot"
res2@gsnCenterString="Diff (Peak - 1pctCO2)"
plot1(0)=gsn_csm_contour_map(wks,peak_diff_mean,res2)
res2@gsnCenterString="Diff (Peak - 1pctCO2_cdr)"
plot1(1)=gsn_csm_contour_map(wks,peak_cdr_diff_mean,res2)
res2@gsnCenterString="Diff (1pctCO2_cdr - 1pctCO2)"
plot1(2)=gsn_csm_contour_map(wks,diff_mean,res2)

sres@cnConstFEnableFill    =   True
sres@cnMonoFillColor   =   True
sres@cnFillColor       =   "black"
sres@cnFillOn              =       True
sres@cnMonoFillPattern =   True
sres@cnFillScaleF      =   1   
sres@cnFillPattern     =   17  
sres@cnLinesOn             =       False
sres@cnLevelSelectionMode = "ExplicitLevels"
sres@cnLevels = (/0.,3/)
sres@cnInfoLabelOn = False
sres@tiMainOn = False
sres@gsnCenterString   = ""
sres@lbLabelBarOn      =   False
sres@cnFillDotSizeF=0.0025
sres@cnConstFLabelOn=False
sres@trGridType="TriangularMesh"

opt            =   True
opt@gsnShadeHigh         = 17
opt@gsnShadeFillType     = "pattern"
opt@gsnShadeFillScaleF   = 0.5 
opt@gsnShadeFillDotSizeF = 0.06

plot2(0)=gsn_csm_contour(wks,PEAK_DIFF,sres)
plot2(0)=ShadeGtContour(plot2(0),2,17)
plot2(1)=gsn_csm_contour(wks,PEAK_CDR_DIFF,sres)
plot2(1)=ShadeGtContour(plot2(1),2,17)
plot2(2)=gsn_csm_contour(wks,DIFF,sres)
plot2(2)=ShadeGtContour(plot2(2),2,17)

 do d=0,2
  overlay(plot1(d),plot2(d))
 end do
;--------EQ-----
ypts = (/-10,-10, 10,10,-10/)
xpts = (/140,270,270,140,140/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 8.0                       ; thickness of lines
resp@gsLineDashPattern= 0
resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(1,graphic)
dum2=gsn_add_polyline(wks,plot2(0),xpts,ypts,resp)
dum22=gsn_add_polyline(wks,plot2(1),xpts,ypts,resp)
dum222=gsn_add_polyline(wks,plot2(2),xpts,ypts,resp)
;-------NP---------------
ypts = (/30,30, 40,40,30/)
xpts = (/140,220,220,140,140/)
dum = new(1,graphic)
dum3 = new(1,graphic)
dum=gsn_add_polyline(wks,plot2(0),xpts,ypts,resp)
dum3=gsn_add_polyline(wks,plot2(1),xpts,ypts,resp)
dum33=gsn_add_polyline(wks,plot2(2),xpts,ypts,resp)
;---------NA---------------------------
ypts = (/40,40, 70,70,40/)
xpts = (/300,350,350,300,300/)
dum1 = new(1,graphic)
dum4 = new(1,graphic)
dum1=gsn_add_polyline(wks,plot2(0),xpts,ypts,resp)
dum4=gsn_add_polyline(wks,plot2(1),xpts,ypts,resp)
dum5=gsn_add_polyline(wks,plot2(2),xpts,ypts,resp)
;---------AO---------------------------
;ypts = (/-75,-75, -50,-50,-75/)
;xpts = (/0,360,360,0,0/)
;dum111=gsn_add_polyline(wks,plot2(0),xpts,ypts,resp)
;dum1111=gsn_add_polyline(wks,plot2(1),xpts,ypts,resp)
;dum11111=gsn_add_polyline(wks,plot2(2),xpts,ypts,resp)

nlon2 = toint(Nlon*1./3.)  ; this gives us two extra longitude
nlon3 = toint(Nlon*2./3.)  ; points to plot for each latitude line.
dum111  = new(2,graphic)
lon_vals = (/lon(0),lon(nlon2),lon(nlon3),lon(Nlon-1)/)
lat_vals = (/-50,-50,-50,-50/)
dum111 = gsn_add_polyline(wks,plot2(0),lon_vals,lat_vals,resp)
dum1111 = gsn_add_polyline(wks,plot2(1),lon_vals,lat_vals,resp)
dum11111 = gsn_add_polyline(wks,plot2(2),lon_vals,lat_vals,resp)
lat_vals = (/-75,-75,-75,-75/)
dum2222 = gsn_add_polyline(wks,plot2(0),lon_vals,lat_vals,resp)
dum22222 = gsn_add_polyline(wks,plot2(1),lon_vals,lat_vals,resp)
dum22223 = gsn_add_polyline(wks,plot2(2),lon_vals,lat_vals,resp)

pres2                       =   True
pres2@gsnFrame         = False
pres2@gsnPanelMainString=""
;pres2@gsnPanelBottom=0.05
;pres2@gsnPanelTop=0.6
pres2@gsnPanelLeft=0.05
pres2@gsnPanelRight=0.95
pres2@gsnPanelLabelBar      = True
pres2@gsnMaximize        =       False
pres2@gsnPanelYWhiteSpacePercent = 1
pres2@pmLabelBarWidthF = 0.8 ; label bar width
pres2@pmLabelBarOrthogonalPosF=0.005
pres2@lbLabelFontHeightF=0.01
pres2@pmLabelBarHeightF = 0.05
pres2@lbTitleString="mg/m~S~3~N"
pres2@lbTitleFontHeightF=0.012
pres2@lbTitlePosition="Bottom"
gsn_panel(wks,plot1,(/1,3/),pres2)

frame(wks)

end
