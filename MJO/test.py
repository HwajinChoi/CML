import netCDF4 as nc
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap


file_path = './Diff_COBALT_DAILY_DJF_JJA.nc'
a_path='./signi_COBALT_DAILY_DJF_JJA.nc'
ds = nc.Dataset(file_path)
ds_a=nc.Dataset(a_path)
annual_sig=ds_a.variables['annual_sig2'][:]
DJF_sig=ds_a.variables['DJF_sig2'][:]
JJA_sig=ds_a.variables['JJA_sig2'][:]

annual = ds.variables['tos_diff_annual'][:]
DJF = ds.variables['tos_diff_DJF'][:]
JJA = ds.variables['tos_diff_JJA'][:]
yh=ds.variables['yh'][:]
xh=ds.variables['xh'][:]

an_sig_grid = np.where(annual_sig == 2)
an_sig_lon = xh[an_sig_grid[1]]
an_sig_lat = yh[an_sig_grid[0]]

DJF_sig_grid = np.where(DJF_sig == 2)
DJF_sig_lon = xh[DJF_sig_grid[1]]
DJF_sig_lat = yh[DJF_sig_grid[0]]

JJA_sig_grid = np.where(JJA_sig == 2)
JJA_sig_lon = xh[JJA_sig_grid[1]]
JJA_sig_lat = yh[JJA_sig_grid[0]]

fig, axes = plt.subplots(nrows=3, ncols=1, figsize=(12, 12),sharex=True, sharey=True)
ax1 = axes[0]
m = Basemap(projection='cyl',lon_0=180, resolution='c',ax=ax1)
xh, yh = np.meshgrid(xh, yh)
x, y = m(xh, yh)
c_scheme = m.pcolormesh(x, y, annual, shading='auto', cmap='coolwarm', vmin=-0.5, vmax=0.5)
m.fillcontinents(color='black')
m.drawcoastlines()
m.drawcountries()
m.drawparallels(np.arange(-90., 91., 30.), labels=[1,0,0,0])
m.drawmeridians(np.arange(-180., 181., 60.), labels=[0,0,0,1])
m.scatter(*m(an_sig_lon, an_sig_lat), color='yellow', s=2)


ax2 = axes[1]
m2 = Basemap(projection='cyl', lon_0=180, resolution='c', ax=ax2)
c_scheme2 = m2.pcolormesh(x, y, JJA, shading='auto', cmap='coolwarm',vmin=-0.5, vmax=0.5)
m2.drawcoastlines()
m2.drawcountries()
m2.fillcontinents(color='black')
m2.drawparallels(np.arange(-90., 91., 30.), labels=[1,0,0,0])
m2.drawmeridians(np.arange(-180., 181., 60.), labels=[0,0,0,1])
m2.scatter(*m2(JJA_sig_lon, JJA_sig_lat), color='yellow', s=2)

ax3 = axes[2]
m3 = Basemap(projection='cyl', lon_0=180, resolution='c', ax=ax3)
c_scheme3 = m3.pcolormesh(x, y, DJF, shading='auto', cmap='coolwarm',vmin=-0.5, vmax=0.5)
m3.drawcoastlines()
m3.drawcountries()
m3.fillcontinents(color='black')
m3.drawparallels(np.arange(-90., 91., 30.), labels=[1,0,0,0])
m3.drawmeridians(np.arange(-180., 181., 60.), labels=[0,0,0,1])
m3.scatter(*m3(DJF_sig_lon, DJF_sig_lat), color='yellow', s=2)

cbar_ax = fig.add_axes([0.70, 0.15, 0.02, 0.7])
fig.colorbar(c_scheme3, cax=cbar_ax,ticks=np.arange(-0.5, 0.6, 0.1))
plt.subplots_adjust(hspace=0.4)

ax1.set_title('Annual')
ax2.set_title('JJA')
ax3.set_title('DJF')
plt.show()
