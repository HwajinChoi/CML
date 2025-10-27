begin
dir1="/media/cmlws/Data3/hjc/cobalt_on_ocean/"

f=addfile(dir1+"5y/20000101.olr.daily.nc","r")
olr_test=f->olr
dim=dimsizes(olr_test); time x lat x lon

; ***********************************************
; Specify assorted constants
; ***********************************************
  ca      = 60          ; Butterworth
  cb      = 30   
  nWgt    = 201        ; Lanczos: loose 730 each end (2years)                            
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
  olr_lz    = wgt_runave_n_Wrap ( olr_test, wgt, opt,0 )     
  olr_lz@long_name = "Lanczos Bandpass: "+cb+"-"+ca+" day"
  printVarSummary(olr_lz,0)                        



end
