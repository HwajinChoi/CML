#!/bin/csh

foreach n (fcst_phy2m125)
#foreach n (anl_surf125 fcst_phy2m125)

 set dir1 = /media/cmlws/Data1/hjc/JRA/data/grb/${n}
 set dir2 = /media/cmlws/Data1/hjc/JRA/data/nc
 set dir3 = /media/cmlws/Data1/hjc/JRA/code
 set A=`cat ${dir3}/${n}_var.txt`
 set i=1

 while ( $i < = 444 ) 
# fcst_phy2m125 => 444
  ncl_convert2nc $A[$i].grb -i ${dir1} -o ${dir2}
  echo "Successful Convert of $A[$i].nc"
  @ i = $i + 1
 end

end
