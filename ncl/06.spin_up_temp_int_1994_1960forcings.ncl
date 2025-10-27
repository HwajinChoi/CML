begin
dir1="/media/cmlws/Data2/hjc/imsi/"
dir2="/media/cmlws/Data2/hjc/image/"

x=ispan(0,24,1)

a=addfile(dir1+"spin_up_1960_int_1994_0001_0025_0-100m_thetao.nc","r")
b=addfile(dir1+"spin_up_1960_int_1994_0001_0025_0-200m_thetao.nc","r")
c=addfile(dir1+"spin_up_1960_int_1994_0001_0025_0-300m_thetao.nc","r")
d=addfile(dir1+"spin_up_1960_int_1994_0001_0025_0-600m_thetao.nc","r")
e=addfile(dir1+"spin_up_1960_int_1994_0001_0025_0-1100m_thetao.nc","r")

thetao111=a->thetao
thetao222=b->thetao
thetao333=c->thetao
thetao444=d->thetao
thetao555=e->thetao

thetao11=dim_avg_n_Wrap(thetao111,1)
thetao22=dim_avg_n_Wrap(thetao222,1)
thetao33=dim_avg_n_Wrap(thetao333,1)
thetao44=dim_avg_n_Wrap(thetao444,1)
thetao55=dim_avg_n_Wrap(thetao555,1)

t11=dim_avg_n_Wrap(thetao11,1)
t22=dim_avg_n_Wrap(thetao22,1)
t33=dim_avg_n_Wrap(thetao33,1)
t44=dim_avg_n_Wrap(thetao44,1)
t55=dim_avg_n_Wrap(thetao55,1)

t11!0="year"
t22!0="year"
t33!0="year"
t44!0="year"
t55!0="year"

wks = gsn_open_wks("png",dir2+"NEW_spin_up_int_1994_forcing_1960")  
plot   = new(5,graphic)
res              = True                     ; plot mods desired
res@gsnMaximize  = True
res@gsnDraw      = False                    ; Turn off draw and frame so
res@gsnFrame     = False                    ; we can attach some text.
res@xyLineThicknessF = 2
res@trXMinF=0
res@trXMaxF=25
res@tiYAxisString="Temperature"
res@tiXAxisString="Year"
res@gsnCenterStringFontHeightF=0.025

res@trYMinF      = min(t11)-0.1           ; Set min/max of left Y axis
res@trYMaxF      = max(t11)+0.1
res@gsnCenterString="0 - 100m"
plot(0)=gsn_csm_xy(wks,x,t11,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t22)-0.1           ; Set min/max of left Y axis
res@trYMaxF      = max(t22)+0.1
res@gsnCenterString="0 - 200m"
plot(1)=gsn_csm_xy(wks,x,t22,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t33)-0.1           ; Set min/max of left Y axis
res@trYMaxF      = max(t33)+0.1
res@gsnCenterString="0 - 300m"
plot(2)=gsn_csm_xy(wks,x,t33,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t44)-0.1           ; Set min/max of left Y axis
res@trYMaxF      = max(t44)+0.1
res@gsnCenterString="0 - 600m"
plot(3)=gsn_csm_xy(wks,x,t44,res)
delete([/res@trYMinF,res@trYMaxF/])
res@trYMinF      = min(t55)-0.1           ; Set min/max of left Y axis
res@trYMaxF      = max(t55)+0.1
res@gsnCenterString="0 - 1100m"
plot(4)=gsn_csm_xy(wks,x,t55,res)

pres              = True
pres@gsnMaximize  = True
pres@gsnPanelXWhiteSpacePercent =3
pres@gsnPanelRowSpec=True
gsn_panel(wks,plot,(/3,2/),pres)

end
