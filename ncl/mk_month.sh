#!/bin/bash


for i in $(seq 1998 1 2021);do
 for j in $(seq 1 1 12);do

  echo ${i} >> year.txt

 done
done
