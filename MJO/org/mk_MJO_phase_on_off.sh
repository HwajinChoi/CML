#!/bin/bash

for s in "ON" "OFF";do

cat > imsi.ncl << EOF
begin

dir1="/media/cmlws/Data2/hjc/MJO/data/Index/"
f=addfile(dir1+"MJO_${s}_Index_PC1_2_20000101-20191231.nc","r")
mjo_index=f->MJO_INDEX
pc1=f->PC1
pc2=f->PC2

dim=dimsizes(pc1)

C=new(dim(0),typeof(pc1))
C=pc1^2+pc2^2
copy_VarCoords(pc1,C)

Phase_mjo=new(dim(0),typeof(pc1))
Phase_mjo@_FillValue=-999

do i=0,dim(0)-1
 if (.not.ismissing(mjo_index(i)).and. mjo_index(i) .gt.1 ) then
    Phase_mjo(i)=1
 else if (.not.ismissing(mjo_index(i)).and. mjo_index(i) .lt.1 ) then
    Phase_mjo(i)=-1
 else
    Phase_mjo(i)=Phase_mjo@_FillValue
 end if
 end if
end do
Phase_mjo@info="yes_mjo=1, no_mjo:-1"
copy_VarCoords(pc1,Phase_mjo)

Phase=new(dim(0),typeof(pc1))
Phase@_FillValue=-999
do i=0,dim(0)-1
 if (.not.ismissing(pc1(i)).and. .not.ismissing(pc2(i)).and. pc1(i) .gt. 0 .and. pc2(i) .gt. 0 .and. pc1(i) .gt. pc2(i) .and. C(i) .gt. 1) then
  Phase(i)=5
 else if (.not.ismissing(pc1(i)).and. .not.ismissing(pc2(i)).and. pc1(i) .gt. 0 .and. pc2(i) .gt. 0 .and. pc1(i) .lt. pc2(i) .and. C(i) .gt. 1) then
  Phase(i)=6
 else if (.not.ismissing(pc1(i)).and. .not.ismissing(pc2(i)).and. pc1(i) .lt. 0 .and. pc2(i) .gt. 0 .and. -pc1(i) .lt. pc2(i) .and. C(i) .gt. 1) then
  Phase(i)=7
 else if (.not.ismissing(pc1(i)).and. .not.ismissing(pc2(i)).and. pc1(i) .lt. 0 .and. pc2(i) .gt. 0 .and. -pc1(i) .gt. pc2(i) .and. C(i) .gt. 1) then
  Phase(i)=8
 else if (.not.ismissing(pc1(i)).and. .not.ismissing(pc2(i)).and. pc1(i) .lt. 0 .and. pc2(i) .lt. 0 .and. pc1(i) .lt. pc2(i) .and. C(i) .gt. 1) then
  Phase(i)=1
 else if (.not.ismissing(pc1(i)).and. .not.ismissing(pc2(i)).and. pc1(i) .lt. 0 .and. pc2(i) .lt. 0 .and. pc1(i) .gt. pc2(i) .and. C(i) .gt. 1) then
  Phase(i)=2
 else if (.not.ismissing(pc1(i)).and. .not.ismissing(pc2(i)).and. pc1(i) .gt. 0 .and. pc2(i) .lt. 0 .and. -pc1(i) .gt. pc2(i) .and. C(i) .gt. 1) then
  Phase(i)=3
 else if (.not.ismissing(pc1(i)).and. .not.ismissing(pc2(i)).and. pc1(i) .gt. 0 .and. pc2(i) .lt. 0 .and. -pc1(i) .lt. pc2(i) .and. C(i) .gt. 1) then
  Phase(i)=4
 else
  Phase(i)=Phase@_FillValue
 end if
 end if
 end if
 end if
 end if
 end if
 end if
 end if
end do
copy_VarCoords(pc1,Phase)

system("rm -f "+dir1+"MJO_${s}_yesno_num_20000101-20191231.nc")
out=addfile(    dir1+"MJO_${s}_yesno_num_20000101-20191231.nc","c")
out->Phase_mjo=Phase_mjo
out->Phase_num=Phase

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done
