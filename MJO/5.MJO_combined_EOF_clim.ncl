begin
dir1="/media/cmlws/Data2/hjc/MJO/data/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"
dir3="/media/cmlws/Data2/hjc/MJO/data/Index/"
;-------------------------------------------------------
neof    =  2
latS    = -15
latN    =  15
ymdStrt = 20000101                         ; start yyyymmdd
ymdLast = 20191231                         ; last  
yrStrt  = ymdStrt/10000
yrLast  = ymdLast/10000
;-------------------------------------------------------
f1=addfile(dir1+"on/olr_ano_20000101-20191231.nc","r")
TIME=f1->time
time=TIME
grid_yt=f1->grid_yt
grid_xt=f1->grid_xt
YMD     = cd_calendar(TIME, -2)            ; entire (time,6)
iStrt   = ind(YMD.eq.ymdStrt)              ; index start
iLast   = ind(YMD.eq.ymdLast)              ; index last 
delete([/ TIME, YMD /])
;--------------------------------------------------------
olr_on=f1->olrAnom(iStrt:iLast,{latS:latN},:)
olr_ON=dim_avg_n_Wrap(olr_on,1)
f2=addfile(dir1+"on/ucomp_ano_20000101-20191231.nc","r")
u_on=f2->ucompAnom(iStrt:iLast,{latS:latN},:)
u_ON=dim_avg_n_Wrap(u_on,1)
g1=addfile(dir1+"off/olr_ano_20000101-20191231.nc","r")
olr_off=g1->olrAnom(iStrt:iLast,{latS:latN},:)
olr_OFF=dim_avg_n_Wrap(olr_off,1)
g2=addfile(dir1+"off/ucomp_ano_20000101-20191231.nc","r")
u_off=g2->ucompAnom(iStrt:iLast,{latS:latN},:)
u_OFF=dim_avg_n_Wrap(u_off,1)
;--------------------------------------------------------
dim=dimsizes(olr_on); time x lat x lon
ntim    = dim(0)
nlat    = dim(1)
mlon    = dim(2)
; ***********************************************
; Specify assorted constants
; ***********************************************
 ca      = 60          ; Butterworth
 cb      = 30
 nWgt    = 201        ; 
; ***********************************************
; calculate the start and stop frequency band limits
; ***********************************************
 fca     = 1.0/ca                        ; start freq
 fcb     = 1.0/cb                        ; last  freq
; ***********************************************
; Lanczos filter
; ***********************************************
 ihp     = 2                             ; band pass
 sigma   = 1.0                           ; Lanczos sigma
 opt     = 0
 wgt     = filwgts_lanczos (nWgt, ihp, fca, fcb, sigma )
