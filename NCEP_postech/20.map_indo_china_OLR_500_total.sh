#!/bin/bash

#----------------------------------------------------------
# India => 70-80E, 20-30N
# South China Sea => 105-130E, 15-25N
#----------------------------------------------------------

for h in "500" ;do
dir1=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/specific
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/for_clim
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/spec_6_9
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/clim_6_9

cat > imsi.ncl << EOF
begin
;---------------------------------
;indo=OLR(:,:,{20:30},{70:80})
;china=OLR(:,:,{15:25},{105:130})
;---------------------------------

C=5850
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
;-------------------------------------------------------------------
h=addfile("${dir3}/OLR_MAP_11moving_2016_2018_2020_June_Sep.nc","r")
olr=h->orl ; case x time x lat x lon 
olr=olr*(-1)

;-------------------------------------------------------------------
files=systemfunc("ls ${dir1}/hgt.${h}.*.nc") ; 2016, 2018, 2020
gfiles=systemfunc("ls ${dir1}/hgt.${h}.*.nc | head -1")
f=addfiles(files,"r")
g=addfile(gfiles,"r")
lat=g->lat({43:31})
lon=g->lon({117:137})
time=g->time
P=0.4
per=flt2string(P)
;----------CHANGE!! ------
;---------------------------------------------------------------------------
ListSetType(f,"join")
hgt_1=f[:]->hgt
hgt=hgt_1(:,:,0,{43:31},{117:137}); year x time x level x lat x lon (117-137°E, 31-43°N)

hgt_mask=where(hgt .ge. C, 1,0)
;----------CHANGE!! ------

copy_VarMeta(hgt,hgt_mask)
test=dim_sum_n_Wrap(hgt_mask,2)
hgt_count=dim_sum_n_Wrap(test,2)
hgt_count2=int2flt(hgt_count)
hgt_count2 := hgt_count2/40.

t=cd_calendar(time,1)
yfrac = yyyymm_to_yyyyfrac(t,0)
y=ispan(1,153,1)
;----- 11 days moving; 2016, 2018, 2020-------------------------------------------------------------
p=11;chunck period
tp=153-p+1;total period after moving averaged
hgt_mv_11=new((/3,tp/),"float"); Target
imsi=new((/3,p/),"float"); Chunck

do k=0,tp-1
  imsi(:,:)=hgt_count2(:,k:k+p-1)
  hgt_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
  imsi=imsi@_FillValue
 end do

hgt_mv_11!0="case"
hgt_mv_11!1="time"

;----- FOR CORR -----------------------
hgt_mv_11_7_9=hgt_mv_11(:,56:142)
OLR_cases_7_9=olr(:,25:111,:,:)
dim=dimsizes(OLR_cases_7_9)

;;;; *hgt_mv_11*(3 case), hgt_mv_11_CLIM ;;;;;; 
hgt_masking=where(hgt_mv_11_7_9 .ge. P,1,hgt_mv_11_7_9@_FillValue)
copy_VarMeta(hgt_mv_11,hgt_masking)
Masking=new((/dim(0),dim(1),dim(2),dim(3)/),"float")

do j=0,dim(3)-1
 do i=0,dim(2)-1
 Masking(:,:,i,j)=where(hgt_mv_11_7_9 .ge. P,OLR_cases_7_9(:,:,i,j),OLR_cases_7_9@_FillValue)
 end do
end do
copy_VarMeta(OLR_cases_7_9,Masking)

Masking2=dim_avg_n_Wrap(Masking,1)

;;; *TAS_mv_11_cases*; case 3 x year 112 (6_9)

YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)
;printMinMax(Masking2,0)
;exit
;---------------------------------------------------------------------------
 wks = gsn_open_wks("png",dir2+"MAP_OLR_criteria_specific_years_${h}_"+per)

plot=new(3,"graphic")
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
res@gsnCenterStringOrthogonalPosF=0.1
res@mpMaxLatF=70
res@mpMinLatF=-10
res@mpMinLonF=40
res@mpMaxLonF=220
res@mpCenterLonF=180
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      -150 
res@cnMinLevelValF         =      -350
res@cnLevelSpacingF        =       10 
res@cnFillPalette          =       "BlueDarkRed18"
res@gsnMaximize        =       True
res@gsnLeftString        =   ""
res@lbLabelFontHeightF  = 0.015
res@lbLabelStride     =   2
res@pmLabelBarWidthF=0.6
res@pmLabelBarHeightF=0.05
;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
res@gsnCenterString=YEAR(0)
res@gsnCenterStringFontHeightF=0.045
plot(0)=gsn_csm_contour_map(wks,Masking2(0,:,:),res)
res@gsnCenterString=YEAR(1)
plot(1)=gsn_csm_contour_map(wks,Masking2(1,:,:),res)
res@gsnCenterString=YEAR(2)
plot(2)=gsn_csm_contour_map(wks,Masking2(2,:,:),res)
;------------India-------------
ypts = (/20,20, 30,30,20/)
xpts = (/70,80,80,70,70/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "black"                     ; color of lines
resp@gsLineThicknessF = 6.0                       ; thickness of lines
resp@gsLineDashPattern= 0
;resp@tfPolyDrawOrder   =   "PostDraw"
dum2 = new(3,graphic)
 do I=0,2
  dum2(I)=gsn_add_polyline(wks,plot(I),xpts,ypts,resp)
 end do
;-------------China--------------
ypts = (/15,15,25 ,25,15/)
xpts = (/105,130,130,105,105/)
dum3 = new(3,graphic)
 do I=0,2
  dum3(I)=gsn_add_polyline(wks,plot(I),xpts,ypts,resp)
 end do

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =      True 
pres@gsnPanelYWhiteSpacePercent = 7 
pres@lbLabelFontHeightF  = 0.015
pres@lbLabelStride     =   2   
;pres@gsnPanelLeft  =0.1
pres@pmLabelBarOrthogonalPosF=-0.03
pres@pmLabelBarHeightF=0.08
pres@pmLabelBarWidthF=0.7
txres               = True                      ; text mods desired
txres@txFontHeightF = 0.016 
gsn_text_ndc(wks,"W/m~S~2~N~",0.89,0.365,txres)
gsn_panel(wks,plot,(/1,3/),pres)
frame(wks)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done
