import numpy as np
import pandas as pd
import xarray as xr
from scipy import stats
from scipy import signal

d_path="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"
dset1 = xr.open_dataset(d_path+'tos_ODA_3moving_ano_2015-2021.nc')
tos_oda=dset1.tos.sel()
lon_oda=dset1.lon.sel()
lat_oda=dset1.lat.sel()
tos_oda_de=signal.detrend(tos_oda)

dset2 = xr.open_dataset(d_path+'tos_AODA_3moving_ano_2010-2021.nc')
tos_aoda=dset2.tos.sel()
lon_aoda=dset2.lon.sel()
lat_aoda=dset2.lat.sel()
tos_aoda_de=signal.detrend(tos_aoda)

dset3 = xr.open_dataset(d_path+'tos_ECDA_3moving_ano_2010-2017.nc')
tos_ecda=dset3.tos.sel()
lon_ecda=dset3.lon.sel()
lat_ecda=dset3.lat.sel()
tos_ecda_de=signal.detrend(tos_ecda)

dset4 = xr.open_dataset(d_path+'tos_GODAS_3moving_ano_2010-2021.nc')
tos_godas=dset4.tos.sel()
lon_godas=dset4.lon.sel()
lat_godas=dset4.lat.sel()
tos_godas_de=signal.detrend(tos_godas)

dset5 = xr.open_dataset(d_path+'tos_ECCO_3moving_ano_2010-2017.nc')
tos_ecco=dset5.tos.sel()
lon_ecco=dset5.lon.sel()
lat_ecco=dset5.lat.sel()
tos_ecco_de=signal.detrend(tos_ecco)

dset6 = xr.open_dataset(d_path+'tos_SODA_3moving_ano_2010-2017.nc')
tos_soda=dset6.tos.sel()
lon_soda=dset6.lon.sel()
lat_soda=dset6.lat.sel()
tos_soda_de=signal.detrend(tos_soda)

start1 = "2010-01-01"
start2 = "2015-01-01"
end1 = "2017-01-01"
end2 = "2021-01-01"

coords={'lat':lat_oda, 'lon':lon_oda, 'time':pd.date_range(start2, end2, freq='A')}
data_vars = {'tos':(['time','lat','lon'],tos_oda_de),}
ds = xr.Dataset(data_vars= data_vars)
ds.to_netcdf(d_path+"tos_ODA_detrend_2015-2021.nc")
print("tos_ODA_detrend_2015-2021.nc")


