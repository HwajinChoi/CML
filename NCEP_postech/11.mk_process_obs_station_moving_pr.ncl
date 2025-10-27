begin
dir1="/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific/6_9/"
dir2="/media/cmlws/Data2/hjc/NCEP/data/obs/"

site=asciiread(dir2+"info.dat",(/62/),"string")

do i=0,61 ; site
  PR=new((/32,122/),"float")
 do y=1991,2021 ; year
  data=asciiread(dir1+"st"+site(i)+"dat"+y+"_rn.dat",(/122,5/),"float")
  data!0="time"
  data!1="name"
  pr=new((/122/),"float")
  pr=data(:,4) ;6789
  pr@_FillValue =-999.9
  pr!0="time"
  year=y-1991
  PR(year,:)=pr
  delete([/pr,data/])
 end do
  data1=asciiread(dir1+"st"+site(i)+"dat2022_rn.dat",(/122,5/),"float")
  data1!0="time"
  data1!1="name"
  pr2=new((/122/),"float")
  pr2=data1(:,4)
  pr2@_FillValue =-999.9
  PR(31,:)=pr2

  PR!0="year"
  PR!1="time"
  ;----- 11 days moving-------------------------------------------------------------
  p=11;chunck period
  tp=122-p+1;total period after moving averaged
  pr_mv_11=new((/32,tp/),"float"); Target
  imsi=new((/32,p/),"float"); Chunck
   do k=0,tp-1
    imsi(:,:)=PR(:,k:k+p-1)
    pr_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
    imsi=imsi@_FillValue
   end do
  pr_mv_11!0="year"
  pr_mv_11!1="time"

  system("rm -f "+dir1+"st"+site(i)+"_11moving_1991-2022_June_Sep.nc")
  out=addfile(    dir1+"st"+site(i)+"_11moving_1991-2022_June_Sep.nc","c")
  out->pr_mv_11=pr_mv_11
  delete([/pr_mv_11,PR/])
end do

end
