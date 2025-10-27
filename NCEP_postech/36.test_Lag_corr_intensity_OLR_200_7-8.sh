#!/bin/bash

for h in "200" ;do
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR
dir5=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9

cat > imsi.ncl << EOF
begin
dir2="/media/cmlws/Data2/hjc/NCEP/image/"
P=0.4
per=flt2string(P)
YEAR=(/"2016","2018","2020"/)
COLOR=(/"red","Blue","Green"/)

NPH=(/1994,1995,2001,2006,2010,2012,2016,2018,2020,2022/)
TH=(/1995,2006,2010,2012,2013,2016,2018,2019,2020,2022/)
NPHs=tostring(NPH)
THs=tostring(TH)

colors_NPH=(/"HotPink","BurlyWood","Coral","darkorchid","deepskyblue","LightSalmon","red","Blue","Green","Gold"/)
colors_TH=(/"BurlyWood","darkorchid","deepskyblue","LightSalmon","DarkSeaGreen","red","Blue","Peru","Green","Gold"/)

h3=addfile("${dir5}/OLR_indo_11moving_1991-2022_June_Sep.nc","r")
olr_indo=h3->orl; year x time
olr_indo=olr_indo*(-1)
olr_indo := olr_indo(:,25:86)

h4=addfile("${dir5}/OLR_china_11moving_1991-2022_June_Sep.nc","r")
olr_china=h4->orl
olr_china=olr_china*(-1)
olr_china := olr_china(:,25:86)

orl_indo_10=new((/10,62/),"float")
orl_china_10=new((/10,62/),"float")

do i=0,9
 orl_indo_10(i,:)=olr_indo(TH(i)-1991,:)
 orl_china_10(i,:)=olr_china(TH(i)-1991,:)
end do
;---------------------------------------------------------------------------
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11=A->hgt_mv_11(:,31:142); year (32) x time (62) 
hgt_mv_11 := hgt_mv_11(:,25:86)

hgt_10=new((/10,62/),"float")
do i=0,9
 hgt_10(i,:)=hgt_mv_11(TH(i)-1991,:)
end do
;---------------------------------------------------------------------------
mylag=15
indo_lead_hgt=esccr(orl_indo_10,hgt_10,mylag)
hgt_lead_indo=esccr(hgt_10,orl_indo_10,mylag)
ccr_indo_10=new((/10,2*mylag+1/),float)
ccr_indo_10(:,0:mylag-1)=hgt_lead_indo(:,1:mylag:-1)
ccr_indo_10(:,mylag:)=indo_lead_hgt(:,0:mylag)

china_lead_hgt=esccr(orl_china_10,hgt_10,mylag)
hgt_lead_china=esccr(hgt_10,orl_china_10,mylag)
ccr_china_10=new((/10,2*mylag+1/),float)
ccr_china_10(:,0:mylag-1)=hgt_lead_china(:,1:mylag:-1)
ccr_china_10(:,mylag:)=china_lead_hgt(:,0:mylag)
;---------------------------------------------------------------------------
do j=0,9
 H=max(ccr_indo_10(j,16:30))
 if (ccr_indo_10(j,15) .lt. H) then
;    print("NW India = "+TH(j))
 end if

 K=max(ccr_china_10(j,16:30))
 if (ccr_china_10(j,15) .lt. K) then
;    print("S. China sea = "+TH(j))
 end if
end do
;exit
;---------------------------------------------------------
;                     CASE 1
;---------------------------------------------------------
;      0    1    2    3    4    5    6    7    8    9
TH=(/1995,2006,2010,2012,2013,2016,2018,2019,2020,2022/)
indo_TH=(/1995,2010,2016,2020,2022/)
CCR_indo=new((/5,2*mylag+1/),float)
CCR_indo(0,:)=ccr_indo_10(0,:)
CCR_indo(1,:)=ccr_indo_10(2,:)
CCR_indo(2,:)=ccr_indo_10(5,:)
CCR_indo(3,:)=ccr_indo_10(8,:)
CCR_indo(4,:)=ccr_indo_10(9,:)
;check_max=dim_max_n_Wrap(CCR_indo,1)
;print(check_max(3))
;print(CCR_indo(3,16:30))
;exit

CCR_indo2=dim_avg_n_Wrap(CCR_indo,0)
indo_max=max(CCR_indo2(16:30))
;check_max=dim_max_n_Wrap(CCR_indo(:,16:30),1)
;print(indo_max)
;print(CCR_indo2)
;---------------------------------------------------------
;                     CASE 2
;---------------------------------------------------------
china_TH=(/2006,2010,2019,2020/)

CCR_china=new((/4,2*mylag+1/),float)
CCR_china(0,:)=ccr_china_10(1,:)
CCR_china(1,:)=ccr_china_10(2,:)
CCR_china(2,:)=ccr_china_10(7,:)
CCR_china(3,:)=ccr_china_10(8,:)

CCR_china2=dim_avg_n_Wrap(CCR_china,0)
china_max=max(CCR_china2(16:30))
;check_max=dim_max_n_Wrap(CCR_china(:,16:30),1)
;print(check_max)
;exit
;print(china_max)
;print(CCR_china2)
;exit
;---------------------------------------------------------------------------
;                     CASE 3
;---------------------------------------------------------
delete([/china_TH,CCR_china,CCR_china2,china_max/])
china_TH=(/2006/)
china_max=max(ccr_china_10(1,:))
;print(china_max)
;print(ccr_china_10(1,:))
;exit
;---------------------------------------------------------
;                     CASE 4
;---------------------------------------------------------
delete([/china_TH,china_max/])
china_TH=(/2019/)
china_max=max(ccr_china_10(7,:))
;print(china_max)
;print(ccr_china_10(7,:))
;exit
;---------------------------------------------------------------------------
;                     CASE 5
;---------------------------------------------------------
delete([/china_TH,china_max/])
china_TH=(/2010,2020/)

CCR_china=new((/2,2*mylag+1/),float)
CCR_china(0,:)=ccr_china_10(2,:)
CCR_china(1,:)=ccr_china_10(8,:)
check_max=dim_max_n_Wrap(CCR_china,1)
print(check_max(1))
print(CCR_china(1,16:30))
exit

CCR_china2=dim_avg_n_Wrap(CCR_china,0)
china_max=max(CCR_china2(16:30))
print(china_max)
print(CCR_china2)
end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done