;--------------------------------------------------------
olr_on_lz    = wgt_runave_n_Wrap ( olr_ON, wgt, opt,0 )
olr_on_lz@long_name = "Lanczos Bandpass: "+cb+"-"+ca+" day"
olr_off_lz    = wgt_runave_n_Wrap ( olr_OFF, wgt, opt,0 )
olr_off_lz@long_name = "Lanczos Bandpass: "+cb+"-"+ca+" day"
u_on_lz    = wgt_runave_n_Wrap ( u_ON, wgt, opt,0 )
u_on_lz@long_name = "Lanczos Bandpass: "+cb+"-"+ca+" day"
u_off_lz    = wgt_runave_n_Wrap ( u_OFF, wgt, opt,0 )
u_off_lz@long_name = "Lanczos Bandpass: "+cb+"-"+ca+" day"
;************************************************
; Compute the temporal variance at each lon
;************************************************
var_olr_on  = dim_variance_n_Wrap( olr_on_lz, 0)     ; (lon)
var_olr_off  = dim_variance_n_Wrap( olr_off_lz, 0)     ; (lon)
var_u_on  = dim_variance_n_Wrap( u_on_lz, 0)     ; (lon)
var_u_off  = dim_variance_n_Wrap( u_off_lz, 0)     ; (lon)
;************************************************
; Compute the zonal mean of the temporal variance
;************************************************
zavg_var_olr_on  = dim_avg_n_Wrap( var_olr_on , 0)     
zavg_var_olr_off  = dim_avg_n_Wrap( var_olr_off , 0)     
zavg_var_u_on  = dim_avg_n_Wrap( var_u_on , 0)     
zavg_var_u_off  = dim_avg_n_Wrap( var_u_off , 0)     
;************************************************
; Normalize by sqrt(avg_var*)
;************************************************
olr_on_lz   =  olr_on_lz/sqrt(zavg_var_olr_on)          ; (time,lon)
olr_off_lz   =  olr_off_lz/sqrt(zavg_var_olr_off)          ; (time,lon)
u_on_lz   =  u_on_lz/sqrt(zavg_var_u_on)          ; (time,lon)
u_off_lz   =  u_off_lz/sqrt(zavg_var_u_off)          ; (time,lon)
;************************************************
; Combine the normalized data into one variable
;************************************************
  ON     = new ( (/2*mlon,ntim/), typeof(olr_on_lz), getFillValue(olr_on_lz))
  OFF    = new ( (/2*mlon,ntim/), typeof(olr_on_lz), getFillValue(olr_on_lz))
  do ml=0,mlon-1
     ON(ml       ,:) = (/ olr_on_lz(:,ml) /)
     ON(ml+  mlon,:) = (/ u_on_lz(:,ml) /)

     OFF(ml       ,:) = (/ olr_off_lz(:,ml) /)
     OFF(ml+  mlon,:) = (/ u_off_lz(:,ml) /)
  end do

;************************************************
; Compute **combined** EOF; Sign of EOF is arbitrary
;************************************************
  eof_ON    = eofunc(ON   , neof, False)      ; (neof,3*mlon)
  print("==============")
  printVarSummary(eof_ON)
  printMinMax(eof_ON, True)

  eof_ts_ON = eofunc_ts(ON,eof_ON,False)   ; (neof,3*ntim)
  print("==============")                                  
  printVarSummary(eof_ts_ON)
  printMinMax(eof_ts_ON, True)

  eof_OFF    = eofunc(OFF   , neof, False)      ; (neof,3*mlon)
  print("==============")
  printVarSummary(eof_OFF)
  printMinMax(eof_OFF, True)

  eof_ts_OFF = eofunc_ts(OFF,eof_OFF,False)   ; (neof,3*ntim)
  print("==============")                                  
  printVarSummary(eof_ts_OFF)
  printMinMax(eof_ts_OFF, True)
;************************************************
; For clarity, explicitly extract each variable. Create time series 
;************************************************
  nvar = 2  ; "olr", "u850", "u200"
  ceof_ON = new( (/nvar,neof,mlon/), typeof(ON), getFillValue(ON))
  ceof_OFF = new( (/nvar,neof,mlon/), typeof(ON), getFillValue(ON))

  do n=0,neof-1
     ceof_ON(0,n,:) = eof_ON(n,0:mlon-1)      ; olr
     ceof_ON(1,n,:) = eof_ON(n,mlon:2*mlon-1) ; u850

     ceof_OFF(0,n,:) = eof_OFF(n,0:mlon-1)      ; olr
     ceof_OFF(1,n,:) = eof_OFF(n,mlon:2*mlon-1) ; u850
  end do

  ceof_ON!0   = "var"
  ceof_ON!1   = "eof"
  ceof_ON!2   = "lon"   
  ceof_ON&lon =  olr_on_lz&grid_xt

  ceof_OFF!0   = "var"
  ceof_OFF!1   = "eof"
  ceof_OFF!2   = "lon"   
  ceof_OFF&lon =  olr_on_lz&grid_xt

  ceof_ts_ON        = new( (/nvar,neof,ntim/), typeof(ON), getFillValue(ON))
  ceof_ts_ON(0,:,:) = eofunc_ts_Wrap(olr_on_lz(grid_xt|:,time|:),ceof_ON(0,:,:),False)   ; (0,neof,ntim)
  ceof_ts_ON(1,:,:) = eofunc_ts_Wrap(u_on_lz(grid_xt|:,time|:),ceof_ON(1,:,:),False)   ; (1,neof,ntim)

  ceof_ts_OFF        = new( (/nvar,neof,ntim/), typeof(OFF), getFillValue(OFF))
  ceof_ts_OFF(0,:,:) = eofunc_ts_Wrap(olr_off_lz(grid_xt|:,time|:),ceof_OFF(0,:,:),False)   ; (0,neof,ntim)
  ceof_ts_OFF(1,:,:) = eofunc_ts_Wrap(u_off_lz(grid_xt|:,time|:),ceof_OFF(1,:,:),False)   ; (1,neof,ntim)

