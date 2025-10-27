begin
dir1="/media/cmlws/Data2/hjc/ESM4-PDAF/data/OBS/"

f=addfile(dir1+"CHL_201001-202112.nc","r")
chl=f->chlor_a(60:143,:,:) ; 84 x 360 x 180
lon=f->lon
lat=f->lat

dim=dimsizes(chl)
P=60
p=80

N=dim(0)*0.01*P
n=dim(0)*0.01*p
chl_n=new((/dim(1),dim(2)/),"float")
chl_60=new((/dim(1),dim(2)/),"float")
chl_80=new((/dim(1),dim(2)/),"float")

do j=0,dim(2)-1
 do i=0,dim(1)-1
  chl_n(i,j)=num(.not.ismissing(chl(:,i,j))) 
 end do
end do

chl_60=where(chl_n .ge. N,-999,1) ; 60
chl_80=where(chl_n .ge. n,-999,1) ; 80
copy_VarMeta(chl(0,:,:),chl_60)
copy_VarMeta(chl(0,:,:),chl_80)
chl_60@_FillValue =-999
chl_80@_FillValue =-999

system("rm -f "+dir1+"CHL_masking_60_80_percent_201501-202112.nc")
out=addfile(    dir1+"CHL_masking_60_80_percent_201501-202112.nc","c")
out->chl_60=chl_60
out->chl_80=chl_80
out->lon=lon
out->lat=lat

end
