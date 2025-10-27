#!/bin/bash

for n in "anl_surf125" "fcst_phy2m125" ;do

  dir1=/media/cmlws/Data1/hjc/JRA/data/grb/${n}
  dir2=/media/cmlws/Data1/hjc/JRA/data/nc
  dir3=/media/cmlws/Data1/hjc/JRA/code
 cd ${dir1}
# ls > ${dir3}/${n}_var.txt
 A=${dir3}/${n}_var.txt 

 while IFS= read -r line;do
  ncl_convert2nc ${line}.grb -i ${dir1} -o ${dir2}
  echo "Successful Convert of ${line}.nc"
  rm -f ${dir1}/${line}.grb
 done < $A

done
