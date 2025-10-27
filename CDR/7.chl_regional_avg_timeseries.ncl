begin
dir1="/media/cmlws/Data1/hjc/CDR/data/1pctCO2/chl/surf/regrid/"
dir2="/media/cmlws/Data1/hjc/CDR/data/1pctCO2_cdr/chl/surf/regrid/"
dir3="/media/cmlws/Data1/hjc/CDR/data/1pctCO2_cdr/chl_end_60/surf/regrid/"
dir4="/media/cmlws/Data1/hjc/CDR/image/"

m=(/"ACCESS-ESM1-5","CanESM5","CESM2","CNRM-ESM2-1","GFDL-ESM4","MIROC-ES2L","NorESM2-LM","UKESM1-0-LL"/)

files=systemfunc("ls "+dir1+"chl_*.nc")
 file1=systemfunc("ls "+dir1+"chl_*.nc | head -1")
gfiles=systemfunc("ls "+dir2+"chl_*.nc")
hfiles=systemfunc("ls "+dir3+"chl_*.nc")

f=addfiles(files,"r")
ListSetType(f,"join")
chl=f[:]->chl
g=addfiles(gfiles,"r")
ListSetType(g,"join")
chl_cdr=g[:]->chl
h=addfiles(hfiles,"r")
ListSetType(h,"join")
chl_cdr_end=h[:]->chl
dim=dimsizes(chl);model*time*lev*lat*lon

f1=addfile(file1,"r")
lat=f1->lat
lon=f1->lon

