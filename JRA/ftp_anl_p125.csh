#!/bin/csh

set yrmo   = 201905
set HOST   = ds.data.jma.go.jp

set prefix6  = anl_p125
set prefix61 = ${prefix6}_depr
set prefix62 = ${prefix6}_reld
set prefix63 = ${prefix6}_relv
set prefix64 = ${prefix6}_strm
set prefix65 = ${prefix6}_rh
set prefix66 = ${prefix6}_hgt
set prefix67 = ${prefix6}_ugrd
set prefix68 = ${prefix6}_vgrd
set prefix69 = ${prefix6}_vpot
set prefix60 = ${prefix6}_tmp

set USER   = jra05593
set PASS   = dnjfwlsdl20

  (\
   echo "user $USER $PASS";\
   echo "bi";\
   echo "prompt";\
   echo "hash";\
   echo "lcd /data1/hyku/JRA55/daily";\
   echo "cd /JRA-55/Hist/Daily/$prefix6/$yrmo";\
   echo "mget ${prefix61}*";\
   echo "mget ${prefix62}*";\
   echo "mget ${prefix63}*";\
   echo "mget ${prefix64}*";\
   echo "mget ${prefix65}*";\
   echo "mget ${prefix66}*";\
   echo "mget ${prefix67}*";\
   echo "mget ${prefix68}*";\
   echo "mget ${prefix69}*";\
   echo "mget ${prefix60}*";\
   echo "bye";\
  ) | ftp -n -v $HOST

  echo 'done...' $yrmo

