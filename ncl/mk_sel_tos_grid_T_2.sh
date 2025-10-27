#!/bin/bash

dir1=/media/cmlws/Data2/hjc/NEMO/r4.0.6/OUTPUT/chl_clim_196001-199709/raw
dir2=/media/cmlws/Data2/hjc/NEMO/r4.0.6/OUTPUT/chl_clim_199710-201912/raw

for y in $(seq 1997 1 2010);do

	cdo -s -selname,tos ${dir2}/chl_clim_5d_${y}??01_${y}????_grid_T.nc ${dir2}/imsi.nc
	echo "Selected tos (${y})"
	cdo -s -monmean ${dir2}/imsi.nc ${dir2}/tos_monthly_${y}.nc
	echo "Monthly tos (${y})"
	rm -f ${dir2}/imsi.nc
done

cdo -s -mergetime ${dir2}/tos_monthly_????.nc ${dir2}/tos_196001-199709.nc
rm -f ${dir2}/tos_monthly_${y}.nc
