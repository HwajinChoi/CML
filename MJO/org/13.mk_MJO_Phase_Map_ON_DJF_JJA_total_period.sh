#!/bin/bash

for months in "12_2" "6_8";do
 for SSS in "ON" "OFF";do

 if [ $SSS = "ON" ];then
  s="on"
  else
  s="off"
 fi

cat > imsi.ncl << EOF
begin
dir0="/media/cmlws/Data2/hjc/MJO/data/${s}/"
dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
dir2="/media/cmlws/Data2/hjc/MJO/image/"

f=addfile(dir1+"MJO_${SSS}_yesno_num_20000101-20191231.nc","r")
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

P_1_yr=new((/20,365,dim(1),dim(2)/),typeof(olr))
P_2_yr=new((/20,365,dim(1),dim(2)/),typeof(olr))
P_3_yr=new((/20,365,dim(1),dim(2)/),typeof(olr))
P_4_yr=new((/20,365,dim(1),dim(2)/),typeof(olr))
P_5_yr=new((/20,365,dim(1),dim(2)/),typeof(olr))
P_6_yr=new((/20,365,dim(1),dim(2)/),typeof(olr))
P_7_yr=new((/20,365,dim(1),dim(2)/),typeof(olr))
P_8_yr=new((/20,365,dim(1),dim(2)/),typeof(olr))

do i=0,20-1
 P_1_yr(i,:,:,:)=P_1(365*i:365*i+364,:,:)
 P_2_yr(i,:,:,:)=P_2(365*i:365*i+364,:,:)
 P_3_yr(i,:,:,:)=P_3(365*i:365*i+364,:,:)
 P_4_yr(i,:,:,:)=P_4(365*i:365*i+364,:,:)
 P_5_yr(i,:,:,:)=P_5(365*i:365*i+364,:,:)
 P_6_yr(i,:,:,:)=P_6(365*i:365*i+364,:,:)
 P_7_yr(i,:,:,:)=P_7(365*i:365*i+364,:,:)
 P_8_yr(i,:,:,:)=P_8(365*i:365*i+364,:,:)
end do
P_1_yr!0="year"
P_1_yr!1="day"
P_2_yr!0="year"
P_2_yr!1="day"
P_3_yr!0="year"
P_3_yr!1="day"
P_4_yr!0="year"
P_4_yr!1="day"
P_5_yr!0="year"
P_5_yr!1="day"
P_6_yr!0="year"
P_6_yr!1="day"
P_7_yr!0="year"
P_7_yr!1="day"
P_8_yr!0="year"
P_8_yr!1="day"

;----- Jun-Aug, JJA------------------------------
P_1_6_8=P_1_yr(:,151:242,:,:)
P_2_6_8=P_2_yr(:,151:242,:,:)
P_3_6_8=P_3_yr(:,151:242,:,:)
P_4_6_8=P_4_yr(:,151:242,:,:)
P_5_6_8=P_5_yr(:,151:242,:,:)
P_6_6_8=P_6_yr(:,151:242,:,:)
P_7_6_8=P_7_yr(:,151:242,:,:)
P_8_6_8=P_8_yr(:,151:242,:,:)
;----- Dec-Feb, DJF------------------------------
P_1_12_2=new((/20,90,dim(1),dim(2)/),typeof(olr))
P_2_12_2=new((/20,90,dim(1),dim(2)/),typeof(olr))
P_3_12_2=new((/20,90,dim(1),dim(2)/),typeof(olr))
P_4_12_2=new((/20,90,dim(1),dim(2)/),typeof(olr))
P_5_12_2=new((/20,90,dim(1),dim(2)/),typeof(olr))
P_6_12_2=new((/20,90,dim(1),dim(2)/),typeof(olr))
P_7_12_2=new((/20,90,dim(1),dim(2)/),typeof(olr))
P_8_12_2=new((/20,90,dim(1),dim(2)/),typeof(olr))

P_1_12_2(0,0:30,:,:)=P_1_yr@_FillValue
P_1_12_2(0,31:89,:,:)=P_1_yr(0,0:58,:,:)
P_1_12_2(1:19,0:30,:,:)=P_1_yr(0:20-2,334:364,:,:)
P_1_12_2(1:19,31:89,:,:)=P_1_yr(1:20-1,0:58,:,:)

