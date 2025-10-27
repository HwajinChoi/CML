begin

dir1="/media/cmlws/Data2/hjc/satellite/seawifs_modis/"
dir2="/media/cmlws/Data1/hjc/CDR/data/historical/chl/"

f=addfile(dir1+"chl_r360x180_199801-201412.nc","r")
chl_s=f->chlor_a
chl_sa=dim_avg_n_Wrap(chl_s,0); mg m-3

chl_sa@_FillValue=1e+20
;chl_sa2=where(chl_sa .eq. chl_sa@_FillValue,1e+20,chl_sa)
;copy_VarMeta(chl_sa,chl_sa2)
;delete(chl_sa2@_FillValue)
;chl_sa2@_FillValue=1e+20

gfiles=systemfunc("ls "+dir2+"chl_Omon*.nc")
g=addfiles(gfiles,"r")
ListSetType(g,"join")
chl_m=g[:]->chl ;ncl_join x time x lev x lat x lon 
chl_m :=chl_m(:,:,0,:,:)
chl_m!0="model"

;-------------- Annual mean --------------------
chl_an=dim_avg_n_Wrap(chl_m,1)
n = num(ismissing(chl_sa))
nlat = 180
gwt  = latGauWgt(nlat, "lat", "gaussian weights", "")

Taylor=new((/8,3/),"float")

do i=0,7
Taylor(i,:)=taylor_stats(chl_an(i,:,:),chl_sa,gwt,0)
end do
print(Taylor)




end
