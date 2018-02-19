#!/bin/bash
#By Spice-IT-up [Spiceworks]
#Purpose - Tar backup multiple directories
#Version 1.1

tsToday=$(date +%F)
tsLast=$(date +%F -d yesterday)
dataFolders="/etc /opt/Data1/data /home/User1"
excludeFolderFiles="/home/User1/tar_exclusion_list.txt"
bksTime=`date +%d-%b-%Y`
backupFileName="backup-$bksTime.tar.gz"
destinationDrive="/backup/vol1/backups/Server1"
targetSpacePercent=$(/bin/df -h $target | /bin/sed -n '3p' | /bin/awk '{ print $4 }' | sed 's/.\{1\}$//')
targetSpaceThresh="80"
email="Sysadmin@blablabla.bla"
logDir="$destinationDrive"
logFile="$logDir/backup-$bksTime.log"

#Check diskspace before backup
function checkTargetSpace () {
   if [ $targetSpacePercent -ge $targetSpaceThresh ]; then
   errSubject="[$(hostname -s)] Backup Alert - Not enough free space ($tsToday)"
   errMessage="Backup files Error:\n\n\tFree Space on $destinationDrive is $targetSpacePercent%, threshold is $targetSpaceThresh%"
      echo -e "$errMessage" | /bin/mail -s "$errSubject" $email
      echo "$(date) Free Space on $destinationDrive is $targetSpacePercent%, threshold is $targetSpaceThresh%" >> $logFile
      exit 1
   fi
}

#Backups
function runBackup() {
/bin/tar -cpvzf $destinationDrive/$backupFileName -X $excludeFolderFiles $dataFolders -C $destinationDrive >> $logFile
}

#Remove 30+ backups
function cleanup() {
find $destinationDrive/backup* -type f -mtime +15 -exec rm {} \;
}

#Lets run the activities
cleanup
checkTargetSpace
runBackup