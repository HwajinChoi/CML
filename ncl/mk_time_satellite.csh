#!/bin/csh

set dir1 = /media/cmlws/Data2/hjc/satellite/seawifs_modis
set dir2 = /media/cmlws/Data2/hjc/ncl

set A = `cat $dir1/name.txt`
set B = `cat $dir2/year.txt`
set C = `cat $dir2/month.txt`
set i=1

 while ($i < = 291)

  cdo -s -setreftime,1900-01-01,00:00:00,1day -setdate,$B[$i]-$C[$i]-01 -setcalendar,standard $dir1/$A[$i] $dir1/chl_$B[$i]-$C[$i].nc
  echo "chl_$B[$i]-$C[$i].nc"

  @ i = $i + 1

 end

