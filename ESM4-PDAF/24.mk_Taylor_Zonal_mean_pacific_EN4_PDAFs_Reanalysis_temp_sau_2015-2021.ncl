begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/EN4/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir5="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"

f1=addfile(dir1+"EN.4.2.2.r360x180.temperature_201001-202112.nc","r")
depth_en4=f1->depth({0:650})

en4_temp0_15=f1->temperature(60:143,{0:650},:,{150:240})
en4_temp0_1517=f1->temperature(60:95,{0:650},:,{150:240})

en4_temp1_15=dim_avg_n_Wrap(en4_temp0_15,3)
en4_temp2_15=dim_avg_n_Wrap(en4_temp1_15,0) ; depth x lat
en4_temp1_1517=dim_avg_n_Wrap(en4_temp0_1517,3)
en4_temp2_1517=dim_avg_n_Wrap(en4_temp1_1517,0) ; depth x lat

en4_temp2_15 := en4_temp2_15(lat|:,depth|:)
en4_temp2_1517 :=en4_temp2_1517(lat|:,depth|:)

f2=addfile(dir1+"EN.4.2.2.r360x180.salinity_201001-202112.nc","r")
en4_sal0_15=f2->salinity(60:143,{0:650},:,{150:240})
en4_sal0_1517=f2->salinity(0:95,{0:650},:,{150:240})

en4_sal1_15=dim_avg_n_Wrap(en4_sal0_15,3)
en4_sal2_15=dim_avg_n_Wrap(en4_sal1_15,0)

en4_sal1_1517=dim_avg_n_Wrap(en4_sal0_1517,3)
en4_sal2_1517=dim_avg_n_Wrap(en4_sal1_1517,0)