;**********************************************t*
; Add code contributed by Marcus N. Morgan, Florida Institute of Technology; Feb 2015
; Calculate % variance (pcv_ )accounted for by OLR, U850 and U200
;************************************************
  pcv_eof_olr_on  = new(neof,typeof(ceof_ON))
  pcv_eof_u_on = new(neof,typeof(ceof_ON))

  pcv_eof_olr_off  = new(neof,typeof(ceof_ON))
  pcv_eof_u_off = new(neof,typeof(ceof_ON))
    
  do n=0,neof-1
     pcv_eof_olr_on(n)  = avg((ceof_ON(0,n,:)*sqrt(ceof_ON@eval(n)))^2)*100
     pcv_eof_u_on(n) = avg((ceof_ON(1,n,:)*sqrt(ceof_ON@eval(n)))^2)*100

     pcv_eof_olr_off(n)  = avg((ceof_OFF(0,n,:)*sqrt(ceof_OFF@eval(n)))^2)*100
     pcv_eof_u_off(n) = avg((ceof_OFF(1,n,:)*sqrt(ceof_OFF@eval(n)))^2)*100
  end do

;************************************************
; Change sign of EOFs for spatial structures of PC1 and PC2 
; to represent convection over the tropical Indian Ocean and the tropical western Pacific Ocean, respectively 
; (Ad hoc approach) 
;************************************************
  imax_olr_on_eof1   = maxind(ceof_ON(0,0,:))         
  imax_olr_on_eof2   = maxind(ceof_ON(0,1,:))    

  lonmax_eof1_on = ceof_ON&lon(imax_olr_on_eof1)      ; longitude of max value (i.e. suppressed convection)
  lonmax_eof2_on = ceof_ON&lon(imax_olr_on_eof2)

  if (lonmax_eof1_on.ge.60 .and. lonmax_eof1_on.lt.180) then  ; Change the sign of EOF1 
      ceof_ON(:,0,:)       = -ceof_ON(:,0,:)                  ; if OLR is positive
      ceof_ts_ON(:,0,:)    = -ceof_ts_ON(:,0,:)               ;  over the tropical Indian Ocean
      eof_ON(0,:)    = -eof_ON(0,:)
      eof_ts_ON(0,:) = -eof_ts_ON(0,:)
  end if

  if (lonmax_eof2_on.ge.120 .and. lonmax_eof2_on.lt.180) then  ; Change the sign of EOF2
      ceof_ON(:,1,:)       = -ceof_ON(:,1,:)                   ; if OLR is positive 
      ceof_ts_ON(:,1,:)    = -ceof_ts_ON(:,1,:)                ; over the tropical western Pacific Ocean
      eof_ON(1,:)    = -eof_ON(1,:)
      eof_ts_ON(1,:) = -eof_ts_ON(1,:)
  end if

  imax_olr_off_eof1   = maxind(ceof_OFF(0,0,:))         
  imax_olr_off_eof2   = maxind(ceof_OFF(0,1,:))    

  lonmax_eof1_off = ceof_OFF&lon(imax_olr_off_eof1)      ; loffgitude of max value (i.e. suppressed coffvectioff)
  lonmax_eof2_off = ceof_OFF&lon(imax_olr_off_eof2)

  if (lonmax_eof1_off.ge.60 .and. lonmax_eof1_off.lt.180) then  ; Change the sign of EOF1 
      ceof_OFF(:,0,:)       = -ceof_OFF(:,0,:)                  ; if OLR is positive
      ceof_ts_OFF(:,0,:)    = -ceof_ts_OFF(:,0,:)               ;  over the tropical Indian Ocean
      eof_OFF(0,:)    = -eof_OFF(0,:)
      eof_ts_OFF(0,:) = -eof_ts_OFF(0,:)
  end if

  if (lonmax_eof2_off.ge.120 .and. lonmax_eof2_off.lt.180) then  ; Change the sign of EOF2
      ceof_OFF(:,1,:)       = -ceof_OFF(:,1,:)                   ; if OLR is positive 
      ceof_ts_OFF(:,1,:)    = -ceof_ts_OFF(:,1,:)                ; over the tropical western Pacific Ocean
      eof_OFF(1,:)    = -eof_OFF(1,:)
      eof_ts_OFF(1,:) = -eof_ts_OFF(1,:)
  end if