CHL=new((/dim(0),340,dim(3),dim(4)/),"float")
CHL(:,0:139,:,:)=chl(:,:,0,:,:)
CHL(:,140:279,:,:)=chl_cdr(:,:,0,:,:)
CHL(:,280:339,:,:)=chl_cdr_end(:,:,0,:,:)
CHL!0="model" ; model*time*lat*lon
;-----------------------------------------
res=True
;---------AO---------------------------
;;;;;;;;ypts = (/-75,-75, -50,-50,-75/)
;;;;;;;;xpts = (/0,360,360,0,0/)
;Region="AO"
;CHL2=CHL(:,:,{-75:-50},:)
;lat := lat({-75:-50})
;res@trYMinF            = 0.05              ; set x-axis minimum
;res@trYMaxF            = 0.6
;---------NA---------------------------
;;;;;;;;;ypts = (/40,40, 70,70,40/)
;;;;;;;;;xpts = (/300,350,350,300,300/)
;Region="NA"
;CHL2=CHL(:,:,{40:70},{300:350})
;lat := lat({40:70})
;res@trYMinF            = 0.0              ; set x-axis minimum
;res@trYMaxF            = 0.9
;---------NP---------------
;;;;;;;;ypts = (/30,30, 40,40,30/)
;;;;;;;;xpts = (/140,220,220,140,140/)
;Region="NP"
;CHL2=CHL(:,:,{30:40},{140:220})
;lat := lat({30:40})
;res@trYMinF            = 0.0              ; set x-axis minimum
;res@trYMaxF            = 0.5
;--------EQ-----
;;;;;;;;;;ypts = (/-10,-10, 10,10,-10/)
;;;;;;;;;;xpts = (/140,270,270,140,140/)
Region="EQ"
CHL2=CHL(:,:,{-10:10},{140:270})
lat := lat({-10:10})
res@trYMinF            = 0.1              ; set x-axis minimum
res@trYMaxF            = 0.65
;-----------------------------------------
;-----------------------------------------
rad    = 4.0*atan(1.0)/180.0
re     = 6371220.0
rr     = re*rad
clat   = cos(lat*rad)
CHL_arg = wgt_areaave_Wrap(CHL2, clat, 1.0, 1)
;----------- For moving average ------------------------------------
y=5 ; moving year
tp=340-y+1;total period after moving averaged 
;----------------------------------area average------------------------------------------------
CHL_mv=new((/8,tp/),"float"); Target
imsi=new((/8,5/),"float"); Chunck 
 do k=0,tp-1
  imsi(:,:)=CHL_arg(:,k:k+y-1)
  CHL_mv(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do
CHL_mv!1="time"
;-----------------------------------------------
CHL_mv=CHL_mv*10^6
CHL_arg=CHL_arg*10^6
CHL_mv(3,:)=CHL_mv(3,:)/(10^3)
CHL_arg(3,:)=CHL_arg(3,:)/(10^3)
CHL_ARG=dim_avg_n_Wrap(CHL_arg,0)
CHL_MV=dim_avg_n_Wrap(CHL_mv,0)
;-----------------------------------------------
x1=ispan(1,340,1)
x2=ispan(1,336,1)
Colors = (/"Red","Orange","gold","Navy","Blue","Green","Purple","gray50"/) ; colors chosen

  wks = gsn_open_wks("png",dir4+"CHL_avg_timeseries_annual_5moving_340years_"+Region)             ; send graphics to PNG file
  plot=new(2,graphic)
  plot0=new(2,graphic)
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet
  res@vpHeightF          = 0.4               ; change aspect ratio of plot
  res@vpWidthF           = 0.7
  res@trXMaxF            = 340
  res@trXMinF            = 1              ; set x-axis minimum
  ;res@gsnLeftStringOrthogonalPosF=0.05
  res@gsnLeftStringFontHeightF=0.023
  res@gsnRightStringFontHeightF=0.023
;  res@tmYLMode           = "Manual"
;  res@tmYLTickSpacingF   =  5
;  res@tmYLTickStartF     =  65
;  res@tmYLTickEndF       = 90
;  res@tmYLMinorPerMajor=4
;---------For anomaly----------
  res@gsnXRefLine       =(/140,280/) 
;  res@gsnYRefLineColor = "gray50"
  res@gsnXRefLineDashPattern=1
;-------------------------------
  res2=res
  res@xyMonoLineColor    = False             ; want colored lines
  res@xyLineColors       = Colors 
  res@xyLineThicknesses  = (/3,3,3,3,3,3.,3.,3./)      ; line thicknesses
  res@xyDashPatterns     = (/0,0,0,0,0,0.,0.,0./)      ; make all lines solid
  res@tiYAxisString      = "mg/m~S~3~N"      ; add an axis title    
  res@tiXAxisString      = "year"      ; add an axis title    
  res@tiYAxisAngleF=90
  res@txFontHeightF      = 0.0195            ; change title font heights
;  res@tmXBMode          = "Explicit"
;  res@tmXBValues        = year
;  res@tmXBLabels        = year
  res@tiMainString=""
  res@gsnLeftString              = "Annual"
  res@gsnRightString              = Region
  plot(0) = gsn_csm_xy (wks,x1,CHL_arg,res)       ; create line plot
  res@trXMaxF            = 336
  res@gsnLeftString              = " 5 years moving"
  plot(1) = gsn_csm_xy (wks,x2,CHL_mv,res)       ; create line plot
  res2@gsnLeftString              = ""
  res2@xyLineColor       = "black" 
  res2@xyLineThicknessF  = 5
  res2@xyDashPattern     = 1
  plot0(0)=gsn_csm_xy (wks,x1,CHL_ARG,res2)
  res2@trXMaxF            = 336
  plot0(1)=gsn_csm_xy (wks,x2,CHL_MV,res2)
  overlay(plot(0),plot0(0))
  overlay(plot(1),plot0(1))

  gres = True
  gres@YPosPercent = 90.    ; expressed as %, 0->100, sets position of top border of legend 
  gres@XPosPercent = 75      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres = True
  lineres@lgLineColors = Colors
  lineres@lgLineThicknesses = 5                       ; line thicknesses
  lineres@LineLengthPercent = 5.                         ; expressed as %, 0->100, length of line
  lineres@lgMonoLineLabelFontHeight=False
  lineres@lgLineLabelFontHeights   = 0.012
  textres = True
  textres@lgLabels = m
;  plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

  pres                       =   True
  pres@gsnFrame         = False
  pres@gsnPanelMainString=""
; pres@gsnPanelBottom=0.1
  pres@gsnPanelRight=0.80
  pres@gsnMaximize        =       False
  pres@gsnPanelYWhiteSpacePercent = 2
  gsn_panel(wks,plot,(/2,1/),pres)
  simple_legend_ndc(wks, gres, lineres, textres)
  gres@YPosPercent = 40.    ; expressed as %, 0->100, sets position of top border of legend 
  simple_legend_ndc(wks, gres, lineres, textres)
  frame(wks)

end
