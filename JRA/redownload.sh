#!/bin/bash

for year in {2013..2019} ;do
for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"; do
#for mon in "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"; do
ftp -n -v ds.data.jma.go.jp <<EOF
  user jra05593 dnjfwlsdl20  
  binary                  
  prompt
  hash
  lcd /disk3/hjchoi/JRA55/${year}${mon}/
  cd JRA-55/Hist/Daily/anl_p125/${year}${mon}/
  mget anl_p125_spfh.*
  bye
EOF

done
done
