begin
dir0="/media/cmlws/Data2/hjc/MJO/data/on/"
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_ON_yesno_num_20000101-20191231.nc","r")
g=addfile(dir0+"olr_ano_20000101-20191231.nc","r")

Phase_num=f->Phase_num
olr=g->olrAnom
grid_yt=g->grid_yt
grid_xt=g->grid_xt

dim=dimsizes(olr)

NUM=new((/dim(0),dim(1),dim(2)/),typeof(olr))
do i=0,dim(0)-1
NUM(i,:,:)=Phase_num(i)
end do
copy_VarMeta(olr,NUM)

P_1=new((/dim(0),dim(1),dim(2)/),typeof(olr))
P_2=new((/dim(0),dim(1),dim(2)/),typeof(olr))
P_3=new((/dim(0),dim(1),dim(2)/),typeof(olr))
P_4=new((/dim(0),dim(1),dim(2)/),typeof(olr))
P_5=new((/dim(0),dim(1),dim(2)/),typeof(olr))
P_6=new((/dim(0),dim(1),dim(2)/),typeof(olr))
P_7=new((/dim(0),dim(1),dim(2)/),typeof(olr))
P_8=new((/dim(0),dim(1),dim(2)/),typeof(olr))

P_1=where(NUM.eq. 1,olr,olr@_FillValue)
P_2=where(NUM.eq. 2,olr,olr@_FillValue)
P_3=where(NUM.eq. 3,olr,olr@_FillValue)
P_4=where(NUM.eq. 4,olr,olr@_FillValue)
P_5=where(NUM.eq. 5,olr,olr@_FillValue)
P_6=where(NUM.eq. 6,olr,olr@_FillValue)
P_7=where(NUM.eq. 7,olr,olr@_FillValue)
P_8=where(NUM.eq. 8,olr,olr@_FillValue)

copy_VarMeta(olr,P_1)
copy_VarMeta(olr,P_2)
copy_VarMeta(olr,P_3)
copy_VarMeta(olr,P_4)
copy_VarMeta(olr,P_5)
copy_VarMeta(olr,P_6)
copy_VarMeta(olr,P_7)
copy_VarMeta(olr,P_8)

Pattern=new((/8,dim(1),dim(2)/),typeof(olr))
Pattern(0,:,:)=dim_avg_n_Wrap(P_1,0)
Pattern(1,:,:)=dim_avg_n_Wrap(P_2,0)
Pattern(2,:,:)=dim_avg_n_Wrap(P_3,0)
Pattern(3,:,:)=dim_avg_n_Wrap(P_4,0)
Pattern(4,:,:)=dim_avg_n_Wrap(P_5,0)
Pattern(5,:,:)=dim_avg_n_Wrap(P_6,0)
Pattern(6,:,:)=dim_avg_n_Wrap(P_7,0)
Pattern(7,:,:)=dim_avg_n_Wrap(P_8,0)
Pattern!0="phase"

system("rm -f "+dir1+"OLR_map_MJO_Phase_8_20000101-20191231.nc")
out=addfile(dir1+"OLR_map_MJO_Phase_8_20000101-20191231.nc","c")
out->olr_pattern=Pattern
out->grid_yt=grid_yt
out->grid_xt=grid_xt

end
