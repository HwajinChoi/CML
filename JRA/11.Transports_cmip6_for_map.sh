#!/bin/bash
##################################################################################
## This is for CMIP6 data. you should use input data which are deleted leap days.
##################################################################################
# HadGEM3-GC31-LL is excepted.
for year in {1960..2019} ;do
  Q=`ls /disk3/hjchoi/JRA55/NC/for_conv/spfh/spfh.day.${year}.nc`
  V=`ls /disk3/hjchoi/JRA55/NC/for_conv/vgrd/vgrd.day.${year}.nc`

cat <<EOF > ./transports_JRA.ncl
;-------------------------------------------------------------------------------------
; If you want to use this code, you should use input data which are deleted leap day
;-------------------------------------------------------------------------------------
begin

dir2="/disk3/hjchoi/JRA55/transport/no_integral" ; location of saved

f=addfile("${Q}","r")
g=addfile("${V}","r")

q=f->spfh
v=g->vgrd
lon=f->lon
lat=f->lat
level=f->lev
;level = 1000, 850, 700, 500
gravity=9.8
;------Mean Meridional Circulation---------------------
q_month_avg=calculate_monthly_values(q,"avg",0,True);Averaged monthly value
v_month_avg=calculate_monthly_values(v,"avg",0,True);time*level*lat*lon

q_month_zonal=dim_avg_n_Wrap(q_month_avg,3); Averaged zonal monthly value 
v_month_zonal=dim_avg_n_Wrap(v_month_avg,3); time*level*lat

MMC=q_month_zonal*v_month_zonal
copy_VarCoords(v_month_zonal,MMC)
MMC@long_name="Mean Meridional Circulation"
;-------Stationary Eddy----------------------------------
dim0=dimsizes(q_month_avg)
q_imsi=new((/dim0(0),dim0(1),dim0(2),dim0(3)/),"float")
v_imsi=new((/dim0(0),dim0(1),dim0(2),dim0(3)/),"float")

do i = 0, dim0(3)-1
q_imsi(:,:,:,i)=q_month_zonal(:,:,:)
v_imsi(:,:,:,i)=v_month_zonal(:,:,:)
end do

q_month_zonal_ano=q_month_avg-q_imsi
v_month_zonal_ano=v_month_avg-v_imsi
SE=q_month_zonal_ano*v_month_zonal_ano
copy_VarCoords(q_month_avg,SE)
SE@long_name="Stationary Eddy"
;------Transient Eddy------------------------------------
dim1=dimsizes(q)
q_imsi2=new((/dim1(0),dim1(1),dim1(2),dim1(3)/),"float")
v_imsi2=new((/dim1(0),dim1(1),dim1(2),dim1(3)/),"float")
year=dim1(0)/365

do n=0,year-1
do j=1,31
q_imsi2(j-1+365*n,:,:,:)=q_month_avg(12*n,:,:,:) ; 1
q_imsi2(59+j-1+365*n,:,:,:)=q_month_avg(12*n+2,:,:,:) ; 3
q_imsi2(120+j-1+365*n,:,:,:)=q_month_avg(12*n+4,:,:,:) ; 5
q_imsi2(181+j-1+365*n,:,:,:)=q_month_avg(12*n+6,:,:,:) ; 7
q_imsi2(212+j-1+365*n,:,:,:)=q_month_avg(12*n+7,:,:,:) ; 8
q_imsi2(273+j-1+365*n,:,:,:)=q_month_avg(12*n+9,:,:,:) ; 10
q_imsi2(334+j-1+365*n,:,:,:)=q_month_avg(12*n+11,:,:,:) ; 12

v_imsi2(j-1+365*n,:,:,:)=v_month_avg(12*n,:,:,:) ; 1
v_imsi2(59+j-1+365*n,:,:,:)=v_month_avg(12*n+2,:,:,:) ; 3
v_imsi2(120+j-1+365*n,:,:,:)=v_month_avg(12*n+4,:,:,:) ; 5
v_imsi2(181+j-1+365*n,:,:,:)=v_month_avg(12*n+6,:,:,:) ; 7
v_imsi2(212+j-1+365*n,:,:,:)=v_month_avg(12*n+7,:,:,:) ; 8
v_imsi2(273+j-1+365*n,:,:,:)=v_month_avg(12*n+9,:,:,:) ; 10
v_imsi2(334+j-1+365*n,:,:,:)=v_month_avg(12*n+11,:,:,:) ; 12
end do
end do

do n=0,year-1
do k=1,30
q_imsi2(90+k-1+365*n,:,:,:)=q_month_avg(12*n+3,:,:,:) ; 4
q_imsi2(151+k-1+365*n,:,:,:)=q_month_avg(12*n+5,:,:,:) ; 6
q_imsi2(243+k-1+365*n,:,:,:)=q_month_avg(12*n+8,:,:,:) ; 9
q_imsi2(304+k-1+365*n,:,:,:)=q_month_avg(12*n+10,:,:,:) ; 11

v_imsi2(90+k-1+365*n,:,:,:)=v_month_avg(12*n+3,:,:,:) ; 4
v_imsi2(151+k-1+365*n,:,:,:)=v_month_avg(12*n+5,:,:,:) ; 6
v_imsi2(243+k-1+365*n,:,:,:)=v_month_avg(12*n+8,:,:,:) ; 9
v_imsi2(304+k-1+365*n,:,:,:)=v_month_avg(12*n+10,:,:,:) ; 11
end do
end do
do n=0,year-1
do l=1,28
q_imsi2(31+l-1+365*n,:,:,:)=q_month_avg(12*n+1,:,:,:) ; 2
v_imsi2(31+l-1+365*n,:,:,:)=v_month_avg(12*n+1,:,:,:) ; 2
end do
end do

q_daily_ano=q-q_imsi2
v_daily_ano=v-v_imsi2
te=q_daily_ano*v_daily_ano
copy_VarCoords(q,te)
TE=calculate_monthly_values(te,"avg",0,True);Averaged monthly value
;TE=dim_avg_n_Wrap(te_month_avg,3)
TE@long_name="Transient Eddy"
;---------Mean Meridional Flux------------------------
mmf=q*v
copy_VarCoords(q,mmf)
MMF=calculate_monthly_values(mmf,"avg",0,True)
;MMF=dim_avg_n_Wrap(mmf_month_avg,3)
MMF@long_name="Mean Meridional Flux"
;---------comparing both sides of calculation-------------------
;dim2=dimsizes(MMC)
;sumof3=new((/dim2(0),dim2(1),dim2(2)/),"float")
;sumof3=MMC+SE+TE
;
;diff=MMF-sumof3
;dif=flt2dble(diff)
;print(diff(0:7,0:7,0:7))
;exit
;--------------------------------------------------------
system("rm -rf "+dir2+"/map.MMF_JRA55_${year}.nc")
outf=addfile(    dir2+"/map.MMF_JRA55_${year}.nc","c")
outf->MMF=MMF
outf->SE=SE
outf->TE=TE
outf->lat=lat
outf->level=level
print("Accomplished  MMF_JRA55_${year}.nc")
delete([/f,g,MMF,MMC,SE,TE,lat,level,q,v,q_month_avg,v_month_avg,q_month_zonal,v_month_zonal/])
delete([/q_imsi,v_imsi,q_imsi2,v_imsi2,dim1,te/])
delete([/q_month_zonal_ano,v_month_zonal_ano,mmf,q_daily_ano,v_daily_ano/])

end

EOF

ncl ./transports_JRA.ncl
rm -rf ./transports_JRA.ncl

done

