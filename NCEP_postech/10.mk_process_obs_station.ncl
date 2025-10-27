begin
dir1="/media/cmlws/Data2/hjc/NCEP/data/obs/tas/specific/6_9/"
dir2="/media/cmlws/Data2/hjc/NCEP/data/obs/"

site=asciiread(dir2+"info.dat",(/62/),"string")

do i=0,61 ; site
 do y=1991,2022 ; year
  data=asciiread(dir1+"st"+site(i)+"dat"+y+"_tm.dat",(/122,7/),"float")
  TAS=new((/32,122/),"float")
  tas=data(:,4) ;6789
  year=y-1991
  TAS(year,:)=tas
  delete(tas)
 end do
  TAS!0="year"
  TAS!1="time"
  system("rm -f "+dir1+"st"+site(i)+"_1991-2022.nc")
  out=addfile(    dir1+"st"+site(i)+"_1991-2022.nc","c")
  out->TAS=TAS
  delete(TAS)
end do

end
