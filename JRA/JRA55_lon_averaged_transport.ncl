begin
dir ="/disk3/hjchoi/JRA55/NC/for_conv/"
dir2="/disk3/hjchoi/JRA55/transport/no_integral_lon_averaged/"

do year = 1960,2019
f=addfile(dir+"/spfh/spfh.day."+year+".nc","r")
g=addfile(dir+"/vgrd/vgrd.day."+year+".nc","r")

q=f->spfh
v=g->vgrd

lon=f->lon
lat=f->lat
level=f->lev 
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
se=q_month_zonal_ano*v_month_zonal_ano
copy_VarCoords(q_month_avg,se)
SE=dim_avg_n_Wrap(se,3)
SE@long_name="Stationary Eddy"
;------Transient Eddy------------------------------------
dim1=dimsizes(q)
q_imsi2=new((/dim1(0),dim1(1),dim1(2),dim1(3)/),"float")
v_imsi2=new((/dim1(0),dim1(1),dim1(2),dim1(3)/),"float")

do j=1,31
q_imsi2(j-1,:,:,:)=q_month_avg(1-1,:,:,:) ; 1
q_imsi2(59+j-1,:,:,:)=q_month_avg(3-1,:,:,:) ; 3
q_imsi2(120+j-1,:,:,:)=q_month_avg(5-1,:,:,:) ; 5
q_imsi2(181+j-1,:,:,:)=q_month_avg(7-1,:,:,:) ; 7
q_imsi2(212+j-1,:,:,:)=q_month_avg(8-1,:,:,:) ; 8
q_imsi2(273+j-1,:,:,:)=q_month_avg(10-1,:,:,:) ; 10
q_imsi2(334+j-1,:,:,:)=q_month_avg(12-1,:,:,:) ; 12

v_imsi2(j-1,:,:,:)=v_month_avg(1-1,:,:,:) ; 1
v_imsi2(59+j-1,:,:,:)=v_month_avg(3-1,:,:,:) ; 3
v_imsi2(120+j-1,:,:,:)=v_month_avg(5-1,:,:,:) ; 5
v_imsi2(181+j-1,:,:,:)=v_month_avg(7-1,:,:,:) ; 7
v_imsi2(212+j-1,:,:,:)=v_month_avg(8-1,:,:,:) ; 8
v_imsi2(273+j-1,:,:,:)=v_month_avg(10-1,:,:,:) ; 10
v_imsi2(334+j-1,:,:,:)=v_month_avg(12-1,:,:,:) ; 12
end do

do k=1,30
q_imsi2(90+k-1,:,:,:)=q_month_avg(4-1,:,:,:) ; 4
q_imsi2(151+k-1,:,:,:)=q_month_avg(6-1,:,:,:) ; 6
q_imsi2(243+k-1,:,:,:)=q_month_avg(9-1,:,:,:) ; 9
q_imsi2(304+k-1,:,:,:)=q_month_avg(11-1,:,:,:) ; 11

v_imsi2(90+k-1,:,:,:)=v_month_avg(4-1,:,:,:) ; 4
v_imsi2(151+k-1,:,:,:)=v_month_avg(6-1,:,:,:) ; 6
v_imsi2(243+k-1,:,:,:)=v_month_avg(9-1,:,:,:) ; 9
v_imsi2(304+k-1,:,:,:)=v_month_avg(11-1,:,:,:) ; 11
end do

do l=1,28
q_imsi2(31+l-1,:,:,:)=q_month_avg(2-1,:,:,:) ; 2
v_imsi2(31+l-1,:,:,:)=v_month_avg(2-1,:,:,:) ; 2
end do

q_daily_ano=q-q_imsi2
v_daily_ano=v-v_imsi2
te=q_daily_ano*v_daily_ano
copy_VarCoords(q,te)
te_month_avg=calculate_monthly_values(te,"avg",0,True);Averaged monthly value
TE=dim_avg_n_Wrap(te_month_avg,3)
TE@long_name="Transient Eddy"
;---------Mean Meridional Flux------------------------
mmf=q*v
copy_VarCoords(q,mmf)
mmf_month_avg=calculate_monthly_values(mmf,"avg",0,True)
MMF=dim_avg_n_Wrap(mmf_month_avg,3)
MMF@long_name="Mean Meridional Flux"
;---------comparing both sides of calculation-------------------
;dim2=dimsizes(MMC)
;sumof3=new((/dim2(0),dim2(1),dim2(2)/),"float")
;sumof3=MMC+SE+TE

;diff=MMF-sumof3
;dif=flt2dble(diff)
;print(dif(0:7,0:7,0:7))
;exit
;--------------------------------------------------------
system("rm -rf "+dir2+"MMF.no_integ.JRA55."+year+".nc")
outf=addfile(    dir2+"MMF.no_integ.JRA55."+year+".nc","c")
outf->MMC=MMC
outf->MMF=MMF
outf->SE=SE
outf->TE=TE
outf->lat=lat
outf->level=level
print("The transport components of "+year+" are accomplished")
delete([/te,q,v,MMC,MMF,SE,TE,lat,level/])
delete([/q_imsi2,v_imsi2,q_imsi,v_imsi,mmf_month_avg,mmf,q_daily_ano,v_daily_ano/])
end do
end

