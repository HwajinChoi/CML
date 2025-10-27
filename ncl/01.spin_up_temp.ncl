begin
dir1="/media/cmlws/Data2/hjc/imsi/"
dir2="/media/cmlws/Data2/hjc/image/"

f=addfile(dir1+"ORCA2_000101_025112_100-200m_grid_T_thetao.nc","r")
g=addfile(dir1+"ORCA2_000101_025112_200-300m_grid_T_thetao.nc","r")
h=addfile(dir1+"ORCA2_000101_025112_300-600m_grid_T_thetao.nc","r")
k=addfile(dir1+"ORCA2_000101_025112_600-1100m_grid_T_thetao.nc","r")

thetao1=f->thetao
thetao2=g->thetao
thetao3=h->thetao
thetao4=k->thetao

thetao1_1=dim_avg_n_Wrap(thetao1,1)
thetao2_1=dim_avg_n_Wrap(thetao2,1)
thetao3_1=dim_avg_n_Wrap(thetao3,1)
thetao4_1=dim_avg_n_Wrap(thetao4,1)

t1=dim_avg_n_Wrap(thetao1_1,1)
t2=dim_avg_n_Wrap(thetao2_1,1)
t3=dim_avg_n_Wrap(thetao3_1,1)
t4=dim_avg_n_Wrap(thetao4_1,1)
x=ispan(0,3011,1)

wks = gsn_open_wks("png",dir2+"spin_up_100-1100m")  
plot   = new(4,graphic)
res              = True                     ; plot mods desired
res@gsnMaximize  = True
res@gsnDraw      = False                    ; Turn off draw and frame so
res@gsnFrame     = False                    ; we can attach some text.
res@xyLineThicknessF = 1
res@trXMinF=0
res@trXMaxF=3011
res@tiYAxisString="Temperature"
res@tiXAxisString="Month"
res@gsnCenterStringFontHeightF=0.025

res@trYMinF      = min(t1)-0.01           ; Set min/max of left Y axis
res@trYMaxF      = max(t1)+0.01
res@gsnCenterString="100 - 200m"
plot(0)=gsn_csm_xy(wks,x,t1,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t2)-0.01           ; Set min/max of left Y axis
res@trYMaxF      = max(t2)+0.01
res@gsnCenterString="200 - 300m"
plot(1)=gsn_csm_xy(wks,x,t2,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t3)-0.01           ; Set min/max of left Y axis
res@trYMaxF      = max(t3)+0.01
res@gsnCenterString="300 - 600m"
plot(2)=gsn_csm_xy(wks,x,t3,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t4)-0.01           ; Set min/max of left Y axis
res@trYMaxF      = max(t4)+0.01
res@gsnCenterString="600 - 1100m"
plot(3)=gsn_csm_xy(wks,x,t4,res)

pres              = True
pres@gsnMaximize  = True
pres@gsnPanelXWhiteSpacePercent =3
pres@gsnPanelYWhiteSpacePercent =5
gsn_panel(wks,plot,(/2,2/),pres)

end
