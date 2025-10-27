#! /bin/csh


cd /das_b/hkkim/pro/05.bpass 


#foreach var ( olr )
#sed s/FPS1000/${var}/g bpass_lanc_han.f > imsi1.${var}.f
#pgf imsi1.${var}.f
#a.out
#rm -rf imsi1.${var}.f a.out transf.d
#end

#foreach var ( olr tmpsfc tmp2m shtfl lhtfl rh2m dswrf prate )
foreach var ( FLUT SST PRECT )
#foreach var ( FPS LHFLX PRECC PRECL PRECSH PRECT SHFLX SST TS FLDS FSDS PBLH PSL TMQ )

sed s/FPS/${var}/g bpass_lanc_han.nolev.f > imsi.${var}.f
pgf90 imsi.${var}.f
a.out
rm -rf imsi.${var}.f a.out transf.d

end
