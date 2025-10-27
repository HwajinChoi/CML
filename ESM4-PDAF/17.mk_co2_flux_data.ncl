begin
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/co2/"
dir2="/media/cmlws/Data2/hjc/ESM4-PDAF/image/"
dir3="/media/cmlws/Data2/hjc/ESM4-PDAF/data/ODA/"
dir4="/media/cmlws/Data2/hjc/ESM4-PDAF/data/AODA/"

f1=addfile(dir3+"dic_stf_gas.mon.ESM4-PDAF_ODA.weights.2015-2021.1x1.nc","r")
dic_ODA=f1->dic_stf_gas(:,:,:)
dic_ODA=dic_ODA*(-1)

f2=addfile(dir4+"dic_stf_gas.mon.ESM4-PDAF_AODA.weights.2010-2021.1x1.nc","r")
dic_AODA=f2->dic_stf_gas(:,:,:);"mole/m^2/sec"
lon_aoda0=f2->lon
lon_aoda=dble2flt(lon_aoda0)
lat_aoda0=f2->lat
lat_aoda=dble2flt(lat_aoda0)
dic_AODA@_FillValue=-9e+33
dic_AODA=dic_AODA*(-1)

g1=addfile(dir1+"co2_flux_CSIR_ML6_weights_201001-202012.nc","r")
dic_CSIR0=g1->fgco2 ; "mol/m2/s"
dic_CSIR=dble2flt(dic_CSIR0)
dic_CSIR@_FillValue=-9e+33

g2=addfile(dir1+"CO2_flux_ECCO-Darwin_v05_r360x180_weighted_199501-201712.nc","r")
dic_Darwin0=g2->CO2_flux(180:275,:,:) ;1995-2017
dic_Darwin=where(dic_Darwin0 .eq. 0,-999,dic_Darwin0)
copy_VarMeta(dic_Darwin0,dic_Darwin)
dic_Darwin@_FillValue=-999 ; "mol C m^-2 s^-1"

g3=addfile(dir1+"co2_flux_JMA_v2020_weights_201001-202012.nc","r")
dic_JMA=g3->flux ; "mol/m2/yr"
dic_JMA@_FillValue=-9e+33

g4=addfile(dir1+"co2_flux_Jena-MLS_v2022_201001-202012.nc","r")
dic_Jena=g4->co2flux_ocean ; "PgC/yr"
dic_Jena1=month_to_annual(dic_Jena,1)
dic_Jena2=where(dic_Jena1 .eq. 0,-999,dic_Jena1)
copy_VarMeta(dic_Jena1,dic_Jena2)
dic_Jena2@_FillValue=-999
dic_Jena3=dim_sum_n_Wrap(dic_Jena2,1)
DIC_JENA=dim_sum_n_Wrap(dic_Jena3,1)

g5=addfile(dir1+"co2_flux_LDEO-HPD_v2021_weights_201001-201812.nc","r")
dic_LDEO0=g5->fgco2 ; "mol/m2/s"
dic_LDEO=dble2flt(dic_LDEO0)
dic_LDEO@_FillValue=-9e+33

g6=addfile(dir1+"co2_flux_MPI_SOM_FFN_v2022_weights_201001-202012.nc","r")
dic_MPI=g6->fgco2_smoothed ; "mol/m2/yr" ;
dic_MPI@_FillValue=-9e+33
;--------Unit Change => "PgC/yr" --------------
c_molar=44.01 ; g/mol
ocean_are=3.61*(10^8);km2
;--------------------------------------------
dic_CSIR=(dic_CSIR*60*60*24*365*c_molar)/(10^(15))
dic_CSIR@unit="PgC/yr"
dic_CSIR1=month_to_annual(dic_CSIR,1)
dic_CSIR2=dim_sum_n_Wrap(dic_CSIR1,1)
DIC_CSIR=dim_sum_n_Wrap(dic_CSIR2,1)
;--------------------------------------------
dic_Darwin=(dic_Darwin*60*60*24*365*c_molar)/(10^(15))
dic_Darwin@unit="PgC/yr"
dic_Darwin=(dic_Darwin)/1000
dic_Darwin2=month_to_annual(dic_Darwin,1)
dic_Darwin3=dim_sum_n_Wrap(dic_Darwin2,1)
DIC_DARWIN=dim_sum_n_Wrap(dic_Darwin3,1)
;--------------------------------------------
dic_JMA = (dic_JMA*c_molar)/(10^(15))
dic_JMA@unit="PgC/yr"
dic_JMA1=month_to_annual(dic_JMA,1)
dic_JMA1&lon=lon_aoda
dic_JMA1&lat=lat_aoda
dic_JMA2=dim_sum_n_Wrap(dic_JMA1,1)
DIC_JMA=dim_sum_n_Wrap(dic_JMA2,1)
;------------------------------------------------
dic_ODA = (dic_ODA*60*60*24*365*c_molar)/(10^(15))   ; yr and mass 
dic_ODA@unit="PgC/yr"
dic_ODA1=month_to_annual(dic_ODA,1)
dic_ODA2=dim_sum_n_Wrap(dic_ODA1,1)
DIC_ODA=dim_sum_n_Wrap(dic_ODA2,1)
;------------------------------------------------
dic_AODA = (dic_AODA*60*60*24*365*c_molar)/(10^(15))   ; yr and mass 
dic_AODA@unit="PgC/yr"
dic_AODA1=month_to_annual(dic_AODA,1)
dic_AODA2=dim_sum_n_Wrap(dic_AODA1,1)
DIC_AODA=dim_sum_n_Wrap(dic_AODA2,1)
;------------------------------------------------
dic_LDEO=(dic_LDEO*60*60*24*365*c_molar)/(10^(15)) 
dic_LDEO@unit="PgC/yr"
dic_LDEO1=month_to_annual(dic_LDEO,1)
dic_LDEO2=dim_sum_n_Wrap(dic_LDEO1,1)
DIC_LDEO=dim_sum_n_Wrap(dic_LDEO2,1)
;------------------------------------------------
dic_MPI=(dic_MPI*c_molar)/(10^(15))
dic_MPI@unit="PgC/yr"
dic_MPI1=month_to_annual(dic_MPI,0)
dic_MPI2=dim_sum_n_Wrap(dic_MPI1,1)
DIC_MPI=dim_sum_n_Wrap(dic_MPI2,1)
;---------------------------------------------------------------------------------
; DIC_DARWIN, DIC_JENA, DIC_CSIR, DIC_MPI, DIC_JMA, DIC_LDEO, DIC_ODA, DIC_AODA
;---------------------------------------------------------------------------------

printMinMax(DIC_DARWIN,0)
printMinMax(DIC_JENA,0)
printMinMax(DIC_CSIR,0)
printMinMax(DIC_MPI,0)
printMinMax(DIC_LDEO,0)
printMinMax(DIC_ODA,0)
exit


end
