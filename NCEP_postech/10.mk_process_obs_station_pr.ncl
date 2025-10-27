begin
dir1="/media/cmlws/Data2/hjc/NCEP/data/obs/pr/specific/6_9/"
dir2="/media/cmlws/Data2/hjc/NCEP/data/obs/"

site=asciiread(dir2+"info.dat",(/62/),"string")

do i=0,61 ; site
  PR=new((/32,122/),"float")
 do y=1991,2021 ; year
  data=asciiread(dir1+"st"+site(i)+"dat"+y+"_rn.dat",(/122,5/),"float")
  pr=data(:,4) ;6789
  pr@_FillValue =-999.9
  year=y-1991
  PR(year,:)=pr
  delete(pr)
 end do

  data1=asciiread(dir1+"st"+site(i)+"dat2022_rn.dat",(/122,5/),"float")
  pr2=data1(:,4)
  pr2@_FillValue =-999.9
  PR(31,:)=pr2
  PR!0="year"
  PR!1="time"
   
  system("rm -f "+dir1+"st"+site(i)+"_1991-2022.nc")
  out=addfile(    dir1+"st"+site(i)+"_1991-2022.nc","c")
  out->PR=PR
  delete(PR)
end do

end
