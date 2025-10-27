begin
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_cobalt_yesno_num_19900101-20091231.nc","r")
Phase_num_co=f->Phase_num
Phase_mjo_co=f->Phase_mjo

g=addfile(dir1+"MJO_daily_chl_yesno_num_19900101-20091231.nc","r")
Phase_num_daily=g->Phase_num
Phase_mjo_daily=g->Phase_mjo

h=addfile(dir1+"MJO_clim_chl_yesno_num_19900101-20091231.nc","r")
Phase_num_clim=h->Phase_num
Phase_mjo_clim=h->Phase_mjo

Num_co=new((/8,4/),typeof(Phase_num_co))
Num_daily=new((/8,4/),typeof(Phase_num_daily))
Num_clim=new((/8,4/),typeof(Phase_num_clim))
do i=0,3
 Num_co(0,i)=num(Phase_num_co(365*5*i:365*5*(i+1)-1) .eq. 1)
 Num_co(1,i)=num(Phase_num_co(365*5*i:365*5*(i+1)-1) .eq. 2)
 Num_co(2,i)=num(Phase_num_co(365*5*i:365*5*(i+1)-1) .eq. 3)
 Num_co(3,i)=num(Phase_num_co(365*5*i:365*5*(i+1)-1) .eq. 4)
 Num_co(4,i)=num(Phase_num_co(365*5*i:365*5*(i+1)-1) .eq. 5)
 Num_co(5,i)=num(Phase_num_co(365*5*i:365*5*(i+1)-1) .eq. 6)
 Num_co(6,i)=num(Phase_num_co(365*5*i:365*5*(i+1)-1) .eq. 7)
 Num_co(7,i)=num(Phase_num_co(365*5*i:365*5*(i+1)-1) .eq. 8)

 Num_daily(0,i)=num(Phase_num_daily(365*5*i:365*5*(i+1)-1) .eq. 1)
 Num_daily(1,i)=num(Phase_num_daily(365*5*i:365*5*(i+1)-1) .eq. 2)
 Num_daily(2,i)=num(Phase_num_daily(365*5*i:365*5*(i+1)-1) .eq. 3)
 Num_daily(3,i)=num(Phase_num_daily(365*5*i:365*5*(i+1)-1) .eq. 4)
 Num_daily(4,i)=num(Phase_num_daily(365*5*i:365*5*(i+1)-1) .eq. 5)
 Num_daily(5,i)=num(Phase_num_daily(365*5*i:365*5*(i+1)-1) .eq. 6)
 Num_daily(6,i)=num(Phase_num_daily(365*5*i:365*5*(i+1)-1) .eq. 7)
 Num_daily(7,i)=num(Phase_num_daily(365*5*i:365*5*(i+1)-1) .eq. 8)

 Num_clim(0,i)=num(Phase_num_clim(365*5*i:365*5*(i+1)-1) .eq. 1)
 Num_clim(1,i)=num(Phase_num_clim(365*5*i:365*5*(i+1)-1) .eq. 2)
 Num_clim(2,i)=num(Phase_num_clim(365*5*i:365*5*(i+1)-1) .eq. 3)
 Num_clim(3,i)=num(Phase_num_clim(365*5*i:365*5*(i+1)-1) .eq. 4)
 Num_clim(4,i)=num(Phase_num_clim(365*5*i:365*5*(i+1)-1) .eq. 5)
 Num_clim(5,i)=num(Phase_num_clim(365*5*i:365*5*(i+1)-1) .eq. 6)
 Num_clim(6,i)=num(Phase_num_clim(365*5*i:365*5*(i+1)-1) .eq. 7)
 Num_clim(7,i)=num(Phase_num_clim(365*5*i:365*5*(i+1)-1) .eq. 8)
end do
Num_co!0="phase"
Num_co!1="period"
Num_daily!0="phase"
Num_daily!1="period"
Num_clim!0="phase"
Num_clim!1="period"

print(Num_clim(:,3))
exit

X1= (/2.75,17.25,31.75,46.25/);cobalt 
X2= (/7.25,21.75,36.25,50.75/);daily
X3= (/11.75,26.25,40.75,55.25/);clim

;colors = (/"red", "magenta","orange","gold", "green","blue","navy","purple"/)
colors=(/"palevioletred1","coral","gold","olivedrab1","lightskyblue","orchid","lightpink","gray"/)
  wks = gsn_open_wks("png",dir2+"Number_of_phase_for_period_cobalt_daily_clim")  ; send graphics to PNG file
;
; Set resources for blank plot. Be sure to set axes limits
; that represent d that will be added later via polygons.
;
  res                          = True
  res@gsnMaximize              = False    ; Maximize plot in frame
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame
  ;res@vpWidthF                 = 0.3     ; Make long and
  ;res@vpHeightF                = 0.9     ; narrow