P_2_12_2(0,0:30,:,:)=P_2_yr@_FillValue
P_2_12_2(0,31:89,:,:)=P_2_yr(0,0:58,:,:)
P_2_12_2(1:19,0:30,:,:)=P_2_yr(0:20-2,334:364,:,:)
P_2_12_2(1:19,31:89,:,:)=P_2_yr(1:20-1,0:58,:,:)

P_3_12_2(0,0:30,:,:)=P_3_yr@_FillValue
P_3_12_2(0,31:89,:,:)=P_3_yr(0,0:58,:,:)
P_3_12_2(1:19,0:30,:,:)=P_3_yr(0:20-2,334:364,:,:)
P_3_12_2(1:19,31:89,:,:)=P_3_yr(1:20-1,0:58,:,:)

P_4_12_2(0,0:30,:,:)=P_4_yr@_FillValue
P_4_12_2(0,31:89,:,:)=P_4_yr(0,0:58,:,:)
P_4_12_2(1:19,0:30,:,:)=P_4_yr(0:20-2,334:364,:,:)
P_4_12_2(1:19,31:89,:,:)=P_4_yr(1:20-1,0:58,:,:)

P_5_12_2(0,0:30,:,:)=P_5_yr@_FillValue
P_5_12_2(0,31:89,:,:)=P_5_yr(0,0:58,:,:)
P_5_12_2(1:19,0:30,:,:)=P_5_yr(0:20-2,334:364,:,:)
P_5_12_2(1:19,31:89,:,:)=P_5_yr(1:20-1,0:58,:,:)

P_6_12_2(0,0:30,:,:)=P_6_yr@_FillValue
P_6_12_2(0,31:89,:,:)=P_6_yr(0,0:58,:,:)
P_6_12_2(1:19,0:30,:,:)=P_6_yr(0:20-2,334:364,:,:)
P_6_12_2(1:19,31:89,:,:)=P_6_yr(1:20-1,0:58,:,:)

P_7_12_2(0,0:30,:,:)=P_7_yr@_FillValue
P_7_12_2(0,31:89,:,:)=P_7_yr(0,0:58,:,:)
P_7_12_2(1:19,0:30,:,:)=P_7_yr(0:20-2,334:364,:,:)
P_7_12_2(1:19,31:89,:,:)=P_7_yr(1:20-1,0:58,:,:)

P_8_12_2(0,0:30,:,:)=P_8_yr@_FillValue
P_8_12_2(0,31:89,:,:)=P_8_yr(0,0:58,:,:)
P_8_12_2(1:19,0:30,:,:)=P_8_yr(0:20-2,334:364,:,:)
P_8_12_2(1:19,31:89,:,:)=P_8_yr(1:20-1,0:58,:,:) ; year x day x lat x lon

P_11_${months}=dim_avg_n_Wrap(P_1_${months},1)
P_22_${months}=dim_avg_n_Wrap(P_2_${months},1)
P_33_${months}=dim_avg_n_Wrap(P_3_${months},1)
P_44_${months}=dim_avg_n_Wrap(P_4_${months},1)
P_55_${months}=dim_avg_n_Wrap(P_5_${months},1)
P_66_${months}=dim_avg_n_Wrap(P_6_${months},1)
P_77_${months}=dim_avg_n_Wrap(P_7_${months},1)
P_88_${months}=dim_avg_n_Wrap(P_8_${months},1)

Pattern=new((/8,20,dim(1),dim(2)/),typeof(olr))
Pattern(0,:,:,:)=P_11_${months}
Pattern(1,:,:,:)=P_22_${months}
Pattern(2,:,:,:)=P_33_${months}
Pattern(3,:,:,:)=P_44_${months}
Pattern(4,:,:,:)=P_55_${months}
Pattern(5,:,:,:)=P_66_${months}
Pattern(6,:,:,:)=P_77_${months}
Pattern(7,:,:,:)=P_88_${months}
Pattern!0="phase"

system("rm -f "+dir1+"OLR_map_${SSS}_${months}_MJO_Phase_8_for_ttest_total_period.nc")
out=addfile(    dir1+"OLR_map_${SSS}_${months}_MJO_Phase_8_for_ttest_total_period.nc","c")
out->olr_pattern=Pattern
out->grid_yt=grid_yt
out->grid_xt=grid_xt

end

EOF

ncl ./imsi.ncl
rm -f ./imsi.ncl
 done
done
