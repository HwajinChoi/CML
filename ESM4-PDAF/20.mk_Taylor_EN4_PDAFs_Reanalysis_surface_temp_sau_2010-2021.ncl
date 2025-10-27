begin
dir0="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/EN4/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dir5="/media/cmlws/Data2/hjc/ESM4-PDAF/data/corr/"

;--------------------- Temperature -----------------------
f1=addfile(dir1+"EN.4.2.2.r360x180.temperature_201001-202112.nc","r")
en4_temp0=f1->temperature(:,0,:,:)
en4_temp0_15=f1->temperature(60:143,0,:,:)
en4_temp0_1017=f1->temperature(0:95,0,:,:)

en4_temp=dim_avg_n_Wrap(en4_temp0,0)
en4_temp_15=dim_avg_n_Wrap(en4_temp0_15,0)
en4_temp_1017=dim_avg_n_Wrap(en4_temp0_1017,0)

g1=addfile(dir2+"tos.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
tos_oda0=g1->tos
tos_oda=dim_avg_n_Wrap(tos_oda0,0)

lat=g1->lat
rad=4.0*atan(1.0)/180.0
clat=cos(rad*lat)

h1=addfile(dir3+"tos.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
tos_aoda0=h1->tos
tos_aoda=dim_avg_n_Wrap(tos_aoda0,0)

s1=addfile(dir4+"ECDA/sst_ATMassim_10NS_100err_WOA_0.1_2nd.201001-201712.nc","r")
tos_ecda0=s1->sst
tos_ecda=dim_avg_n_Wrap(tos_ecda0,0)

k1=addfile(dir4+"GODAS/pottmp.2010-2021.nc","r")
tos_godas0=k1->pottmp(:,0,:,:)
tos_godas=dim_avg_n_Wrap(tos_godas0,0)

d1=addfile(dir4+"ECCO/THETA_ECCO_r360x180_201001-201712.nc","r")
tos_ecco0=d1->THETA(:,0,:,:)
tos_ecco=dim_avg_n_Wrap(tos_ecco0,0)

b1=addfile(dir4+"SODA/temp.soda3.15.2_r360x180_2010-2021.nc","r")
tos_soda0=b1->temp(:,0,:,:)
tos_soda=dim_avg_n_Wrap(tos_soda0,0)
;--------------------- Salinity -----------------------
f2=addfile(dir1+"EN.4.2.2.r360x180.salinity_201001-202112.nc","r")
en4_sal0=f2->salinity(:,0,:,:)
en4_sal0_15=f2->salinity(60:143,0,:,:)
en4_sal0_1017=f2->salinity(0:95,0,:,:)

en4_sal=dim_avg_n_Wrap(en4_sal0,0)
en4_sal_15=dim_avg_n_Wrap(en4_sal0_15,0)
en4_sal_1017=dim_avg_n_Wrap(en4_sal0_1017,0)

g2=addfile(dir2+"so.mon.ESM4-PDAF_ODA.2015-2021.1x1.nc","r")
so_oda0=g2->so(:,0,:,:)
so_oda=dim_avg_n_Wrap(so_oda0,0)

h2=addfile(dir3+"so.mon.ESM4-PDAF_AODA.2010-2021.1x1.nc","r")
so_aoda0=h2->so(:,0,:,:)
so_aoda=dim_avg_n_Wrap(so_aoda0,0)

s2=addfile(dir4+"ECDA/salt_ATMassim_10NS_100err_WOA_0.1_2nd.201001-201712.nc","r")
so_ecda0=s2->salt(:,0,:,:)
so_ecda=dim_avg_n_Wrap(so_ecda0,0)

k2=addfile(dir4+"GODAS/salt.2010-2021.nc","r")
so_godas0=k2->salt(:,0,:,:)
so_godas0=so_godas0*1000
so_godas=dim_avg_n_Wrap(so_godas0,0)

d2=addfile(dir4+"ECCO/SALT_ECCO_r360x180_201001-201712.nc","r")
so_ecco0=d2->SALT(:,0,:,:)
so_ecco=dim_avg_n_Wrap(so_ecco0,0)

b2=addfile(dir4+"SODA/salt.soda3.15.2_r360x180_2010-2021.nc","r")
so_soda0=b2->salt(:,0,:,:)
so_soda=dim_avg_n_Wrap(so_soda0,0)
;----------------Correlation-----------------------------------------------------
taylor_temp_oda=taylor_stats(tos_oda,en4_temp_15,clat,0)
taylor_temp_aoda=taylor_stats(tos_aoda,en4_temp,clat,0)
taylor_temp_ecda=taylor_stats(tos_ecda,en4_temp_1017,clat,0)
taylor_temp_godas=taylor_stats(tos_godas,en4_temp,clat,0)
taylor_temp_ecco=taylor_stats(tos_ecco,en4_temp_1017,clat,0)
taylor_temp_soda=taylor_stats(tos_soda,en4_temp,clat,0)

taylor_sal_oda=taylor_stats(so_oda,en4_sal_15,clat,0)
taylor_sal_aoda=taylor_stats(so_aoda,en4_sal,clat,0)
taylor_sal_ecda=taylor_stats(so_ecda,en4_sal_1017,clat,0)
taylor_sal_godas=taylor_stats(so_godas,en4_sal,clat,0)
taylor_sal_ecco=taylor_stats(so_ecco,en4_sal_1017,clat,0)
taylor_sal_soda=taylor_stats(so_soda,en4_sal,clat,0)

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


system("rm -f "+dir5+"Taylor_stats_EN4_PDAFs_reanalysis_SURFACE_temp_sal_total_period.nc")
out=addfile(dir5+"Taylor_stats_EN4_PDAFs_reanalysis_SURFACE_temp_sal_total_period.nc","c")
out->sal_ratio=sal_ratio
out->temp_ratio=temp_ratio
out->sal_cc=sal_cc
out->temp_cc=temp_cc

end
