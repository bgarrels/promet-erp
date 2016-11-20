#!/bin/bash
basedir=$(pwd)
cd promet/setup/portableapps
lazbuild ../../source/tools/changewikipage.lpi
Version=$(sed 's/\r//g' ../../source/base/version.inc).$(sed 's/\r//g' ../../source/base/revision.inc)
Version=$(echo $Version | sed 's/\n//g');
Arch=`dpkg --print-architecture`
Archfpc=$(fpc -h | grep 'Compiler version' | sed 's/.*for \([^ ]\+\)$/\1/')
if [[ "$(uname)" == 'Linux' ]]; then
   platform='linux'
else
   platform='win32'
fi
Date=`date`
ZipSize=$(ls -s --block-size=1048576 "../output/promet-erp-$(echo $Version).i386-win32-portable.zip" | cut -d' ' -f1)
WinSize=$(ls -s --block-size=1048576 "../output/PrometERP_$(echo $Version)_German.paf.exe" | cut -d' ' -f1)

cat downloads_portable.txt | \
  sed -e "s/VERSION/$Version/g" \
      -e "s/ARCH/$Arch/g" \
      -e "s/ARCHFPC/$Archfpc/g" \
      -e "s/WIN_SIZE/$WinSize Mb/g" \
      -e "s/ZIP_SIZE/$ZipSize Mb/g" \
      -e "s/CREATEDDATE/$Date/g" \
  > act_downloads_portable.txt
../../output/$Archfpc-$platform/changewikipage --mandant=Stora Promet-ERP/dowloadplattforms/portable act_downloads_portable.txt
../../output/$Archfpc-$platform/changewikipage --mandant=Stora Promet-ERP/changes ../source/base/changes.txt
../../output/$Archfpc-$platform/sync_db --mandant=Stora
cat ../promet_erp_portable_clean.xml | \
  sed -e "s/PROGVERSION/$Version/g" \
      -e "s/WIN_SIZEB/$WinSizeB/g" \
      -e "s/WIN_SIZEK/$WinSizeK/g" \
      -e "s/WIN_SIZE/$WinSize/g" \
      -e "s/CREATEDDATE/$Date/g" \
      -e "s/YEAR/20$Year/g" \
      -e "s/MONTH/$Month/g" \
      -e "s/DAY/$Day/g" \
  > promet_erp_portable.xml
scp -P 232 promet_erp_portable.xml autoupload@178.254.12.54:promet_upload_target
cd $basedir
