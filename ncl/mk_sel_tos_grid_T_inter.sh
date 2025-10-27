#!/bin/bash

dir2=/media/cmlws/Data2/hjc/NEMO/r4.0.6/OUTPUT/chl_inter_199710-201912/raw
dir3=/media/cmlws/Data2/hjc/NEMO/r4.0.6/OUTPUT/chl_inter_199710-201912
dir4=/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA

for y in $(seq 1997 1 2003);do

	cdo -s -selname,tos ${dir2}/chl_inter_5d_${y}??01_${y}????_grid_T.nc ${dir3}/imsi.nc
	echo "Selected tos (${y})"
	cdo -s -monmean ${dir3}/imsi.nc ${dir3}/tos_monthly_${y}.nc
	echo "Monthly tos (${y})"
	rm -f ${dir3}/imsi.nc
done

cdo -s -mergetime ${dir3}/tos_monthly_????.nc ${dir3}/tos_inter_199710-200312.nc
cp ${dir3}/tos_inter_199710-200312.nc ${dir4}/tos_inter_199710-200312.nc
rm -f ${dir3}/tos_monthly_????.nc
