#!/bin/bash

>MountPointDetails.txt

a=`date '+%d-%b-%y'`
b=`date '+%r'`

echo "%Utilization : Mount_Point_Name(>60%)" >> MountPointDetails.txt
echo "--------------------------------------" >> MountPointDetails.txt

for i in $(cat server.list)
  do
  echo "@ Server $i:" >> MountPointDetails.txt
  ssh -qn root@$i  df -h| sed 1d  | sed  s/%//g | awk -F ' ' '{ if ($5 > 60) print $5"%" " : " $6 }' >> MountPointDetails.txt
  done

  echo "--- END---" >> MountPointDetails.txt

#Cleanup final output
sed '/^@ Server/N;{/\n@ Server/D;}' MountPointDetails.txt > MountPointDetailsFinal.txt

mailx -vvv -s "HEAL : LogScanServerMountPoint Report above 60% || $a $b" -a /opt/LogScanSpaceCheck/MountPointDetailsFinal.txt -r appsone.l2@hdfcbank.com -S smtp="10.226.7.160" appsone.l2@hdfcbank.com < /opt/LogScanSpaceCheck/MessageContent.txt > /dev/null 2>&1
