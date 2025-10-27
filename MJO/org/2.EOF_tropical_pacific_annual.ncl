begin
dir1="/media/cmlws/Data2/hjc/MJO/data/on/"
dir2="/media/cmlws/Data2/hjc/MJO/data/off/"
dir3="/media/cmlws/Data2/hjc/MJO/image/"

lat_s=-20
lat_f=20
lon_s=100
lon_f=300

f=addfile(dir1+"tos_0_360_200001-201912.nc","r")
tos_on_0_imsi=f->tos
tos_on_0=month_to_annual(tos_on_0_imsi,1)
tos_on_clim=dim_avg_n_Wrap(tos_on_0,0)
g=addfile(dir2+"tos_0_360_200001-201912.nc","r")
tos_off_0_imsi=g->tos
tos_off_0=month_to_annual(tos_off_0_imsi,1)

tos_off_clim=dim_avg_n_Wrap(tos_off_0,0)
dim0=dimsizes(tos_on_0)
tos_on_ano=new((/dim0(0),dim0(1),dim0(2)/),typeof(tos_on_0))
tos_off_ano=new((/dim0(0),dim0(1),dim0(2)/),typeof(tos_on_0))

do i=0,dim0(0)-1
 tos_on_ano(i,:,:)=tos_on_0(i,:,:)-tos_on_clim
 tos_off_ano(i,:,:)=tos_off_0(i,:,:)-tos_off_clim
end do
copy_VarMeta(tos_on_0,tos_on_ano)
copy_VarMeta(tos_off_0,tos_off_ano)

tos_on_1=dtrend_n(tos_on_ano,False,0)
tos_off_1=dtrend_n(tos_off_ano,False,0)
copy_VarMeta(tos_on_0,tos_on_1)
copy_VarMeta(tos_off_0,tos_off_1)

tos_on=tos_on_1(:,{lat_s:lat_f},{lon_s:lon_f})
tos_off=tos_off_1(:,{lat_s:lat_f},{lon_s:lon_f})
;----------------------------------------------
neof   = 3        ; number of EOFs
optEOF = True
optEOF@jopt = 0
optETS = False
;----------------------------------------------
tos_on_eof      = eofunc_n_Wrap(tos_on, neof, optEOF,0)
tos_on_eof_ts   = eofunc_ts_n_Wrap (tos_on, tos_on_eof, optETS,0)
dim=dimsizes(tos_on_eof)
dim1=dimsizes(tos_on_eof_ts)

TOS_on_eof=new((/dim(0),dim(1),dim(2)/),typeof(tos_on_eof))
TOS_on_eof=tos_on_eof*(-1)
copy_VarMeta(tos_on_eof,TOS_on_eof)

TOS_on_eof_ts=new((/dim1(0),dim1(1)/),typeof(tos_on_eof_ts))
TOS_on_eof_ts=tos_on_eof_ts*(-1)

tos_off_eof      = eofunc_n_Wrap(tos_off, neof, optEOF,0)
tos_off_eof_ts   = eofunc_ts_n_Wrap (tos_off, tos_off_eof, optETS,0)

TOS_off_eof=new((/dim(0),dim(1),dim(2)/),typeof(tos_off_eof))
TOS_off_eof(0:1,:,:) = tos_off_eof(0:1,:,:)*(-1)
TOS_off_eof(2,:,:)=tos_off_eof(2,:,:)

TOS_off_eof_ts=new((/dim1(0),dim1(1)/),typeof(tos_off_eof_ts))
TOS_off_eof_ts(0:1,:)=tos_off_eof_ts(0:1,:)*(-1)
TOS_off_eof_ts(2,:)=tos_off_eof_ts(2,:)


system("rm -f "+dir1+"COBALT_annual_EOF_Tropical_Pacific_PC_timeseries_on_off.nc")
out=addfile(    dir1+"COBALT_annual_EOF_Tropical_Pacific_PC_timeseries_on_off.nc","c")
out->tos_on_eof_ts=TOS_on_eof_ts
out->tos_off_eof_ts=TOS_off_eof_ts
exit

