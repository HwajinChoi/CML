#!/bin/csh
#################################################################
# Csh Script to retrieve 3 online Data files of 'ds628.0',
# total 732.9M. This script uses 'wget' to download data.
#
# Highlight this script by Select All, Copy and Paste it into a file;
# make the file executable and run it on command line.
#
# You need pass in your password as a parameter to execute
# this script; or you can set an environment variable RDAPSWD
# if your Operating System supports it.
#
# Contact davestep@ucar.edu (Dave Stepaniak) for further assistance.
#################################################################


set pswd = $1
if(x$pswd == x && `env | grep RDAPSWD` != '') then
 set pswd = $RDAPSWD
endif
if(x$pswd == x) then
 echo
 echo Usage: $0 YourPassword
 echo
 exit 1
endif
set v = `wget -V |grep 'GNU Wget ' | cut -d ' ' -f 3`
set a = `echo $v | cut -d '.' -f 1`
set b = `echo $v | cut -d '.' -f 2`
if(100 * $a + $b > 109) then
 set opt = 'wget --no-check-certificate'
else
 set opt = 'wget'
endif
set opt1 = '-O Authentication.log --save-cookies auth.rda_ucar_edu --post-data'
set opt2 = "email=hjchoi0620@postech.ac.kr&passwd=$pswd&action=login"
$opt $opt1="$opt2" https://rda.ucar.edu/cgi-bin/login
if ( $status == 6 ) then
 echo 'Please check that your password is correct.'
 echo "Usage: $0 YourPassword"
 exit 1
endif
set opt1 = "-N --load-cookies auth.rda_ucar_edu"
set opt2 = "$opt $opt1 https://rda.ucar.edu/data/ds628.0/"
set imsi = `more ./imsi`
set filelist =(\
fcst_phy2m125/2020/fcst_phy2m125.064_srweq.2020020100_2020022921 \
)

while($#filelist > 0)
 set syscmd = "$opt2$filelist[1]"
 echo "$syscmd ..."
 $syscmd
 shift filelist
end