;---Set axes limits. Add extra space for X max.
  res@trYMinF                  = 0
  res@trYMaxF                  = 1400 
  res@trXMinF                  = 0
  res@trXMaxF                  = 60 
  res@tmXBLabelFontHeightF=0.01
;---Put city labels on X axis
  res@tmXBMode                 = "Explicit"
  res@tmXBValues               = (/2.75,7.25,11.75,17.25,21.75,26.25,31.75,36.25,40.75,46.25,50.75,55.25/) 
  res@tmXBLabels               = (/"cobalt","daily","clim","cobalt","daily","clim","cobalt","daily","clim","cobalt","daily","clim"/) 
  res@gsnScale                 = True    ; Make labels on axes same size

;--Turn off X axis tickmarks
  res@tmXBMajorLengthF         = 0.
  res@tmXBMajorOutwardLengthF  = 0.  
  res@tmYLMajorLengthF         = 0.01
  res@tmYLMajorOutwardLengthF  = 0.01

  ;res@tmXTOn                   = False   ; Turn off top tickmarks

;---Create blank plot without Y grid lines
  plot_without_xgrid = gsn_csm_blank_plot(wks,res)

;---Create blank plot with Y grid lines
  res@tmYMajorGrid                = True    ; Turn on grid lines
  res@tmYMajorGridLineDashPattern = 2       ; Dashed lines
  res@tmYMajorGridThicknessF      = 1.0     ; default is 2 (?)
  plot_with_xgrid = gsn_csm_blank_plot(wks,res)

;---Arrays to hold the bar values and the bars themselves.
  dum1 = new(4,graphic)
  dum2 = new(4,graphic)
  dum3 = new(4,graphic)
  dum4 = new(4,graphic)
  dum5 = new(4,graphic)
  dum6 = new(4,graphic)
  dum7 = new(4,graphic)
  dum8 = new(4,graphic)

  dum11 = new(4,graphic)
  dum22 = new(4,graphic)
  dum33 = new(4,graphic)
  dum44 = new(4,graphic)
  dum55 = new(4,graphic)
  dum66 = new(4,graphic)
  dum77 = new(4,graphic)
  dum88 = new(4,graphic)

  dum111 = new(4,graphic)
  dum222 = new(4,graphic)
  dum333 = new(4,graphic)
  dum444 = new(4,graphic)
  dum555 = new(4,graphic)
  dum666 = new(4,graphic)
  dum777 = new(4,graphic)
  dum888 = new(4,graphic)
;---Set some resources for the bars.
  bres           = True
  bres@gsEdgesOn = True      ; Outline the polygons (bars)
