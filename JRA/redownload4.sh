#!/bin/bash

#for year in {1998..2019} ;do
for year in {2000..2001} ;do
for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ; do
ftp -n -v ds.data.jma.go.jp <<EOF
  user jra05593 dnjfwlsdl20  
  binary                  
  prompt
  hash
  lcd /disk3/hjchoi/JRA55/${year}${mon}/
  cd JRA-55/Hist/Daily/fcst_phy2m/${year}${mon}/
  mget fcst_phy2m.*
  bye
EOF

done
done
