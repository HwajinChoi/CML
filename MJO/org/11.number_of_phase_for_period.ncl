begin
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_ON_yesno_num_20000101-20191231.nc","r")
Phase_num_ON=f->Phase_num
Phase_mjo_ON=f->Phase_mjo

g=addfile(dir1+"MJO_OFF_yesno_num_20000101-20191231.nc","r")
Phase_num_OFF=g->Phase_num
Phase_mjo_OFF=g->Phase_mjo

Num_ON=new((/8,4/),typeof(Phase_num_ON))
Num_OFF=new((/8,4/),typeof(Phase_num_OFF))
do i=0,3
 Num_ON(0,i)=num(Phase_num_ON(365*5*i:365*5*(i+1)-1) .eq. 1)
 Num_ON(1,i)=num(Phase_num_ON(365*5*i:365*5*(i+1)-1) .eq. 2)
 Num_ON(2,i)=num(Phase_num_ON(365*5*i:365*5*(i+1)-1) .eq. 3)
 Num_ON(3,i)=num(Phase_num_ON(365*5*i:365*5*(i+1)-1) .eq. 4)
 Num_ON(4,i)=num(Phase_num_ON(365*5*i:365*5*(i+1)-1) .eq. 5)
 Num_ON(5,i)=num(Phase_num_ON(365*5*i:365*5*(i+1)-1) .eq. 6)
 Num_ON(6,i)=num(Phase_num_ON(365*5*i:365*5*(i+1)-1) .eq. 7)
 Num_ON(7,i)=num(Phase_num_ON(365*5*i:365*5*(i+1)-1) .eq. 8)

 Num_OFF(0,i)=num(Phase_num_OFF(365*5*i:365*5*(i+1)-1) .eq. 1)
 Num_OFF(1,i)=num(Phase_num_OFF(365*5*i:365*5*(i+1)-1) .eq. 2)
 Num_OFF(2,i)=num(Phase_num_OFF(365*5*i:365*5*(i+1)-1) .eq. 3)
 Num_OFF(3,i)=num(Phase_num_OFF(365*5*i:365*5*(i+1)-1) .eq. 4)
 Num_OFF(4,i)=num(Phase_num_OFF(365*5*i:365*5*(i+1)-1) .eq. 5)
 Num_OFF(5,i)=num(Phase_num_OFF(365*5*i:365*5*(i+1)-1) .eq. 6)
 Num_OFF(6,i)=num(Phase_num_OFF(365*5*i:365*5*(i+1)-1) .eq. 7)
 Num_OFF(7,i)=num(Phase_num_OFF(365*5*i:365*5*(i+1)-1) .eq. 8)
end do
Num_ON!0="phase"
Num_ON!1="period"
Num_OFF!0="phase"
Num_OFF!1="period"
X1= (/2.75,12.75,22.75,32.75/);ON_x 
X2= (/7.25,17.25,27.25,37.25/);OFF_x
;colors = (/"red", "magenta","orange","gold", "green","blue","navy","purple"/)
colors=(/"palevioletred1","coral","gold","olivedrab1","lightskyblue","orchid","lightpink","gray"/)
  wks = gsn_open_wks("png",dir2+"Number_of_phase_for_period_ON_OFF")  ; send graphics to PNG file
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
  res@trYMaxF                  = 1140 
  res@trXMinF                  = 0
  res@trXMaxF                  = 40 

;---Put city labels on X axis
  res@tmXBMode                 = "Explicit"
  res@tmXBValues               = (/2.75,7.25,12.75,17.25,22.75,27.25,32.75,37.25/) 
  res@tmXBLabels               = (/"on","off","on","off","on","off","on","off"/) 
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
;---Set some resources for the bars.
  bres           = True
  bres@gsEdgesOn = True      ; Outline the polygons (bars)
;
; Loop through each city and attach bar to plot that
; doesn't have grid lines.

  do i=0,3
    bres@gsFillColor           = colors(0) 
    ybar      = (/0,Num_ON(0,i),Num_ON(0,i),0,0/)
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    dum1(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    ybar      = (/0,Num_OFF(0,i),Num_OFF(0,i),0,0/)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    dum11(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(1)
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_ON(0,i),Num_ON(0,i)+Num_ON(1,i),Num_ON(0,i)+Num_ON(1,i),Num_ON(0,i),Num_ON(0,i)/)
    dum2(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_OFF(0,i),Num_OFF(0,i)+Num_OFF(1,i),Num_OFF(0,i)+Num_OFF(1,i),Num_OFF(0,i),Num_OFF(0,i)/)
    dum22(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    
    bres@gsFillColor          = colors(2) 
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_ON(0,i)+Num_ON(1,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i),\
		Num_ON(0,i)+Num_ON(1,i),Num_ON(0,i)+Num_ON(1,i)/)
    dum3(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_OFF(0,i)+Num_OFF(1,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i),\
		Num_OFF(0,i)+Num_OFF(1,i),Num_OFF(0,i)+Num_OFF(1,i)/)
    dum33(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
 
    bres@gsFillColor          = colors(3)
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i),\
                Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)/)
    dum4(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i),\
                Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)/)
    dum44(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(4) 
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)/)
    dum5(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i),\
                Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i),\
                Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)/)
    dum55(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(5) 
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)/)
    dum6(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i),\
	Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i),\
		Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)/)
    dum66(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    bres@gsFillColor          = colors(6)
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i)+Num_ON(6,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i)+Num_ON(6,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i),Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i)/)
    dum7(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i),\
		Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i)+Num_OFF(6,i),\
		Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i)+Num_OFF(6,i),\
	Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i),Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i)/)
    dum77(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

    bres@gsFillColor          = colors(7) 
    xbar      = (/X1(i)-1.75,X1(i)-1.75,X1(i)+1.75,X1(i)+1.75,X1(i)-1.75/)
    ybar      = (/Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i)+Num_ON(6,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i)+Num_ON(6,i)+Num_ON(7,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i)+Num_ON(6,i)+Num_ON(7,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i)+Num_ON(6,i),\
		Num_ON(0,i)+Num_ON(1,i)+Num_ON(2,i)+Num_ON(3,i)+Num_ON(4,i)+Num_ON(5,i)+Num_ON(6,i)/)
    dum8(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)
    xbar      = (/X2(i)-1.75,X2(i)-1.75,X2(i)+1.75,X2(i)+1.75,X2(i)-1.75/)
    ybar      = (/Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i)+Num_OFF(6,i),\
		Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i)+Num_OFF(6,i)+Num_OFF(7,i),\
		Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i)+Num_OFF(6,i)+Num_OFF(7,i),\
		Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i)+Num_OFF(6,i),\
		Num_OFF(0,i)+Num_OFF(1,i)+Num_OFF(2,i)+Num_OFF(3,i)+Num_OFF(4,i)+Num_OFF(5,i)+Num_OFF(6,i)/)
    dum88(i) = gsn_add_polygon(wks,plot_without_xgrid,xbar,ybar,bres)

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
gsn_text_ndc(wks,"Period 1",0.27,0.13,txres2)
gsn_text_ndc(wks,"Period 2",0.43,0.13,txres2)
gsn_text_ndc(wks,"Period 3",0.58,0.13,txres2)
gsn_text_ndc(wks,"Period 4",0.73,0.13,txres2)

frame(wks)
end
