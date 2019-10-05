#!/bin/bash
#backup.sh
timestamp=`date "+%Y-%m-%d-%H-%M"`
backupFS="/etc /boot"
backupTO=/var/backup
KeepTime=7
if [ -d $backupTO ]; then
find $backupTO -maxdepth 1 -name \*.tar.gz -mtime +${KeepTime} -exec rm -f {} \;
for i in $backupFS
do
j=`expr ${i//\//-}`
tar -zcvf $backupTO/`hostname`.${timestamp}.${j}.tar.gz $i
echo "$i is done"
done
else
echo "backup directory is missing...exiting"
exit 1
fi | mail -s 'backup Daily Check' michaeln@viber.com