;
; Loop through each city and attach bar to plot that
; doesn't have grid lines.

  do i=0,3
    bres@gsFillColor           = colors(0) 
    ybar      = (/0,Num_co(0,i),Num_co(0,i),0,0/)
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    dum1(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    ybar      = (/0,Num_daily(0,i),Num_daily(0,i),0,0/)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    dum11(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    ybar      = (/0,Num_clim(0,i),Num_clim(0,i),0,0/)
    xbar      = (/X3(i)-1.75,X3(i)-1.75,X3(i)+1.75,X3(i)+1.75,X3(i)-1.75/)
    dum111(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(1)
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_co(0,i),Num_co(0,i)+Num_co(1,i),Num_co(0,i)+Num_co(1,i),Num_co(0,i),Num_co(0,i)/)
    dum2(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_daily(0,i),Num_daily(0,i)+Num_daily(1,i),Num_daily(0,i)+Num_daily(1,i),Num_daily(0,i),Num_daily(0,i)/)
    dum22(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X3(i)-1.75,X3(i)-1.75,X3(i)+1.75,X3(i)+1.75,X3(i)-1.75/)
    ybar      = (/Num_clim(0,i),Num_clim(0,i)+Num_clim(1,i),Num_clim(0,i)+Num_clim(1,i),Num_clim(0,i),Num_clim(0,i)/)
    dum222(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    
    bres@gsFillColor          = colors(2) 
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_co(0,i)+Num_co(1,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i),\
		Num_co(0,i)+Num_co(1,i),Num_co(0,i)+Num_co(1,i)/)
    dum3(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_daily(0,i)+Num_daily(1,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i),\
		Num_daily(0,i)+Num_daily(1,i),Num_daily(0,i)+Num_daily(1,i)/)
    dum33(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X3(i)-1.75,X3(i)-1.75,X3(i)+1.75,X3(i)+1.75,X3(i)-1.75/)
    ybar      = (/Num_clim(0,i)+Num_clim(1,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i),\
		Num_clim(0,i)+Num_clim(1,i),Num_clim(0,i)+Num_clim(1,i)/)
    dum333(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(3)
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_co(0,i)+Num_co(1,i)+Num_co(2,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i),\
                Num_co(0,i)+Num_co(1,i)+Num_co(2,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i)/)
    dum4(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i),\
                Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)/)
    dum44(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X3(i)-1.75,X3(i)-1.75,X3(i)+1.75,X3(i)+1.75,X3(i)-1.75/)
    ybar      = (/Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i),\
                Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)/)
    dum444(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(4) 
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)/)
    dum5(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i),\
                Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i),\
                Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)/)
    dum55(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X3(i)-1.75,X3(i)-1.75,X3(i)+1.75,X3(i)+1.75,X3(i)-1.75/)
    ybar      = (/Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i),\
                Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i),\
                Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)/)
    dum555(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(5) 
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)/)
    dum6(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i),\
	Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i),\
		Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)/)
    dum66(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X3(i)-1.75,X3(i)-1.75,X3(i)+1.75,X3(i)+1.75,X3(i)-1.75/)
    ybar      = (/Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i),\
	Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i),\
		Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)/)
    dum666(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(6)
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i)+Num_co(6,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i)+Num_co(6,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i),Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i)/)
    dum7(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i),\
		Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i)+Num_daily(6,i),\
		Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i)+Num_daily(6,i),\
	Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i),Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i)/)
    dum77(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X3(i)-1.75,X3(i)-1.75,X3(i)+1.75,X3(i)+1.75,X3(i)-1.75/)
    ybar      = (/Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i),\
		Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i)+Num_clim(6,i),\
		Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i)+Num_clim(6,i),\
	Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i),Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i)/)
    dum777(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(7) 
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i)+Num_co(6,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i)+Num_co(6,i)+Num_co(7,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i)+Num_co(6,i)+Num_co(7,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i)+Num_co(6,i),\
		Num_co(0,i)+Num_co(1,i)+Num_co(2,i)+Num_co(3,i)+Num_co(4,i)+Num_co(5,i)+Num_co(6,i)/)
    dum8(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i)+Num_daily(6,i),\
		Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i)+Num_daily(6,i)+Num_daily(7,i),\
		Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i)+Num_daily(6,i)+Num_daily(7,i),\
		Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i)+Num_daily(6,i),\
		Num_daily(0,i)+Num_daily(1,i)+Num_daily(2,i)+Num_daily(3,i)+Num_daily(4,i)+Num_daily(5,i)+Num_daily(6,i)/)
    dum88(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X3(i)-1.75,X3(i)-1.75,X3(i)+1.75,X3(i)+1.75,X3(i)-1.75/)
    ybar      = (/Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i)+Num_clim(6,i),\
		Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i)+Num_clim(6,i)+Num_clim(7,i),\
		Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i)+Num_clim(6,i)+Num_clim(7,i),\
		Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i)+Num_clim(6,i),\
		Num_clim(0,i)+Num_clim(1,i)+Num_clim(2,i)+Num_clim(3,i)+Num_clim(4,i)+Num_clim(5,i)+Num_clim(6,i)/)
    dum888(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

end do
;
; Drawing the plot will draw all the attached bars. Have to draw
; the plot twice: one with the X grid lines and one without, in
; order to make sure the X grid lines are behind the bars.
;
; Couldn't see how else to do this.
;
; Create some labelbars for a legend
     lbres                    = True          ; labelbar only resources
     lbres@vpWidthF           = 0.2           ; labelbar width
     lbres@vpHeightF          = 0.1           ; labelbar height
     lbres@lbBoxMajorExtentF  = 0.15          ; puts space between color boxes
     lbres@lbMonoFillPattern  = True          ; Solid fill pattern
     lbres@lbLabelFontHeightF = 0.015         ; font height. default is small
     lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
     lbres@lbPerimOn          = False

     labels = (/"Phase 1","Phase 2","Phase 3","Phase 4","Phase 5","Phase 6","Phase 7","Phase 8"/)
     xpos   = (/0.05,  0.3, 0.55, 0.8/)

     do i=0,3
       lbres@lbFillColors = colors(i)
       gsn_labelbar_ndc(wks,1,labels(i),xpos(i),0.93,lbres)
     end do	

     do i=4,7
       lbres@lbFillColors = colors(i)
       gsn_labelbar_ndc(wks,1,labels(i),xpos(i-4),0.89,lbres)
     end do	

  draw(plot_with_xgrid)
  draw(plot_without_xgrid)
txres2               = True                      ; text mods desired
txres2@txFontHeightF = 0.02
gsn_text_ndc(wks,"90-94",0.27,0.13,txres2)
gsn_text_ndc(wks,"95-99",0.42,0.13,txres2)
gsn_text_ndc(wks,"00-04",0.56,0.13,txres2)
gsn_text_ndc(wks,"05-09",0.71,0.13,txres2)

frame(wks)
end
