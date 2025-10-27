#!/bin/csh
@ sty = 1960 #1959 03~
@ edy = 2010 #2010
@ stm = 1

while ($sty <= $edy)
  @ stm = 1
  while ($stm <= 9)
  #mkdir /disk3/hjchoi/JRA55/${sty}0${stm}/
  echo "${sty}${stm} is started"
  ftp -n -v ds.data.jma.go.jp <<EOF
  user jra05593 dnjfwlsdl20  
  binary                  
  prompt
  hash
  lcd /disk3/hjchoi/JRA55/${sty}0${stm}/
  cd JRA-55/Hist/Daily/anl_p125/${sty}0${stm}/
  mget anl_p125_ugrd.*
  mget anl_p125_vgrd.*
  mget anl_p125_spfh.*
  bye
EOF
  echo "Download ${sty}${stm} "
  @ stm ++
  end

  @ stm = 10
  while ($stm <= 12)
  #mkdir /disk3/hjchoi/JRA55/${sty}${stm}/
  echo "${sty}${stm} is started"
  ftp -n -v ds.data.jma.go.jp <<EOF
  user jra05593 dnjfwlsdl20  
  binary                  
  prompt
  hash
  lcd /disk3/hjchoi/JRA55/${sty}${stm}/
  cd JRA-55/Hist/Daily/anl_p125/${sty}${stm}/
  mget anl_p125_ugrd.*
  mget anl_p125_vgrd.*
  mget anl_p125_spfh.*
  bye
EOF
  echo "Download ${sty}${stm} "
  @ stm ++
  end

@ sty ++
end
