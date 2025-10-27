begin
dir="/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9/"

a=-235.2875
b=21.46959

c=-223.8469
d=14.47722

h3=addfile(dir+"OLR_indo_11moving_1991-2022_June_Sep.nc","r")
olr_indo0=h3->orl(0:29,:); year x time
olr_indo0=olr_indo0*(-1)

h4=addfile(dir+"OLR_china_11moving_1991-2022_June_Sep.nc","r")
olr_china0=h4->orl(0:29,:)
olr_china0=olr_china0*(-1)

indo_p=pdfx(olr_indo0,50,False)
china_p=pdfx(olr_china0,50,False)

 plot=new(2,"graphic")
 wks  = gsn_open_wks ("png","test_normal_distribution")             ; send graphics to PNG file

  res  = True
  res@gsnDraw                = False
  res@gsnFrame               = False
  res@xyLineThicknessF       = 4
  res@tiYAxisString          = "PDF (%)"  
  res@gsnXRefLine=(/a-2*b,a-b,a,a+b,a+2*b/)
  res@gsnXRefLineColors=(/"blue","red","black","red","blue"/)
  res@gsnXRefLineThicknesses=(/4,4,4,4,4/)
  res@gsnCenterString        = "indo"
  plot(0) = gsn_csm_xy (wks, indo_p@bin_center, indo_p, res)
  res@gsnCenterString        = "China"
  res@gsnXRefLine=(/c-2*d,c-d,c,c+d,c+2*d/)
  res@gsnXRefLineColors=(/"blue","red","black","red","blue"/)
  res@gsnXRefLineThicknesses=(/4,4,4,4,4/)
  plot(1) = gsn_csm_xy (wks, china_p@bin_center, china_p, res)

  resP    = True
  resP@gsnPanelMainString    = ""
  resP@gsnPanelRowSpec       = False              ; tell panel what order to plt
  gsn_panel(wks,plot,(/2,1/),resP)

end
