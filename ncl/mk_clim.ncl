begin
dir1="/media/cmlws/Data2/hjc/satellite/seawifs_modis/"
setfileoption("nc","Format","LargeFile")

f=addfile(dir1+"Chl_seawifs_modis_199710-202112.nc","r")
chl=f->chl
g=addfile(dir1+"A20202452020274.L3m_MO_CHL_chlor_a_9km.nc","r")
lon=g->lon
lat=g->lat

dim=dimsizes(chl);time(291)*lat*lon

CHL=new((/25,12,dim(1),dim(2)/),"float")
CHL(0,9,:,:)=chl(0,:,:)
CHL(0,10,:,:)=chl(1,:,:)
CHL(0,11,:,:)=chl(2,:,:)
CHL(0,0:8,:,:)=0

do i=0,23
CHL(i+1,0,:,:)=chl(12*i+3,:,:)
CHL(i+1,1,:,:)=chl(12*i+4,:,:)
CHL(i+1,2,:,:)=chl(12*i+5,:,:)
CHL(i+1,3,:,:)=chl(12*i+6,:,:)
CHL(i+1,4,:,:)=chl(12*i+7,:,:)
CHL(i+1,5,:,:)=chl(12*i+8,:,:)
CHL(i+1,6,:,:)=chl(12*i+9,:,:)
CHL(i+1,7,:,:)=chl(12*i+10,:,:)
CHL(i+1,8,:,:)=chl(12*i+11,:,:)
CHL(i+1,9,:,:)=chl(12*i+12,:,:)
CHL(i+1,10,:,:)=chl(12*i+13,:,:)
CHL(i+1,11,:,:)=chl(12*i+14,:,:)
end do

CHL!0="year"
CHL!1="month"

CHL_sum=dim_sum_n_Wrap(CHL,0)

CHL_12=new((/12,dim(1),dim(2)/),"float")
CHL_12(0,:,:)=CHL_sum(0,:,:)/24
CHL_12(1,:,:)=CHL_sum(1,:,:)/24
CHL_12(2,:,:)=CHL_sum(2,:,:)/24
CHL_12(3,:,:)=CHL_sum(3,:,:)/24
CHL_12(4,:,:)=CHL_sum(4,:,:)/24
CHL_12(5,:,:)=CHL_sum(5,:,:)/24
CHL_12(6,:,:)=CHL_sum(6,:,:)/24
CHL_12(7,:,:)=CHL_sum(7,:,:)/24
CHL_12(8,:,:)=CHL_sum(8,:,:)/24
CHL_12(9,:,:)=CHL_sum(9,:,:)/25
CHL_12(10,:,:)=CHL_sum(10,:,:)/25
CHL_12(11,:,:)=CHL_sum(11,:,:)/25
copy_VarCoords(CHL(0,:,:,:),CHL_12)
CHL_12&lat=lat
CHL_12&lon=lon

system("rm -rf "+dir1+"chl_clim_seawifs_modis_199710-202112.nc")
out=addfile(     dir1+"chl_clim_seawifs_modis_199710-202112.nc","c")
out->chl=CHL_12
out->lon=lon
out->lat=lat

end
