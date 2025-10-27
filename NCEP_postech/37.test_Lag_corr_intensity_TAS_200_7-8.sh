#!/bin/bash

for h in "200" ;do
dir2=/media/cmlws/Data2/hjc/NCEP/data/hgt_may_sep/${h}/last
dir4=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR
dir5=/media/cmlws/Data2/hjc/NCEP/data/obs/OLR/total_6_9
dir3=/media/cmlws/Data2/hjc/NCEP/data/obs/tas/specific/6_9
dir6=/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific/6_9

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

hfiles=systemfunc("ls ${dir3}/st*_11moving_1991-2022_June_Sep.nc")
h=addfiles(hfiles,"r")
ListSetType(h,"join")
tas_mv_11=h[:]->tas_mv_11
tas_mv_11!0="site"
tas_mv_11 := tas_mv_11(:,:,25:86)
tas_mv_11_k=dim_avg_n_Wrap(tas_mv_11,0) ; year(1991-2022) x time 62 (6-9)

delete([/hfiles,h/])
hfiles=systemfunc("ls ${dir6}/st*_11moving_1991-2022_June_Sep.nc")
h=addfiles(hfiles,"r")
ListSetType(h,"join")
pr_mv_11=h[:]->pr_mv_11
pr_mv_11!0="site"
pr_mv_11 := pr_mv_11(:,:,25:86)
pr_mv_11_k=dim_avg_n_Wrap(pr_mv_11,0) ; year(1991-2022) x time 62 (6-9)
;-------------------------------------------------------------------
;---------------------------------------------------------------------------
A=addfile("${dir2}/hgt_count_mv_11_1991-2022.nc","r")
hgt_mv_11=A->hgt_mv_11(:,31:142); year (32) x time (62) 
hgt_mv_11 := hgt_mv_11(:,25:86)

tas_10=new((/10,62/),"float")
pr_10=new((/10,62/),"float")
hgt_10=new((/10,62/),"float")
do i=0,9
 hgt_10(i,:)=hgt_mv_11(TH(i)-1991,:)
 tas_10(i,:)=tas_mv_11_k(TH(i)-1991,:)
 pr_10(i,:)=pr_mv_11_k(TH(i)-1991,:)
end do
;---------------------------------------------------------------------------
mylag=15
hgt_lead_tas=esccr(hgt_10,tas_10,mylag)
tas_lead_hgt=esccr(tas_10,hgt_10,mylag)
ccr_tas_10=new((/10,2*mylag+1/),float)
ccr_tas_10(:,0:mylag-1)=tas_lead_hgt(:,1:mylag:-1)
ccr_tas_10(:,mylag:)=hgt_lead_tas(:,0:mylag)

hgt_lead_pr=esccr(hgt_10,pr_10,mylag)
pr_lead_hgt=esccr(pr_10,hgt_10,mylag)
ccr_pr_10=new((/10,2*mylag+1/),float)
ccr_pr_10(:,0:mylag-1)=pr_lead_hgt(:,1:mylag:-1)
ccr_pr_10(:,mylag:)=hgt_lead_pr(:,0:mylag)
;---------------------------------------------------------------------------
do j=0,9
 H=max(ccr_tas_10(j,16:30))
 if (ccr_tas_10(j,15) .lt. H) then
;    print("Temperature = "+TH(j))
 end if

; K=max(ccr_pr_10(j,16:30))
; if (ccr_pr_10(j,15) .lt. K) then
;    print("Precipitation = "+TH(j))
; end if
end do
;exit
;---------------------------------------------------------------------------
;                     CASE 1
;---------------------------------------------------------
;      0    1    2    3    4    5    6    7    8    9
TH=(/1995,2006,2010,2012,2013,2016,2018,2019,2020,2022/)
tas_TH=(/1995,2018,2020/)
CCR_tas=new((/3,2*mylag+1/),float)
CCR_tas(0,:)=ccr_tas_10(0,:)
CCR_tas(1,:)=ccr_tas_10(6,:)
CCR_tas(2,:)=ccr_tas_10(8,:)

CCR_tas2=dim_avg_n_Wrap(CCR_tas,0)
tas_max=max(CCR_tas2(16:30))
print(tas_max)
print(CCR_tas2)

end
EOF
   echo '*********************************************'
   ncl imsi.ncl
   rm -rf imsi.ncl
done