;************************************************
; Compute cross correlation of each variable's EOF time series at zero-lag
;************************************************
  r_olr_u_on  = escorc(ceof_ts_ON(0,:,:) , ceof_ts_ON(1,:,:) )  ; (neof)
  r_olr_u_off  = escorc(ceof_ts_OFF(0,:,:) , ceof_ts_OFF(1,:,:) )  ; (neof)

  print("==============")
  do n=0,neof-1
     print("neof_on="+n+"  r_olr_u_on=" +sprintf("%4.3f",r_olr_u_on(n)))  
     print("neof_off="+n+"  r_olr_u_off=" +sprintf("%4.3f",r_olr_u_off(n)))  
  end do
  print("==============")

;************************************************
; Compute cross correlation of the multivariate EOF; EOF 1 vs EOF 2
;************************************************
  mxlag     = 25
  rlag_01_ON   = esccr(eof_ts_ON(0,:),eof_ts_ON(1,:), mxlag)   ; (N,mxlag+1)
  rlag_10_ON   = esccr(eof_ts_ON(1,:),eof_ts_ON(0,:), mxlag)   ; (N,mxlag+1)
  ccr_12_ON    = new ( (/2*mxlag+1/), float)    
  ccr_12_ON(mxlag:)    = rlag_10_ON(0:mxlag)   
  ccr_12_ON(0:mxlag)   = rlag_01_ON(::-1)       ; reverse order

  rlag_01_OFF   = esccr(eof_ts_OFF(0,:),eof_ts_OFF(1,:), mxlag)   ; (N,mxlag+1)
  rlag_10_OFF   = esccr(eof_ts_OFF(1,:),eof_ts_OFF(0,:), mxlag)   ; (N,mxlag+1)
  ccr_12_OFF    = new ( (/2*mxlag+1/), float)    
  ccr_12_OFF(mxlag:)    = rlag_10_OFF(0:mxlag)   
  ccr_12_OFF(0:mxlag)   = rlag_01_OFF(::-1)       ; reverse order

;************************************************
; Normalize the multivariate EOF 1&2 component time series
; Compute (PC1^2+PC2^2): values > 1 indicate "strong" periods
;************************************************
  eof_ts_ON(0,:) = eof_ts_ON(0,:)/stddev(eof_ts_ON(0,:))
  eof_ts_ON(1,:) = eof_ts_ON(1,:)/stddev(eof_ts_ON(1,:))

  mjo_ts_index_ON      = sqrt(eof_ts_ON(0,:)^2 + eof_ts_ON(1,:)^2)
  mjo_ts_index_smt_ON  = runave(mjo_ts_index_ON, 91, 0) ; 91-day running mean

  nGood_ON   = num(.not.ismissing(mjo_ts_index_ON))     ; # non-missing
  nStrong_ON = num(mjo_ts_index_ON .ge. 1.0)
  print("nGood_ON="+nGood_ON+"   nStrong_ON="+nStrong_ON+"   nOther_ON="+(nGood_ON-nStrong_ON))

  eof_ts_OFF(0,:) = eof_ts_OFF(0,:)/stddev(eof_ts_OFF(0,:))
  eof_ts_OFF(1,:) = eof_ts_OFF(1,:)/stddev(eof_ts_OFF(1,:))

  mjo_ts_index_OFF      = sqrt(eof_ts_OFF(0,:)^2 + eof_ts_OFF(1,:)^2) 
  mjo_ts_index_smt_OFF  = runave(mjo_ts_index_OFF, 91, 0) ; 91-day running mean

  nGood_OFF   = num(.not.ismissing(mjo_ts_index_OFF))     ; # non-missing
  nStrong_OFF = num(mjo_ts_index_OFF .ge. 1.0)
  print("nGood_OFF="+nGood_OFF+"   nStrong_OFF="+nStrong_OFF+"   nOther_OFF="+(nGood_OFF-nStrong_OFF))