en4_sal2_15 := en4_sal2_15(lat|:,depth|:)
en4_sal2_1517 := en4_sal2_1517(lat|:,depth|:)
;------------------------------------------------------------------------
g1=addfile(dir2+"thetao.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
thetao_oda0=g1->thetao(:,{0:650},:,{150:240})
z=g1->z_l({0:650})
lat=g1->lat
thetao_oda1=dim_avg_n_Wrap(thetao_oda0,3)
thetao_oda2=dim_avg_n_Wrap(thetao_oda1,0)

h1=addfile(dir3+"thetao.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
thetao_aoda0=h1->thetao(60:,{0:650},:,{150:240})
thetao_aoda1=dim_avg_n_Wrap(thetao_aoda0,3)
thetao_aoda2=dim_avg_n_Wrap(thetao_aoda1,0)


s1=addfile(dir4+"ECDA/temp_ATMassim_10NS_100err_WOA_0.1_2nd.201001-201712.nc","r")
thetao_ecda0=s1->temp(60:,{0:650},:,{150:240})
thetao_ecda1=dim_avg_n_Wrap(thetao_ecda0,3)
thetao_ecda2=dim_avg_n_Wrap(thetao_ecda1,0)
depth_ecda=s1->st_ocean({0:650})
thetao_ecda2 := thetao_ecda2(yt_ocean|:,st_ocean|:)

k1=addfile(dir4+"GODAS/pottmp.2010-2021.nc","r")
thetao_godas0=k1->pottmp(60:,{0:650},:,{150:240})
thetao_godas1=dim_avg_n_Wrap(thetao_godas0,3)
thetao_godas2=dim_avg_n_Wrap(thetao_godas1,0)
depth_godas=k1->level({0:650})
thetao_godas2 := thetao_godas2(lat|:,level|:)

d1=addfile(dir4+"ECCO/THETA_ECCO_r360x180_201001-201712.nc","r")
thetao_ecco0=d1->THETA(60:,{0:-650},:,{150:240})
thetao_ecco1=dim_avg_n_Wrap(thetao_ecco0,3)
thetao_ecco2=dim_avg_n_Wrap(thetao_ecco1,0)
depth_ecco=d1->Z({0:-650})
depth_ecco=depth_ecco*(-1)
thetao_ecco2 := thetao_ecco2(lat|:,Z|:)

b1=addfile(dir4+"SODA/temp.soda3.15.2_r360x180_2010-2021.nc","r")
thetao_soda0=b1->temp(60:,{0:650},:,{150:240})
thetao_soda1=dim_avg_n_Wrap(thetao_soda0,3)
thetao_soda2=dim_avg_n_Wrap(thetao_soda1,0)
depth_soda=b1->st_ocean({0:650})
thetao_soda2 := thetao_soda2(lat|:,st_ocean|:)
;------------------------------------------------------------------------
g2=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
so_oda0=g2->so(:,{0:650},:,{150:240})
so_oda1=dim_avg_n_Wrap(so_oda0,3)
so_oda2=dim_avg_n_Wrap(so_oda1,0)

h2=addfile(dir3+"so.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
so_aoda0=h2->so(60:,{0:650},:,{150:240})
so_aoda1=dim_avg_n_Wrap(so_aoda0,3)
so_aoda2=dim_avg_n_Wrap(so_aoda1,0)

s2=addfile(dir4+"ECDA/salt_ATMassim_10NS_100err_WOA_0.1_2nd.201001-201712.nc","r")
so_ecda0=s2->salt(60:,{0:650},:,{150:240})
so_ecda1=dim_avg_n_Wrap(so_ecda0,3)
so_ecda2=dim_avg_n_Wrap(so_ecda1,0)
so_ecda2 := so_ecda2(yt_ocean|:,st_ocean|:)

k2=addfile(dir4+"GODAS/salt.2010-2021.nc","r")
so_godas0=k2->salt(60:,{0:650},:,{150:240})
so_godas1=dim_avg_n_Wrap(so_godas0,3)
so_godas2=dim_avg_n_Wrap(so_godas1,0)
so_godas2=so_godas2*1000
so_godas2 := so_godas2(lat|:,level|:)

d2=addfile(dir4+"ECCO/SALT_ECCO_r360x180_201001-201712.nc","r")
so_ecco0=d2->SALT(60:,{0:-650},:,{150:240})
so_ecco1=dim_avg_n_Wrap(so_ecco0,3)
so_ecco2=dim_avg_n_Wrap(so_ecco1,0)
so_ecco2 := so_ecco2(lat|:,Z|:)

b2=addfile(dir4+"SODA/salt.soda3.15.2_r360x180_2010-2021.nc","r")
so_soda0=b2->salt(60:,{0:650},:,{150:240})
so_soda1=dim_avg_n_Wrap(so_soda0,3)
so_soda2=dim_avg_n_Wrap(so_soda1,0)
so_soda2 := so_soda2(lat|:,st_ocean|:)

;-----For depth interporation-------------
en4_temp3_15=int2p_n_Wrap(depth_en4,en4_temp2_15,z,-1,1)
en4_temp3_1517=int2p_n_Wrap(depth_en4,en4_temp2_1517,z,-1,1)

en4_temp3_1517 := en4_temp3_1517(z_l|:,lat|:)
en4_temp3_15 := en4_temp3_15(z_l|:,lat|:)

thetao_ecda3=int2p_n_Wrap(depth_ecda,thetao_ecda2,z,-1,1)
thetao_godas3=int2p_n_Wrap(depth_godas,thetao_godas2,z,-1,1)
thetao_ecco3=int2p_n_Wrap(depth_ecco,thetao_ecco2,z,-1,1)
thetao_soda3=int2p_n_Wrap(depth_soda,thetao_soda2,z,-1,1)

thetao_ecda3 := thetao_ecda3(z_l|:,yt_ocean|:)
thetao_godas3 := thetao_godas3(z_l|:,lat|:)
thetao_ecco3 := thetao_ecco3(z_l|:,lat|:)
thetao_soda3 := thetao_soda3(z_l|:,lat|:)

en4_sal3_15=int2p_n_Wrap(depth_en4,en4_sal2_15,z,-1,1)
en4_sal3_1517=int2p_n_Wrap(depth_en4,en4_sal2_1517,z,-1,1)

en4_sal3_15 := en4_sal3_15(z_l|:,lat|:)
en4_sal3_1517 := en4_sal3_1517(z_l|:,lat|:)

so_ecda3=int2p_n_Wrap(depth_ecda,so_ecda2,z,-1,1)
so_godas3=int2p_n_Wrap(depth_godas,so_godas2,z,-1,1)
so_ecco3=int2p_n_Wrap(depth_ecco,so_ecco2,z,-1,1)
so_soda3=int2p_n_Wrap(depth_soda,so_soda2,z,-1,1)

so_ecda3 := so_ecda3(z_l|:,yt_ocean|:)
so_godas3 := so_godas3(z_l|:,lat|:)
so_ecco3 := so_ecco3(z_l|:,lat|:)
so_soda3 := so_soda3(z_l|:,lat|:)
;--- z weighting---------------------------------
 z_w=new(15,double)
 z_w(0)=2.5/600
 do i=0,13
  z_w(i+1)=(z(i+1)-z(i))/600.
 end do
;--------------------------------------

taylor_weight_temp_oda=taylor_stats(thetao_oda2,en4_temp3_15,z_w,0)
taylor_weight_temp_aoda=taylor_stats(thetao_aoda2,en4_temp3_15,z_w,0)
taylor_weight_temp_ecda=taylor_stats(thetao_ecda3,en4_temp3_1517,z_w,0)
taylor_weight_temp_godas=taylor_stats(thetao_godas3,en4_temp3_15,z_w,0)
taylor_weight_temp_ecco=taylor_stats(thetao_ecco3,en4_temp3_1517,z_w,0)
taylor_weight_temp_soda=taylor_stats(thetao_soda3,en4_temp3_15,z_w,0)

taylor_weight_sal_oda=taylor_stats(so_oda2,en4_sal3_15,z_w,0)
taylor_weight_sal_aoda=taylor_stats(so_aoda2,en4_sal3_15,z_w,0)
taylor_weight_sal_ecda=taylor_stats(so_ecda3,en4_sal3_1517,z_w,0)
taylor_weight_sal_godas=taylor_stats(so_godas3,en4_sal3_15,z_w,0)
taylor_weight_sal_ecco=taylor_stats(so_ecco3,en4_sal3_1517,z_w,0)
taylor_weight_sal_soda=taylor_stats(so_soda3,en4_sal3_15,z_w,0)

;--------------------------------------
taylor_temp_oda=taylor_stats(thetao_oda2,en4_temp3_15,1.,0)
taylor_temp_aoda=taylor_stats(thetao_aoda2,en4_temp3_15,1.,0)
taylor_temp_ecda=taylor_stats(thetao_ecda3,en4_temp3_1517,1.,0)
taylor_temp_godas=taylor_stats(thetao_godas3,en4_temp3_15,1.,0)
taylor_temp_ecco=taylor_stats(thetao_ecco3,en4_temp3_1517,1.,0)
taylor_temp_soda=taylor_stats(thetao_soda3,en4_temp3_15,1.,0)

taylor_sal_oda=taylor_stats(so_oda2,en4_sal3_15,1.,0)
taylor_sal_aoda=taylor_stats(so_aoda2,en4_sal3_15,1.,0)
taylor_sal_ecda=taylor_stats(so_ecda3,en4_sal3_1517,1.,0)
taylor_sal_godas=taylor_stats(so_godas3,en4_sal3_15,1.,0)
taylor_sal_ecco=taylor_stats(so_ecco3,en4_sal3_1517,1.,0)
taylor_sal_soda=taylor_stats(so_soda3,en4_sal3_15,1.,0)
;--------------------------------------
temp_ratio=new(6,double)
temp_ratio(0)=taylor_temp_oda(1)
temp_ratio(1)=taylor_temp_aoda(1)
temp_ratio(2)=taylor_temp_ecda(1)
temp_ratio(3)=taylor_temp_godas(1)
temp_ratio(4)=taylor_temp_ecco(1)
temp_ratio(5)=taylor_temp_soda(1)
temp_ratio!0="data"

temp_cc=new(6,double)
temp_cc(0)=taylor_temp_oda(0)
temp_cc(1)=taylor_temp_aoda(0)
temp_cc(2)=taylor_temp_ecda(0)
temp_cc(3)=taylor_temp_godas(0)
temp_cc(4)=taylor_temp_ecco(0)
temp_cc(5)=taylor_temp_soda(0)
temp_cc!0="data"

sal_ratio=new(6,double)
sal_ratio(0)=taylor_sal_oda(1)
sal_ratio(1)=taylor_sal_aoda(1)
sal_ratio(2)=taylor_sal_ecda(1)
sal_ratio(3)=taylor_sal_godas(1)
sal_ratio(4)=taylor_sal_ecco(1)
sal_ratio(5)=taylor_sal_soda(1)
sal_ratio!0="data"

sal_cc=new(6,double)
sal_cc(0)=taylor_sal_oda(0)
sal_cc(1)=taylor_sal_aoda(0)
sal_cc(2)=taylor_sal_ecda(0)
sal_cc(3)=taylor_sal_godas(0)
sal_cc(4)=taylor_sal_ecco(0)
sal_cc(5)=taylor_sal_soda(0)
sal_cc!0="data"
;--------------------------------------
system("rm -f "+dir5+"no_weight_Taylor_stats_EN4_PDAFs_reanalysis_Zonal_mean_Pacific_temp_sal_from_2015.nc")
out=addfile(dir5+"no_weight_Taylor_stats_EN4_PDAFs_reanalysis_Zonal_mean_Pacific_temp_sal_from_2015.nc","c")
out->sal_ratio=sal_ratio
out->temp_ratio=temp_ratio
out->sal_cc=sal_cc
out->temp_cc=temp_cc
;--------------------------------------
temp_weight_ratio=new(6,double)
temp_weight_ratio(0)=taylor_weight_temp_oda(1)
temp_weight_ratio(1)=taylor_weight_temp_aoda(1)
temp_weight_ratio(2)=taylor_weight_temp_ecda(1)
temp_weight_ratio(3)=taylor_weight_temp_godas(1)
temp_weight_ratio(4)=taylor_weight_temp_ecco(1)
temp_weight_ratio(5)=taylor_weight_temp_soda(1)
temp_weight_ratio!0="data"

temp_weight_cc=new(6,double)
temp_weight_cc(0)=taylor_weight_temp_oda(0)
temp_weight_cc(1)=taylor_weight_temp_aoda(0)
temp_weight_cc(2)=taylor_weight_temp_ecda(0)
temp_weight_cc(3)=taylor_weight_temp_godas(0)
temp_weight_cc(4)=taylor_weight_temp_ecco(0)
temp_weight_cc(5)=taylor_weight_temp_soda(0)
temp_weight_cc!0="data"

sal_weight_ratio=new(6,double)
sal_weight_ratio(0)=taylor_weight_sal_oda(1)
sal_weight_ratio(1)=taylor_weight_sal_aoda(1)
sal_weight_ratio(2)=taylor_weight_sal_ecda(1)
sal_weight_ratio(3)=taylor_weight_sal_godas(1)
sal_weight_ratio(4)=taylor_weight_sal_ecco(1)
sal_weight_ratio(5)=taylor_weight_sal_soda(1)
sal_weight_ratio!0="data"

sal_weight_cc=new(6,double)
sal_weight_cc(0)=taylor_weight_sal_oda(0)
sal_weight_cc(1)=taylor_weight_sal_aoda(0)
sal_weight_cc(2)=taylor_weight_sal_ecda(0)
sal_weight_cc(3)=taylor_weight_sal_godas(0)
sal_weight_cc(4)=taylor_weight_sal_ecco(0)
sal_weight_cc(5)=taylor_weight_sal_soda(0)
sal_weight_cc!0="data"
;--------------------------------------
system("rm -f "+dir5+"weight_Taylor_stats_EN4_PDAFs_reanalysis_Zonal_mean_Pacific_temp_sal_from_2015.nc")
out=addfile(dir5+"weight_Taylor_stats_EN4_PDAFs_reanalysis_Zonal_mean_Pacific_temp_sal_from_2015.nc","c")
out->sal_ratio=sal_weight_ratio
out->temp_ratio=temp_weight_ratio
out->sal_cc=sal_weight_cc
out->temp_cc=temp_weight_cc
;--------------------------------------

end