plot=new(6,graphic)
wks=gsn_open_wks("png",dir3+"EOF_annual_tropical_pacific_on_off")
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@gsnAddCyclic         = False        ; data not cyclic
res@cnFillPalette        = "BlueDarkRed18"
res@mpCenterLonF         = 180.         ; defailt is 0 [GM]
res@mpMinLatF            = lat_s
res@mpMaxLatF            = lat_f
res@mpMinLonF            = lon_s
res@mpMaxLonF            = lon_f
res@cnLineLabelsOn         =       False
;res@cnLevelSelectionMode   =       "ManualLevels"
;res@cnMaxLevelValF         =      0.04
;res@cnMinLevelValF         =      -0.04
;res@cnLevelSpacingF        =       0.005
res@mpFillDrawOrder      = "PostDraw"
res@cnFillOn             = True         ; turn on color fill
res@cnLinesOn            = False         ; True is default
res@lbLabelBarOn         = True        ; turn off individual lb's
res@mpLandFillColor      = "black"
res@tmXBLabelFontHeightF   =       0.02
res@tmYLLabelFontHeightF   =       0.02
;res@tmYLMinorPerMajor=1
res@gsnLeftStringFontHeightF=0.028
res@gsnRightStringFontHeightF=0.025
res@tmYLLabelStride     =       2
res@pmLabelBarOrthogonalPosF=0.35

; panel plot only resources
resP                     = True         ; modify the panel plot
resP@gsnMaximize         = True         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
resP@lbLabelFontHeightF  = 0.012
resP@gsnPanelYWhiteSpacePercent = 7
resP@pmLabelBarWidthF=0.75
;resP@gsnPanelLeft=0.12
resP@gsnPanelMainString  = ""

res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =      0.02
res@cnMinLevelValF         =      -0.02
res@cnLevelSpacingF        =       0.0025
res@gsnLeftString  ="EOF 1" 
res@gsnRightString = sprintf("%5.1f", TOS_on_eof@pcvar(0)) +"%"
plot(0) = gsn_csm_contour_map(wks,TOS_on_eof(0,:,:),res)
res@gsnRightString = sprintf("%5.1f", TOS_off_eof@pcvar(0)) +"%"
res@gsnLeftString  ="EOF 1" 
plot(1) = gsn_csm_contour_map(wks,TOS_off_eof(0,:,:),res)
res@gsnRightString = sprintf("%5.1f", TOS_off_eof@pcvar(1)) +"%"
res@gsnLeftString  ="EOF 2" 
plot(3) = gsn_csm_contour_map(wks,TOS_off_eof(1,:,:),res)
res@gsnLeftString  ="EOF 2" 
res@gsnRightString = sprintf("%5.1f", TOS_on_eof@pcvar(1)) +"%"
plot(2) = gsn_csm_contour_map(wks,TOS_on_eof(1,:,:),res)
res@cnMaxLevelValF         =      0.03
res@cnMinLevelValF         =      -0.03
res@cnLevelSpacingF        =       0.005
res@gsnRightString = sprintf("%5.1f", TOS_on_eof@pcvar(2)) +"%"
res@gsnLeftString  ="EOF 3" 
plot(4) = gsn_csm_contour_map(wks,TOS_on_eof(2,:,:),res)
res@gsnRightString = sprintf("%5.1f", TOS_off_eof@pcvar(2)) +"%"
res@gsnLeftString  ="EOF 3" 
plot(5) = gsn_csm_contour_map(wks,TOS_off_eof(2,:,:),res)

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.016
gsn_text_ndc(wks,"COBALT On",0.28,0.8,txres1)
gsn_text_ndc(wks,"COBALT Off",0.78,0.8,txres1)

gsn_panel(wks,plot,(/3,2/),resP)     ; draw all 'neof' as one plot

end
