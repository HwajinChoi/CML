#!/bin/bash

for h in "500" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
case=(/1994,1995,2001,2006,2010,2012,2016,2018,2020,2022/)
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc") ; 1991-2022 
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

dim=dimsizes(hgt)
hgt2=new((/10,dim(1),dim(2),dim(3)/),"float")

do i=0,9
 hgt2(i,:,:,:)=hgt(case(i)-1991,:,:,:)
end do

hgt3=dim_avg_n_Wrap(hgt2,0)

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)
;------------------ For Case (Contour)----------------------
hgt_6=dim_avg_n_Wrap(hgt3(31:60,:,:),0)
hgt_7=dim_avg_n_Wrap(hgt3(61:91,:,:),0)
hgt_8=dim_avg_n_Wrap(hgt3(92:122,:,:),0)

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
hgt_clim_for_ano=new((/10,dim(1),dim(2),dim(3)/),"float")
 do i=0,9
  hgt_clim_for_ano(i,:,:,:)=hgt_clim
 end do
hgt_clim_for_ano!0="case"
ANO=hgt2-hgt_clim_for_ano
copy_VarMeta(hgt,ANO)
ANO!0="case"
ANO2=dim_avg_n_Wrap(ANO,0)
;-------For ANO MAP--------------------------------------------------------------------
ANO_6=dim_avg_n_Wrap(ANO2(31:60,:,:),0)
ANO_7=dim_avg_n_Wrap(ANO2(61:91,:,:),0)
ANO_8=dim_avg_n_Wrap(ANO2(92:122,:,:),0)
y5=ispan(6,148,1)
;---------------------------------------------------------------------------

wks = gsn_open_wks("png",dir2+"HGT_Map_1991-2022_CLIM_${h}")
plot=new(3,"graphic")
plot1=new(3,"graphic")
plot2=new(3,"graphic")
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
res@cnMaxLevelValF         =      50 
res@cnMinLevelValF         =      -50
res@cnLevelSpacingF        =       5
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
plot(0)=gsn_csm_contour_map(wks,ANO_6,res)
res@gsnCenterString="July"
plot(1)=gsn_csm_contour_map(wks,ANO_7,res)
res@gsnCenterString="August"
plot(2)=gsn_csm_contour_map(wks,ANO_8,res)

ypts = (/31,31, 43,43,31/)
xpts = (/117,137,137,117,117/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 6.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(3,graphic)
 do I=0,2
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
plot1(1)=gsn_csm_contour(wks,hgt_clim_7,res3)
plot1(2)=gsn_csm_contour(wks,hgt_clim_8,res3)

plot2(0)=gsn_csm_contour(wks,hgt_6,res4)
plot2(1)=gsn_csm_contour(wks,hgt_7,res4)
plot2(2)=gsn_csm_contour(wks,hgt_8,res4)

 do J=0,2
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
 gsn_text_ndc(wks,"H500",0.052,0.52,txres)
 gsn_text_ndc(wks,"(m)",0.94,0.38,txres)
 
 txres@txFontHeightF = 0.02                     ; text font height
 ;gsn_text_ndc(wks,"North Pacific high (500hpa)",0.55,0.87,txres)

 txres@txFontHeightF = 0.025                     ; text font height
  dum = new(3,graphic)
  dum(0) = gsn_add_text(wks,plot(0),"5850",158,28,txres)
  dum(1) = gsn_add_text(wks,plot(1),"5850",160,35,txres)
  dum(2) = gsn_add_text(wks,plot(2),"5850",160,35,txres)

 txres@txFontColor="green"
  dum1 = new(3,graphic)
  dum1(0) = gsn_add_text(wks,plot(0),"5850",160,36,txres)
  dum1(1) = gsn_add_text(wks,plot(1),"5850",170,42,txres)
  dum1(2) = gsn_add_text(wks,plot(2),"5850",110,41,txres)

 gsn_panel(wks,plot,(/1,3/),pres)
 frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
exit
done
