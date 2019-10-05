
   #!/bin/bash
###############################################################################
#
#       Script: checkDisk.sh
#
###############################################################################
#set -x
logrep=/tmp/pct_file_system_used.log
filein=/tmp/tempfile
machine=`Client1`

MAILSTOP=''
let "x=0"

function is_integer() {
    [ "$1" -eq "$1" ] > /dev/null 2>&1
    return $?
}

cp /dev/null $logrep

df -k -P | awk '{print $5 $6}'| sed -e 's/%//'> $filein

while read recin
do
  case $recin in
    UseMounted)
      PCT_FREE=20
      DISK=NONE
      ;;
    NULL)
      echo "Do Nothing for NULL." >> $logrep
      ;;
    *)
      PCT_FREE=`echo $recin | cut -d"/" -f1`
      PCT_FREE=${PCT_FREE:-10}
      DISK=`echo $recin | cut -d"/" -f2,3`
      DISK=${DISK:-ROOT}
      echo $PCT_FREE $DISK
      ;;
  esac
    if is_integer $PCT_FREE; then
      if [ $PCT_FREE -gt 95 ]
      then
          ((x=x+1))
          echo "$DISK is $PCT_FREE Percent Full." >> $logrep
      fi
    fi

done < $filein
    if [ $x != 0 ]
    then
      mail -s "$machine - File Systems Alert!" $MAILSTOP < $logrep
    fi
