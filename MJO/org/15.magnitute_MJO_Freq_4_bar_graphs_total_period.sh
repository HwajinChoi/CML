#!/bin/bash
for SSS in "ON" "OFF";do
   if [ $SSS = "ON" ];then
  s="on"
  else
  s="off"
 fi
cat > imsi.ncl << EOF
begin
dir3="/media/cmlws/Data2/hjc/MJO/data/on/"
dir4="/media/cmlws/Data2/hjc/MJO/data/off/"
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_${SSS}_Index_PC1_2_20000101-20191231.nc","r")
MJO_INDEX=f->MJO_INDEX
MJO_1=MJO_INDEX(365*5*0:365*5-1)
MJO_2=MJO_INDEX(365*5*1:365*5*2-1)
MJO_3=MJO_INDEX(365*5*2:365*5*3-1)
MJO_4=MJO_INDEX(365*5*3:365*5*4-1)
mjo1=new(6,typeof(MJO_1))
mjo1(0)=num(MJO_1.ge.1 .and. MJO_1.lt.1.5)
mjo1(1)=num(MJO_1.ge.1.5 .and. MJO_1.lt.2)
mjo1(2)=num(MJO_1.ge.2 .and. MJO_1.lt.2.5)
mjo1(3)=num(MJO_1.ge.2.5 .and. MJO_1.lt.3)
mjo1(4)=num(MJO_1.ge.3 .and. MJO_1.lt.3.5)
mjo1(5)=num(MJO_1.ge.3.5 .and. MJO_1.lt.4)

mjo2=new(6,typeof(MJO_1))
mjo2(0)=num(MJO_2.ge.1 .and. MJO_2.lt.1.5)
mjo2(1)=num(MJO_2.ge.1.5 .and. MJO_2.lt.2)
mjo2(2)=num(MJO_2.ge.2 .and. MJO_2.lt.2.5)
mjo2(3)=num(MJO_2.ge.2.5 .and. MJO_2.lt.3)
mjo2(4)=num(MJO_2.ge.3 .and. MJO_2.lt.3.5)
mjo2(5)=num(MJO_2.ge.3.5 .and. MJO_2.lt.4)

mjo3=new(6,typeof(MJO_1))
mjo3(0)=num(MJO_3.ge.1 .and. MJO_3.lt.1.5)
mjo3(1)=num(MJO_3.ge.1.5 .and. MJO_3.lt.2)
mjo3(2)=num(MJO_3.ge.2 .and. MJO_3.lt.2.5)
mjo3(3)=num(MJO_3.ge.2.5 .and. MJO_3.lt.3)
mjo3(4)=num(MJO_3.ge.3 .and. MJO_3.lt.3.5)
mjo3(5)=num(MJO_3.ge.3.5 .and. MJO_3.lt.4)

mjo4=new(6,typeof(MJO_1))
mjo4(0)=num(MJO_4.ge.1 .and. MJO_4.lt.1.5)
mjo4(1)=num(MJO_4.ge.1.5 .and. MJO_4.lt.2)
mjo4(2)=num(MJO_4.ge.2 .and. MJO_4.lt.2.5)
mjo4(3)=num(MJO_4.ge.2.5 .and. MJO_4.lt.3)
mjo4(4)=num(MJO_4.ge.3 .and. MJO_4.lt.3.5)
mjo4(5)=num(MJO_4.ge.3.5 .and. MJO_4.lt.4)

stdarr = new((/6,4/),"float")
stdarr(:,0) = (/mjo1 /)
stdarr(:,1) = (/mjo2/)
stdarr(:,2) = (/mjo3/)
stdarr(:,3) = (/mjo4/)

     wks  = gsn_open_wks ("png",dir2+"RMM_amplitude_${SSS}_Freq_4_periods")                ; send graphics to PNG file
     sres = True
     sres@vpWidthF = 0.7
     sres@vpHeightF = 0.5
     sres@vpXF = .15
     sres@trXMinF = 0.4
     sres@trXMaxF = 6.6
     sres@trYMinF = 0
     sres@trYMaxF = 600
     sres@gsnDraw = True
     sres@gsnFrame = False
     sres@gsnXYBarChart = True
     sres@gsnXYBarChartBarWidth = 0.15           ; change bar widths
     sres@tmXBMode          = "Explicit"         ; explicit labels
     sres@tmXBValues        = (/1,2,3,4,5,6/)
     sres@tmXBLabels = (/"1-1.5","1.5-2","2-2.5","2.5-3","3-3.5","3.5-4"/)
     sres@tmXBLabelFontHeightF = 0.0205
     sres@tmXTLabelFontHeightF = 0.0205
     sres@tmYLLabelFontHeightF = 0.0225
     sres@tiMainFontHeightF = 0.025
     sres@tiMainString = "${SSS}; 20001231-20191231"
     sres@gsnRightString = ""
     sres@tiYAxisString = "Frequency"
     sres@tiXAxisString = "square root of (PC1^2+ PC2^2)"
        
     sres@gsnXYBarChartColors = (/"blue"/)	
     plot1 = gsn_csm_xy(wks,fspan(.775,5.775,6),stdarr(:,0),sres)		; draw each time series
     sres@gsnXYBarChartColors = (/"red"/)					; seperately, not
     plot2 = gsn_csm_xy(wks,fspan(.925,5.925,6),stdarr(:,1),sres)		; advancing the frame
     sres@gsnXYBarChartColors = (/"green"/)					; but tweaking where
     plot3 = gsn_csm_xy(wks,fspan(1.075,6.075,6),stdarr(:,2),sres)		; each time series is
     sres@gsnXYBarChartColors = (/"black"/)					; drawn on the X-axis
     plot4 = gsn_csm_xy(wks,fspan(1.225,6.225,6),stdarr(:,3),sres)

     lbres                    = True          ; labelbar only resources
     lbres@vpWidthF           = 0.15           ; labelbar width
     lbres@vpHeightF          = 0.2           ; labelbar height
     lbres@lbBoxMajorExtentF  = 0.15          ; puts space between color boxes
     lbres@lbFillColors       = (/"blue","red","green","black"/)
     lbres@lbMonoFillPattern  = True          ; Solid fill pattern
     lbres@lbLabelFontHeightF = 0.02         ; font height. default is small
     lbres@lbLabelJust        = "centerleft"  ; left justify labels
     lbres@lbPerimOn          = False
     lbres@lgPerimColor 	 = "white"
     labels = (/"00-04","05-09","10-14","15-19"/)
     gsn_labelbar_ndc(wks,4,labels,0.68,0.80,lbres)	; draw right labelbar column
     frame(wks)      

end
EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done
