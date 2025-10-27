begin
dir1="/media/cmlws/Data2/hjc/imsi/"
dir2="/media/cmlws/Data2/hjc/image/"

f=addfile(dir1+"ORCA2_000101_035012_0-100m_grid_T_thetao.nc","r")
g=addfile(dir1+"ORCA2_000101_035012_0-200m_grid_T_thetao.nc","r")
h=addfile(dir1+"ORCA2_000101_035012_0-300m_grid_T_thetao.nc","r")

thetao1=f->thetao
thetao2=g->thetao
thetao3=h->thetao

thetao1_1=dim_avg_n_Wrap(thetao1,1)
thetao2_1=dim_avg_n_Wrap(thetao2,1)
thetao3_1=dim_avg_n_Wrap(thetao3,1)

t1=dim_avg_n_Wrap(thetao1_1,1)
t2=dim_avg_n_Wrap(thetao2_1,1)
t3=dim_avg_n_Wrap(thetao3_1,1)

T1=month_to_annual(t1,1)
T2=month_to_annual(t2,1)
T3=month_to_annual(t3,1)
x=ispan(0,649,1)

a=addfile(dir1+"spin_up_1960_1y_0-100m_03510101_07001231_thetao.nc","r")
b=addfile(dir1+"spin_up_1960_1y_0-200m_03510101_07001231_thetao.nc","r")
c=addfile(dir1+"spin_up_1960_1y_0-300m_03510101_07001231_thetao.nc","r")

thetao111=a->thetao
thetao222=b->thetao
thetao333=c->thetao

thetao11=dim_avg_n_Wrap(thetao111,1)
thetao22=dim_avg_n_Wrap(thetao222,1)
thetao33=dim_avg_n_Wrap(thetao333,1)

t11=dim_avg_n_Wrap(thetao11,1)
t22=dim_avg_n_Wrap(thetao22,1)
t33=dim_avg_n_Wrap(thetao33,1)
t11!0="year"
t22!0="year"
t33!0="year"

T111=new(650,"float")
T111(0:349)=T1
T111(350:649)=t11

T222=new(650,"float")
T222(0:349)=T2
T222(350:649)=t22

T333=new(650,"float")
T333(0:349)=T3
T333(350:649)=t33

wks = gsn_open_wks("png",dir2+"spin_up_0-100m_0-200m_0-300m_1960spin_up")  
plot   = new(3,graphic)
res              = True                     ; plot mods desired
res@gsnMaximize  = True
res@gsnDraw      = False                    ; Turn off draw and frame so
res@gsnFrame     = False                    ; we can attach some text.
res@xyLineThicknessF = 2
res@trXMinF=0
res@trXMaxF=650
res@tiYAxisString="Temperature"
res@tiXAxisString="Year"
res@gsnCenterStringFontHeightF=0.025

res@trYMinF      = min(t1)-0.1           ; Set min/max of left Y axis
res@trYMaxF      = max(t1)+0.1
res@gsnCenterString="0 - 100m"
plot(0)=gsn_csm_xy(wks,x,T111,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t2)-0.1           ; Set min/max of left Y axis
res@trYMaxF      = max(t2)+0.1
res@gsnCenterString="0 - 200m"
plot(1)=gsn_csm_xy(wks,x,T222,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t3)-0.1           ; Set min/max of left Y axis
res@trYMaxF      = max(t3)+0.1
res@gsnCenterString="0 - 300m"
plot(2)=gsn_csm_xy(wks,x,T333,res)

pres              = True
pres@gsnMaximize  = True
pres@gsnPanelXWhiteSpacePercent =3
gsn_panel(wks,plot,(/1,3/),pres)

end
