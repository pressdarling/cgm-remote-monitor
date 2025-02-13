#!/bin/bash

while :
do
goback=0 # Reset the loop
File=$(dialog --title "Select the backup file for restore" --fselect ~/ 10 50 3>&1 1>&2 2>&3)
key=$?

if [ $key = 255 ] || [ $key = 1 ]
then
  exit
fi

echo "$File"

if [ "$(file -b "$File")" = "directory" ] # If no file has been selected.
then
  clear
  dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
Select the file in the right pane and press Space to display it in the field at the bottom. Then, click OK or press Enter.\n\
Please try again." 11 50
goback=1 # Don't execute the remaining part of the loop
fi

if [ $goback -eq 0 ]
then
  if [ "$(file -b "$File" | awk '{print $2}')" = "tar" ] # If the backup is a tar file, we know it is a new backup containing both database and variables.
  then
    if [ ! "$(tar -tf $File 'database.gz')" = "database.gz" ] || [ ! "$(tar -tf $File 'nsconfig')" = "nsconfig" ]
    then
      clear
      dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe backup file may be corrupt.  Please report this issue." 10 50
      goback=1 # Don't execute the rest of the loop
    fi
    if [ $goback -eq 0 ]
    then
      rm -f /tmp/nsconfig
      rm -f /tmp/database.gz
      tar -xf $File -C /tmp/.
      cd /tmp
      clear
      Choice=$(dialog --colors --nocancel --nook --menu "\
        \Zr Developed by the xDrip team \Zn\n\n\
Click OK or press Enter to select the highlighted option.\n\n\
Restoring variables will overwrite API_SECRET." 16 50 4\
 "1" "Restore MongoDB only"\
 "2" "Restore variables only"\
 "3" "Restore MongoDB and variables"\
 "4" "Exit"\
 3>&1 1>&2 2>&3)
      
      db=0
      var=0;
case $Choice in
      
1)
db=1
;;
      
2)
var=1
;;
      
3)
db=1
var=1
;;

4)
exit
;;
      
esac
      
      if [ $db -eq 1 ] # If the user chose to restore MongoDB
      then
        mongorestore --gzip --archive=database.gz
        fail=$?
        clear
        if [ $fail = 1 ]
        then
          dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe database import failed.  Please report the issue." 8 50
        else # If the database was successfully imported
          echo -e "Restored MongoDB     $(date)\n" | cat - /xDrip/Logs > /tmp/Logs
          sudo /bin/cp -f /tmp/Logs /xDrip/Logs
          if [ $var -lt 1 ] # If the user chose not to restore the variables
          then
            dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nDatabase has been imported.\nThe variables will not be restored, but you can view them at /tmp/nsconfig." 9 50
          else # If the user chose to also restore the variables
            dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe database has been successfully imported." 8 50
          fi
        fi
      fi
      
      if [ $var -eq 1 ]
      then
        sudo cp -f nsconfig /etc/nsconfig
        echo -e "Restored variables     $(date)\n" | cat - /xDrip/Logs > /tmp/Logs
        sudo /bin/cp -f /tmp/Logs /xDrip/Logs
        clear
        dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe variables have been restored from backup.  You need to restart the server for the updated variables to take effect." 9 50
      fi
      exit
    fi  
  fi
fi

if [ $goback -eq 0 ]
then
  if [ "$(file -b "$File" | awk '{print $1}')" = "gzip" ] # If the backup file is a gzip file, we will know that it is an old backup only containing the database.
  then
    clear
    dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
The backup only contains a database.  Press Enter to import it." 9 50
    key=$?
    if [ $key = 255 ]
    then
      exit
    fi
    mongorestore --gzip --archive=$File
    clear
    fail=$?
    if [ $fail -eq 1 ]
    then
      dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe database import failed. Please report the issue." 11 50
      exit
    else
      dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\nThe database has been successfully imported." 8 50
      echo -e "Restored MongoDB     $(date)\n" | cat - /xDrip/Logs > /tmp/Logs
      sudo /bin/cp -f /tmp/Logs /xDrip/Logs
      exit
    fi
  fi
fi
done

 
