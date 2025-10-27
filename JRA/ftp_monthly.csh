#!/bin/csh

set yrmo   = 201901
set HOST   = ds.data.jma.go.jp

set prefix1  = anl_land125
set prefix2  = anl_surf125
set prefix3  = fcst_phy2m125
set prefix4  = fcst_surf125
set prefix5  = ice125
set prefix6  = anl_p125
set prefix7  = fcst_p125

set USER   = jra05350
set PASS   = hvlrY5n1

  (\
   echo "user $USER $PASS";\
   echo "bi";\
   echo "prompt";\
   echo "hash";\
   echo "lcd /data1/mhlee/hongja/monthly";\
   echo "cd /JRA-55/Hist/Monthly/$prefix1";\
   echo "mget $prefix1.$yrmo $prefix1.monthly.???";\
   echo "cd /JRA-55/Hist/Monthly/$prefix2";\
   echo "mget $prefix2.$yrmo $prefix2.monthly.???";\
   echo "cd /JRA-55/Hist/Monthly/$prefix3";\
   echo "mget $prefix3.$yrmo $prefix3.monthly.???";\
   echo "cd /JRA-55/Hist/Monthly/$prefix4";\
   echo "mget $prefix4.$yrmo $prefix4.monthly.???";\
   echo "cd /JRA-55/Hist/Monthly/$prefix5";\
   echo "mget $prefix5.$yrmo $prefix5.monthly.???";\
   echo "cd /JRA-55/Hist/Monthly/$prefix6";\
   echo "mget ${prefix6}_??.$yrmo ${prefix6}_???.$yrmo ${prefix6}_????.$yrmo";\
   echo "mget ${prefix6}_??.monthly.??? ${prefix6}_???.monthly.??? ${prefix6}_????.monthly.???";\
   echo "mget ${prefix6}_??_L22.monthly.??? ${prefix6}_???_L22.monthly.??? ${prefix6}_????_L22.monthly.???";\
   echo "cd /JRA-55/Hist/Monthly/$prefix7";\
   echo "mget ${prefix7}_????.$yrmo ${prefix7}_?????.$yrmo";\
   echo "mget ${prefix7}_????.monthly.??? ${prefix7}_?????.monthly.???";\
   echo "mget ${prefix7}_????_L22.monthly.??? ${prefix7}_?????_L22.monthly.???";\
   echo "bye";\
  ) | ftp -n -v $HOST

  echo 'done...' $yrmo
