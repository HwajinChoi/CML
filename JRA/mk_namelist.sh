#!/bin/bash

loc1=/disk3/hjchoi/JRA55/ncl

#for var in "anl_p125_spfh" "anl_p125_vgrd" "anl_p125_ugrd" "anl_surf125"; do
for var in "fcst_phy2m" ; do
for year in {1958..1999} ; do
  for mon in "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ;do
 if [ ${mon} = 01 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..31} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	 echo "${a}" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 02 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..28} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 03 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..31} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 04 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..30} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 05 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..31} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 06 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..30} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 07 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..31} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 08 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..31} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 09 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..30} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 10 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..31} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 11 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..30} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi

 if [ ${mon} = 12 ]   ;then
 loc2=/disk3/hjchoi/JRA55/${year}${mon}
 for day in {1..31} ;do
    for h in "00" "06" "12" "18" ;do
	if [ ${day} -lt 10 ];then
	a=${loc2}/${var}.${year}${mon}0${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}0${day}${h} | wc -l` 
	else
	a=${loc2}/${var}.${year}${mon}${day}${h}
	count=`ls ${loc2}/${var}.${year}${mon}${day}${h} | wc -l` 
	fi
	if [ ${count} = 0 ];then
	  echo "$a" >> ${loc1}/${var}.empty_JRA55.txt
	fi
    done
 done
 fi
   done
  done
done
