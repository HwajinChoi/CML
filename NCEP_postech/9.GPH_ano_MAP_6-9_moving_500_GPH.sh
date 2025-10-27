#!/bin/bash

for h in "500" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc") ; 2016, 2018, 2020
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat
lon=g->lon
time=g->time
;---------------------------------------------------------------------------
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,:,:); year x time x level x lat x lon (117-137°E, 31-43°N)
hgt!0="case"

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)
dim=dimsizes(hgt)
;------------------ For Case (Contour)----------------------
hgt_6=dim_avg_n_Wrap(hgt(:,31:60,:,:),1)
hgt_7=dim_avg_n_Wrap(hgt(:,61:91,:,:),1)
hgt_8=dim_avg_n_Wrap(hgt(:,92:122,:,:),1)

;----- for Clim-------------------------------------------------------------
files1=systemfunc("ls ${dir2}/hgt.${h}.*.nc")
f1=addfiles(files1,"r")
ListSetType(f1,"join")
hgt_clims=f1[:]->hgt(:,:,0,:,:); year x time x lat x lon 
hgt_clim=dim_avg_n_Wrap(hgt_clims,0);time * lat * lon
;------------------ For Clim (Contour)----------------------
hgt_clim_6=dim_avg_n_Wrap(hgt_clim(31:60,:,:),0)
hgt_clim_7=dim_avg_n_Wrap(hgt_clim(61:91,:,:),0)
hgt_clim_8=dim_avg_n_Wrap(hgt_clim(92:122,:,:),0)
;-------for ano--------------------------------------------------------------------
hgt_clim_for_ano=new((/dim(0),dim(1),dim(2),dim(3)/),"float")
 do i=0,2
  hgt_clim_for_ano(i,:,:,:)=hgt_clim
 end do
hgt_clim_for_ano!0="case"
ANO=hgt-hgt_clim_for_ano
copy_VarMeta(hgt,ANO)
ANO!0="case"
;-------For ANO MAP--------------------------------------------------------------------
ANO_6=dim_avg_n_Wrap(ANO(:,31:60,:,:),1)
ANO_7=dim_avg_n_Wrap(ANO(:,61:91,:,:),1)
ANO_8=dim_avg_n_Wrap(ANO(:,92:122,:,:),1)
y5=ispan(6,148,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"HGT_Map_2016_2018_2020_CLIM_${h}")
plot=new(9,"graphic")
plot1=new(9,"graphic")
plot2=new(9,"graphic")
res   = True
res@gsnDraw            = False             ; don't draw yet
res@gsnFrame           = False             ; don't advance frame yet
res@vpHeightF          = 0.4
res@vpWidthF           = 0.7
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
res@cnLinesOn              =       False
res@cnLineLabelsOn         =       False
res@lbLabelBarOn           =      False
res@tmXBLabelFontHeightF   =       0.025
res@tmYLLabelFontHeightF   =       0.025
res@tmXBLabelStride     =       2   
res@tmYLLabelStride     =       2   
res@gsnRightString=""
;res@mpLandFillColor    =   "black"
res@gsnLeftString=""
res3                    =   res 
res@gsnCenterStringOrthogonalPosF=0.1
res@mpMaxLatF=50
res@mpMinLatF=10
res@mpMinLonF=80
res@mpMaxLonF=180
res@mpCenterLonF=180
res3@gsnRightString=""
res3@gsnLeftString=""
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      100 
res@cnMinLevelValF         =      -100
res@cnLevelSpacingF        =       10
res@cnFillPalette          =       "BlueDarkRed18"
res@gsnMaximize        =       True
res@gsnLeftString        =   ""
res@lbLabelFontHeightF  = 0.015
res@lbLabelStride     =   2
res@pmLabelBarWidthF=0.6
res@pmLabelBarHeightF=0.05
;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
res@gsnCenterString="June"
res@gsnCenterStringFontHeightF=0.045
plot(0)=gsn_csm_contour_map(wks,ANO_6(0,:,:),res)
res@gsnCenterString=""
plot(3)=gsn_csm_contour_map(wks,ANO_6(1,:,:),res)
plot(6)=gsn_csm_contour_map(wks,ANO_6(2,:,:),res)

res@gsnCenterString="July"
plot(1)=gsn_csm_contour_map(wks,ANO_7(0,:,:),res)
res@gsnCenterString=""
plot(4)=gsn_csm_contour_map(wks,ANO_7(1,:,:),res)
plot(7)=gsn_csm_contour_map(wks,ANO_7(2,:,:),res)

res@gsnCenterString="August"
plot(2)=gsn_csm_contour_map(wks,ANO_8(0,:,:),res)
res@gsnCenterString=""
plot(5)=gsn_csm_contour_map(wks,ANO_8(1,:,:),res)
plot(8)=gsn_csm_contour_map(wks,ANO_8(2,:,:),res)