;------------------------------------------------------------
 mjo_ts_index_ON!0    = "time"
 mjo_ts_index_ON&time = time 
 mjo_ts_index_ON@long_name = "MJO_ON PC INDEX" 
 mjo_ts_index_ON@info      = "sqrt of (PC1^2 + PC2^2)" 

 ON_PC1=eof_ts_ON(0,:)
 ON_PC1!0="time"
 ON_PC1&time=time
 ON_PC1@long_name= "PC1 of cobalt ON experiment"
 ON_PC1@info      = "PC1/stddev(PC1)"

 ON_PC2=eof_ts_ON(1,:)
 ON_PC2!0="time"
 ON_PC2&time=time
 ON_PC2@long_name= "PC2 of cobalt ON experiment"
 ON_PC2@info      = "PC2/stddev(PC2)"

 mjo_ts_index_OFF!0    = "time"
 mjo_ts_index_OFF&time = time 
 mjo_ts_index_OFF@long_name = "MJO_OFF PC INDEX" 
 mjo_ts_index_OFF@info      = "sqrt of (PC1^2 + PC2^2)" 

 OFF_PC1=eof_ts_OFF(0,:)
 OFF_PC1!0="time"
 OFF_PC1&time=time
 OFF_PC1@long_name= "PC1 of cobalt OFF experiment"
 OFF_PC1@info      = "PC1/stddev(PC1)"

 OFF_PC2=eof_ts_OFF(1,:)
 OFF_PC2!0="time"
 OFF_PC2&time=time
 OFF_PC2@long_name= "PC2 of cobalt OFF experiment"
 OFF_PC2@info      = "PC2/stddev(PC2)"
 system("rm -f "+dir3+"MJO_ON_Index_PC1_2_20000101-20191231.nc")
 out=addfile(    dir3+"MJO_ON_Index_PC1_2_20000101-20191231.nc","c")
 out->MJO_INDEX=mjo_ts_index_ON
 out->PC1=ON_PC1
 out->PC2=ON_PC2
 system("rm -f "+dir3+"MJO_OFF_Index_PC1_2_20000101-20191231.nc")
 out1=addfile(   dir3+"MJO_OFF_Index_PC1_2_20000101-20191231.nc","c")
 out1->MJO_INDEX=mjo_ts_index_OFF
 out1->PC1=OFF_PC1
 out1->PC2=OFF_PC2
 
;------------------------------------------------------------

;------------------------------------------------------------
; PLOTS
;------------------------------------------------------------
  yyyymmdd = cd_calendar(time, -2)
  yrfrac   = yyyymmdd_to_yyyyfrac(yyyymmdd, 0.0)
  delete([/ yrfrac@long_name /])
  day      = ispan(-mxlag, mxlag, 1)
 ;day@long_name = "lag (day)"

  wks = gsn_open_wks("png",dir2+"MJO_ON_30-60_bandpass_20000101-20191231")
  plot = new(3,graphic)                
