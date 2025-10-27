import netCDF4 as nc
import numpy as np
import matplotlib.pyplot as plt
import sys
from mpl_toolkits.basemap import Basemap
from matplotlib.patches import Polygon

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
xh, yh = np.meshgrid(xh, yh)

lon1=160
lon2=200
lat1=-20
lat2=-50

lon11=60
lon22=120
lat11=-30
lat22=-45

lon111=300
lon222=360
lat111=-25
lat222=-50

lon1111=140
lon2222=190
lat1111=10
lat2222=30

fig, axes = plt.subplots(nrows=3, ncols=1, figsize=(12, 12), sharex=True, sharey=True)

def plot_with_hatching(ax, m, sst_data, sig_data):
    x, y = m(xh, yh)
    cs = m.pcolormesh(x, y, sst_data, shading='auto', cmap='coolwarm', vmin=-0.5, vmax=0.5)
    m.drawcoastlines()
    m.drawcountries()
    m.fillcontinents(color='black')
    m.drawparallels(np.arange(-90., 91., 30.), labels=[1,0,0,0])
    m.drawmeridians(np.arange(-180., 181., 60.), labels=[0,0,0,1])
    sig_mask = np.ma.masked_where(sig_data != 2, sig_data)
    m.contourf(x, y, sig_mask, colors='none', hatches=['////'],extend='both', alpha=0)

    return cs

def add_rectangle(ax,m,lon_1,lon_2,lat_1,lat_2):
    rect_coords = [(lon_1, lat_1), (lon_2, lat_1), (lon_2, lat_2), (lon_1, lat_2)]
    rect_coords_proj = [m(coord[0], coord[1]) for coord in rect_coords]
    poly = Polygon(rect_coords_proj, edgecolor='black', fill=False, linewidth=2)
    ax.add_patch(poly)


ax1 = axes[0]
m1 = Basemap(projection='cyl', lon_0=180, resolution='c', ax=ax1)
add_rectangle(ax1,m1,lon1,lon2,lat1,lat2)
add_rectangle(ax1,m1,lon11,lon22,lat11,lat22)
add_rectangle(ax1,m1,lon111,lon222,lat111,lat222)
add_rectangle(ax1,m1,lon1111,lon2222,lat1111,lat2222)
cs1=plot_with_hatching(ax1, m1, annual, annual_sig)
ax1.set_title('Annual')

ax2 = axes[1]
m2 = Basemap(projection='cyl', lon_0=180, resolution='c', ax=ax2)
add_rectangle(ax2,m2,lon1,lon2,lat1,lat2)
add_rectangle(ax2,m2,lon11,lon22,lat11,lat22)
add_rectangle(ax2,m2,lon111,lon222,lat111,lat222)
add_rectangle(ax2,m2,lon1111,lon2222,lat1111,lat2222)
cs2=plot_with_hatching(ax2, m2, JJA, JJA_sig)
ax2.set_title('JJA')

ax3 = axes[2]
m3 = Basemap(projection='cyl', lon_0=180, resolution='c', ax=ax3)
add_rectangle(ax3,m3,lon1,lon2,lat1,lat2)
add_rectangle(ax3,m3,lon11,lon22,lat11,lat22)
add_rectangle(ax3,m3,lon111,lon222,lat111,lat222)
add_rectangle(ax3,m3,lon1111,lon2222,lat1111,lat2222)
cs3=plot_with_hatching(ax3, m3, DJF, DJF_sig)
ax3.set_title('DJF')

#cbar_ax = fig.add_axes([0.75, 0.15, 0.02, 0.7]) 
#cbar = fig.colorbar(m3.pcolormesh(xh, yh, DJF, shading='auto', cmap='coolwarm', vmin=-0.5, vmax=0.5), cax=cbar_ax, ticks=np.arange(-0.5, 0.6, 0.1))
plt.subplots_adjust(hspace=0.4)
#plt.show()
plt.savefig('2_tos_diff_COBALT_DAILY_total_period.png', dpi=300, bbox_inches='tight')

