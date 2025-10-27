#!/bin/bash

for O in "on" "off" ;do

 dir2=/media/cmlws/Data2/hjc/MJO/data/$O

cat > imsi.ncl << EOF
begin
f=addfile("${dir2}/olr.200001-201912.nc","r")
olr_test=f->olr
grid_yt=f->grid_yt
grid_xt=f->grid_xt
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

 system("rm -f ${dir2}/bf_30_60_olr_200001-201912.nc")
 out=addfile( "${dir2}/bf_30_60_olr_200001-201912.nc","c")
 out->olr_lz=olr_lz
 out->grid_yt=grid_yt
 out->grid_xt=grid_xt

end
EOF

ncl imsi.ncl
rm -rf imsi.ncl 

done
