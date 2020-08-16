#!/usr/bin/bash

## MountPoint scripts
a=`date '+%d-%b-%y'`
b=`date '+%r'`
BASE_DIR="/opt/LogScanSpaceCheck/"

>$BASE_DIR/MountPointDetails.txt

echo "%Utilization : Mount_Point_Name(>60%)" >> $BASE_DIR/MountPointDetails.txt
echo "--------------------------------------" >> $BASE_DIR/MountPointDetails.txt

for i in $(cat /opt/LogScanSpaceCheck/server.list)
  do
  echo "@ Server $i:" >> $BASE_DIR/MountPointDetails.txt
  ssh -qn root@$i  df -h| sed 1d  | sed  s/%//g | awk -F ' ' '{ if ($5 > 60) print $5"%" " : " $6 }' >> $BASE_DIR/MountPointDetails.txt
  done

  echo "----END----" >> $BASE_DIR/MountPointDetails.txt

#Cleanup final output
sed '/^@ Server/N;{/\n@ Server/D;}' $BASE_DIR/MountPointDetails.txt > $BASE_DIR/temp.txt
sed '/^@ Server/N;{/\n----END----/D;}' $BASE_DIR/temp.txt > $BASE_DIR/MountPointDetailsFinal.txt

echo  "$(cat /opt/LogScanSpaceCheck/Header.txt)" "$(cat /opt/LogScanSpaceCheck/MountPointDetailsFinal.txt)" "$(cat /opt/LogScanSpaceCheck/Footer.txt)" | mailx -vvv -s "HEAL : LogScanServerMountPoint Report above 60% || $a $b" -a $BASE_DIR/MountPointDetailsFinal.txt -r appsone.l2@hdfcbank.com -S smtp="10.226.7.160" appsone.l2@hdfcbank.com > /dev/null 2>&1