;************************************************
; Multivariate EOF plots
;************************************************
  rts           = True
  rts@gsnDraw   = False       ; don't draw yet
  rts@gsnFrame  = False       ; don't advance frame yet
  rts@gsnScale  = True        ; force text scaling               

  rts@vpHeightF = 0.40        ; Changes the aspect ratio
  rts@vpWidthF  = 0.85
  rts@vpXF      = 0.10        ; change start locations
  rts@vpYF      = 0.75        ; the plot
  rts@xyLineThicknesses = (/2, 2/)
  rts@xyLineColors      = (/"black","red"/)
  rts@gsnYRefLine       = 0.                  ; reference line   
  rts@trXMaxF           = max(grid_xt)
  rts@trXMinF           = min(grid_xt)

  rts@pmLegendDisplayMode    = "Always"            ; turn on legend
  rts@pmLegendSide           = "Top"               ; Change location of 
  rts@pmLegendParallelPosF   = 1.16                ; move units right
  rts@pmLegendOrthogonalPosF = -0.50               ; move units down
  rts@pmLegendWidthF         = 0.15                ; Change width and
  rts@pmLegendHeightF        = 0.15                ; height of legend.
  rts@lgLabelFontHeightF     = 0.0175


  rtsP                       = True                ; modify the panel plot
;  rtsP@gsnMaximize           = True                ; large format
  rtsP@gsnPanelMainString     = "Multivariate EOF (ON): 15S-15N: "+yrStrt+"-"+yrLast 
  
  do n=0,neof-1
    rts@xyExplicitLegendLabels = (/"OLR: "+sprintf("%4.1f", pcv_eof_olr_on(n)) +"%" \
                                  ,"U850: "+sprintf("%4.1f", pcv_eof_u_on(n))+"%"/) 
    rts@gsnLeftString  = "EOF "+(n+1)
    rts@gsnRightString = sprintf("%3.1f",ceof_ON@pcvar(n))  +"%"
    plot(n) = gsn_csm_xy (wks,grid_xt,ceof_ON(:,n,:),rts)
  end do
  gsn_panel(wks,plot(0:1),(/2,1/),rtsP)     ; now draw as one plot

;-----------------------------------------
; The following doesn't work with some older versions of NCL
; With old versions, the user must delete each individually.
;----------------------------------------- 
  delete([/ rts@xyExplicitLegendLabels, rts@pmLegendDisplayMode \
          , rts@xyLineThicknesses     , rts@gsnLeftString       \
          , rts@gsnRightString        , rts@xyLineColors        \
          , rts@trXMaxF               , rts@trXMinF             /] )

  lag                        = ispan(-mxlag,mxlag,1)
  lag@long_name              = "lag (days)"

  plot(0)                    = gsn_csm_xy (wks, lag ,ccr_12_ON,rts)
  rtsP@gsnPanelMainString    = "Cross Correlation: Multivariate EOF (ON): 15S-15N: " \
                   +  yrStrt+"-"+yrLast 
  rtsP@gsnPaperOrientation   = "portrait"        ; force portrait
  gsn_panel(wks,plot(0),(/1,1/),rtsP)     ; now draw as one plot
 ;************************************************
; MJO "strong" index 
;************************************************
  rts@gsnYRefLine        = 1.0
  rts@gsnYRefLineColor   = "black"
  rts@xyMonoDashPattern  = True
  rts@xyLineColors       = (/"black", "blue"/)
  rts@xyLineThicknesses  = (/1, 2/)
  rts@pmLegendDisplayMode    = "Always"            ; turn on legend
  rts@pmLegendWidthF         = 0.12                ; Change width and
  rts@pmLegendHeightF        = 0.10                ; height of legend.
  rts@pmLegendParallelPosF   = 0.86                ; move units right
  rts@pmLegendOrthogonalPosF = -0.32               ; move units down
  rts@xyExplicitLegendLabels = (/"daily", "91-day runavg" /)

  mjo_ind_plt = new ( (/2,ntim/), typeof(mjo_ts_index_ON))
  mjo_ind_plt(0,:) = mjo_ts_index_ON
  mjo_ind_plt(1,:) = (/ mjo_ts_index_smt_ON /)
  plot(0) = gsn_csm_xy(wks, yrfrac,mjo_ind_plt,rts)

  rtsP@gsnPanelMainString   = "MJO Index(ON): square root of (PC1^2+ PC2^2) : 15S-15N: "+yrStrt+"-"+yrLast 
  gsn_panel(wks,plot(0),(/1,1/),rtsP)     ; now draw as one plot

end
