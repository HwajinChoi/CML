begin
dir2="/media/cmlws/Data2/hjc/NEMO/r4.0.6/output_pro/"
dir3="/media/cmlws/Data2/hjc/NEMO/r4.0.6/regrid_ORCA/regrid/"
;---------CHL_clim----------------------------------------------------------------------------
g2=addfile(dir3+"thetao_chl_clim_199710_201112.nc","r")
thetao_clim=g2->thetao;time 171 *depth 31*lat*lon
lat=g2->lat
lon=g2->lon
time_counter=g2->time_counter
depth=g2->deptht
;-------------------------------------------------------------------------------------------------
dim=dimsizes(thetao_clim)
diff_clim=new((/dim(0),dim(1)-1,dim(2),dim(3)/),"float")
diff_depth=new(dim(1)-1,"float")

  do i=0,dim(1)-2
   diff_depth(i)=depth(i+1)-depth(i)
   diff_clim(:,i,:,:)=(thetao_clim(:,i,:,:)-thetao_clim(:,i+1,:,:))/diff_depth(i)
  end do
copy_VarMeta(thetao_clim(:,0:dim(1)-2,:,:),diff_clim)
copy_VarMeta(depth(0:dim(1)-2),diff_depth)

system("rm -f "+dir2+"diff_thetao_clim_199710-201112.nc")
out=addfile(    dir2+"diff_thetao_clim_199710-201112.nc","c")
out->lon=lon
out->lat=lat
out->thetao=diff_clim
out->time_counter=time_counter
print("Accomplished diff_thetao_clim_199710-201112.nc")
;---------CHL_const----------------------------------------------------------------------------
h1=addfile(dir3+"thetao_chl_const_199710_201112.nc","r")
thetao_const=h1->thetao
diff_const=new((/dim(0),dim(1)-1,dim(2),dim(3)/),"float")

  do i=0,dim(1)-2
   diff_const(:,i,:,:)=(thetao_const(:,i,:,:)-thetao_const(:,i+1,:,:))/diff_depth(i)
  end do
copy_VarMeta(thetao_const(:,0:dim(1)-2,:,:),diff_const)

system("rm -f "+dir2+"diff_thetao_const_199710-201112.nc")
out=addfile(    dir2+"diff_thetao_const_199710-201112.nc","c")
out->lon=lon
out->lat=lat
out->thetao=diff_const
out->time_counter=time_counter
print("Accomplished diff_thetao_const_199710-201112.nc")
;---------CHL_inter----------------------------------------------------------------------------
h2=addfile(dir3+"thetao_chl_inter_199710_201112.nc","r")
thetao_inter=h2->thetao
diff_inter=new((/dim(0),dim(1)-1,dim(2),dim(3)/),"float")

  do i=0,dim(1)-2
   diff_inter(:,i,:,:)=(thetao_inter(:,i,:,:)-thetao_inter(:,i+1,:,:))/diff_depth(i)
  end do
copy_VarMeta(thetao_inter(:,0:dim(1)-2,:,:),diff_inter)

system("rm -f "+dir2+"diff_thetao_inter_199710-201112.nc")
out=addfile(    dir2+"diff_thetao_inter_199710-201112.nc","c")
out->lon=lon
out->lat=lat
out->thetao=diff_inter
out->time_counter=time_counter
print("Accomplished diff_thetao_inter_199710-201112.nc")

end