ypts = (/31,31, 43,43,31/)
xpts = (/117,137,137,117,117/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 6.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(9,graphic)
 do I=0,8
  dum2(I)=gsn_add_polyline(wks,plot(I),xpts,ypts,resp)
 end do

res3@cnFillOn            = False
res3@cnInfoLabelOn=False
res3@cnLinesOn              =True
res3@cnLevelSelectionMode = "ExplicitLevels"
res3@cnLineColor="black"
res3@cnLineLabelsOn         =       True
res3@cnLineLabelStrings="5850"
res3@cnLevels = 5850.
res3@cnLineThicknessF=4
res3@cnMonoLevelFlag=True
res3@cnConstFLabelFontHeightF=0.005
res3@cnLineLabelsOn       = True
res4=res3
res4@cnLineColor="green"

txres               = True                      ; text mods desired
txres@txFontHeightF = 0.016                     ; text font height
plot1(0)=gsn_csm_contour(wks,hgt_clim_6,res3)
plot1(3)=gsn_csm_contour(wks,hgt_clim_6,res3)
plot1(6)=gsn_csm_contour(wks,hgt_clim_6,res3)

plot1(1)=gsn_csm_contour(wks,hgt_clim_7,res3)
plot1(4)=gsn_csm_contour(wks,hgt_clim_7,res3)
plot1(7)=gsn_csm_contour(wks,hgt_clim_7,res3)

plot1(2)=gsn_csm_contour(wks,hgt_clim_8,res3)
plot1(5)=gsn_csm_contour(wks,hgt_clim_8,res3)
plot1(8)=gsn_csm_contour(wks,hgt_clim_8,res3)

plot2(0)=gsn_csm_contour(wks,hgt_6(0,:,:),res4)
plot2(3)=gsn_csm_contour(wks,hgt_6(1,:,:),res4)
plot2(6)=gsn_csm_contour(wks,hgt_6(2,:,:),res4)

plot2(1)=gsn_csm_contour(wks,hgt_7(0,:,:),res4)
plot2(4)=gsn_csm_contour(wks,hgt_7(1,:,:),res4)
plot2(7)=gsn_csm_contour(wks,hgt_7(2,:,:),res4)

plot2(2)=gsn_csm_contour(wks,hgt_8(0,:,:),res4)
plot2(5)=gsn_csm_contour(wks,hgt_8(1,:,:),res4)
plot2(8)=gsn_csm_contour(wks,hgt_8(2,:,:),res4)

 do J=0,8
  overlay(plot(J),plot1(J))
  overlay(plot(J),plot2(J))
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
 pres@pmLabelBarWidthF=0.7
 gsn_text_ndc(wks,"2016",0.052,0.72,txres)
 gsn_text_ndc(wks,"2018",0.052,0.52,txres)
 gsn_text_ndc(wks,"2020",0.052,0.32,txres)
 gsn_text_ndc(wks,"(m)",0.94,0.163,txres)
 
 txres@txFontHeightF = 0.02                     ; text font height
 gsn_text_ndc(wks,"North Pacific high (500hpa)",0.55,0.87,txres)

 txres@txFontHeightF = 0.025                     ; text font height
  dum = new(9,graphic)
  dum(0) = gsn_add_text(wks,plot(0),"5850",158,28,txres)
  dum(3) = gsn_add_text(wks,plot(3),"5850",158,28,txres)
  dum(6) = gsn_add_text(wks,plot(6),"5850",158,28,txres)

  dum(1) = gsn_add_text(wks,plot(1),"5850",160,35,txres)
  dum(4) = gsn_add_text(wks,plot(4),"5850",160,35,txres)
  dum(7) = gsn_add_text(wks,plot(7),"5850",160,35,txres)

  dum(2) = gsn_add_text(wks,plot(2),"5850",160,40,txres)
  dum(5) = gsn_add_text(wks,plot(5),"5850",160,35,txres)
  dum(8) = gsn_add_text(wks,plot(8),"5850",160,35,txres)

 txres@txFontColor="green"
  dum1 = new(9,graphic)
  dum1(0) = gsn_add_text(wks,plot(0),"5850",160,36,txres)
  dum1(3) = gsn_add_text(wks,plot(3),"5850",160,37,txres)
  dum1(6) = gsn_add_text(wks,plot(6),"5850",160,37,txres)

  dum1(1) = gsn_add_text(wks,plot(1),"5850",170,42,txres)
  dum1(4) = gsn_add_text(wks,plot(4),"5850",150,42,txres)
  dum1(7) = gsn_add_text(wks,plot(7),"5850",150,40,txres)

  dum1(2) = gsn_add_text(wks,plot(2),"5850",120,20,txres)
  dum1(5) = gsn_add_text(wks,plot(5),"5850",165,42,txres)
  dum1(8) = gsn_add_text(wks,plot(8),"5850",150,42,txres)

 gsn_panel(wks,plot,(/3,3/),pres)
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
