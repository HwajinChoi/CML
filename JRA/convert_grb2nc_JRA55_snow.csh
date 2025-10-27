#!/bin/csh

foreach n (snow)

 set dir1 = /media/cmlws/Data1/hjc/JRA/data/grb/fcst_phy2m125
 set dir2 = /media/cmlws/Data1/hjc/JRA/data/nc
 set dir3 = /media/cmlws/Data1/hjc/JRA/code
 set A=`cat ${dir3}/${n}.txt`
 set i=1

 while ( $i < = 147 ) 
  cp ${dir1}/$A[$i] ${dir1}/$A[$i].grb
  ncl_convert2nc $A[$i].grb -i ${dir1} -o ${dir2}
  echo "Successful Convert of $A[$i].nc"
  @ i = $i + 1
 end

end
