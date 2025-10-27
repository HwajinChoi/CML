;---------------------------------------------------------------------
;     This NCL script is for MMFs which are averaged longitude.
;     When data are vertically integrated, NCL needs no missing data. 
;     Some models has missing value near the South pole.
;     Thus, I only used only the Northern parts.
;     NCL's spherical harmonics require the data to be ordered South->North.
;---------------------------------------------------------------------
begin

dir1="/disk3/hjchoi/JRA55/NC/pressfc/"; location of pressure
dir2="/disk3/hjchoi/JRA55/transport/no_integral_lon_averaged/" ;location of MMFs
outdir="/disk3/hjchoi/JRA55/transport/MMF_lon_averaged/"

  f=addfile(dir2+"MMF.no_integ.JRA55.1960-2019.nc","r")
  g=addfile(dir1+"pressfc.1960-2019.mon.nc","r")
  mmc=f->MMC(:,:,{0:90});time*plev*lat
  mmf=f->MMF(:,:,{0:90});time*plev*lat
  se=f->SE(:,:,{0:90});time*plev*lat
  te=f->TE(:,:,{0:90});time*plev*lat
  lat=f->lat({0:90})
  lev=f->lev
  time=f->time
  sfp=g->pressfc(:,{0:90},:);time*lat ;pascal
;  se := se(:,:,::-1)
;  te := te(:,:,::-1)
;  lat := lat(::-1)
;  mmc := mmc(:,:,::-1)
;  mmf := mmf(:,:,::-1)
;  sfp := sfp(:,::-1)
  sfp=sfp*0.01
  sfp@units="millibars"

  ptop=500
  grav=9.8
  vopt=1
  dp=dpres_plevel_Wrap(lev,sfp,ptop,0) ;time*level*lat*lon
  dp1=dim_avg_n_Wrap(dp,3)

  mmc_integ=wgt_vertical_n(mmc,dp1,vopt,1)
  mmf_integ=wgt_vertical_n(mmf,dp1,vopt,1)
  te_integ=wgt_vertical_n(te,dp1,vopt,1)
  se_integ=wgt_vertical_n(se,dp1,vopt,1)

  MMC=(mmc_integ/grav)*100
  MMF=(mmf_integ/grav)*100
  SE=(se_integ/grav)*100
  TE=(te_integ/grav)*100
  copy_VarCoords(mmc_integ,MMC)
  copy_VarCoords(mmf_integ,MMF)
  copy_VarCoords(se_integ,SE)
  copy_VarCoords(te_integ,TE)
  MMC@units="kg*m-1*s-1"
  MMF@units="kg*m-1*s-1"
  SE@units="kg*m-1*s-1"
  TE@units="kg*m-1*s-1"

  system("rm -rf "+outdir+"/MMF_integral.JRA55_1960-2019.nc")
  outf=addfile(    outdir+"/MMF_integral.JRA55_1960-2019.nc","c")
  outf->MMC=MMC
  outf->MMF=MMF
  outf->SE=SE
  outf->TE=TE
  outf->lat=lat
  outf->time=time
  print("Accomplished  MMF_integral.JRA55_1960-2019.nc")
  delete([/dp,dp1,mmc_integ,mmf_integ,te_integ,se_integ,MMC,MMF,SE,TE,outf,lat,time,sfp/])
  delete([/f,g,mmc,mmf,se,te,lev/])

end
