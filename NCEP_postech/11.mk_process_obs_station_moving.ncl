begin
dir1="/media/cmlws/Data2/hjc/NCEP/data/obs/tas/specific/6_9/"
dir2="/media/cmlws/Data2/hjc/NCEP/data/obs/"

site=asciiread(dir2+"info.dat",(/62/),"string")

do i=0,61 ; site
  TAS=new((/32,122/),"float")
 do y=1991,2022 ; year
  data=asciiread(dir1+"st"+site(i)+"dat"+y+"_tm.dat",(/122,7/),"float")
  data!0="time"
  data!1="name"
  tas=new((/122/),"float")
  tas=data(:,4) ;6789
  tas!0="time"
  year=y-1991
  TAS(year,:)=tas
  delete([/tas,data/])
 end do
  TAS!0="year"
  TAS!1="time"
  ;----- 11 days moving-------------------------------------------------------------
  p=11;chunck period
  tp=122-p+1;total period after moving averaged
  tas_mv_11=new((/32,tp/),"float"); Target
  imsi=new((/32,p/),"float"); Chunck
   do k=0,tp-1
    imsi(:,:)=TAS(:,k:k+p-1)
    tas_mv_11(:,k)=dim_avg_n_Wrap(imsi,1)
    imsi=imsi@_FillValue
   end do
  tas_mv_11!0="year"
  tas_mv_11!1="time"

  system("rm -f "+dir1+"st"+site(i)+"_11moving_1991-2022_June_Sep.nc")
  out=addfile(    dir1+"st"+site(i)+"_11moving_1991-2022_June_Sep.nc","c")
  out->tas_mv_11=tas_mv_11
  delete([/tas_mv_11,TAS/])
end do

end
