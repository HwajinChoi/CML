begin
dir1="/media/cmlws/Data2/hjc/imsi/"
dir2="/media/cmlws/Data2/hjc/image/"

f=addfile(dir1+"ORCA2_000101_035012_0-50m_grid_T_thetao.nc","r")
g=addfile(dir1+"ORCA2_000101_035012_0-100m_grid_T_thetao.nc","r")

thetao1=f->thetao
thetao2=g->thetao

thetao1_1=dim_avg_n_Wrap(thetao1,1)
thetao2_1=dim_avg_n_Wrap(thetao2,1)

t1=dim_avg_n_Wrap(thetao1_1,1)
t2=dim_avg_n_Wrap(thetao2_1,1)
x=ispan(0,4199,1)

wks = gsn_open_wks("png",dir2+"spin_up_0-100m")  
plot   = new(2,graphic)
res              = True                     ; plot mods desired
res@gsnMaximize  = True
res@gsnDraw      = False                    ; Turn off draw and frame so
res@gsnFrame     = False                    ; we can attach some text.
res@xyLineThicknessF = 1
res@trXMinF=0
res@trXMaxF=4200
res@tiYAxisString="Temperature"
res@tiXAxisString="Month"
res@gsnCenterStringFontHeightF=0.025

res@trYMinF      = min(t1)-0.6           ; Set min/max of left Y axis
res@trYMaxF      = max(t1)+0.6
res@gsnCenterString="0 - 50m"
plot(0)=gsn_csm_xy(wks,x,t1,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t2)-0.6           ; Set min/max of left Y axis
res@trYMaxF      = max(t2)+0.6
res@gsnCenterString="0 - 100m"
plot(1)=gsn_csm_xy(wks,x,t2,res)

pres              = True
pres@gsnMaximize  = True
pres@gsnPanelXWhiteSpacePercent =3
gsn_panel(wks,plot,(/1,2/),pres)

end
