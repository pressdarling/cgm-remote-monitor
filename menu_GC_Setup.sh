#!/bin/bash

echo
echo "Bringing up the Google Cloud menu" - Navid200
echo

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
        \Zr Developed by the xDrip team \Zn\n\n
Click OK or press Enter to select the highlighted option.\n" 14 50 7\
 "1" "Install Nightscout phase 1 - 16 minutes"\
 "2" "Install Nightscout phase 2 - 10 minutes"\
 "3" "Update"\
 "4" "Return"\
 3>&1 1>&2 2>&3)

 clear

case $Choice in

1)
sudo /xDrip/scripts/NS_Install.sh
;;

2)
sudo /xDrip/scripts/NS_Install2.sh
;;

3)
dialog --colors --msgbox "       \Zr Developed by the xDrip team \Zn\n\n\
This will update your server and Nightscout to the latest available versions.  Press Enter to proceed or ESC to cancel."  9 50
response=$?
if [ $response = 255 ] || [ $response = 1 ]
then
  clear
else
  clear
  cd /srv
  cd "$(< repo)"  # Go to the local database
  sudo git reset --hard  # delete any local edits.
  sudo git pull  # Update database from remote.
  sudo chmod 755 update_scripts.sh
  sudo cp -f update_scripts.sh /xDrip/scripts/. # Update the "update scripts" script. 
  /xDrip/scripts/update_scripts.sh
  /xDrip/scripts/update_packages.sh
  /xDrip/scripts/update_packages2.sh
  /xDrip/scripts/StartUpSetup.sh
  clear
  dialog --colors --msgbox "        \Zr Developed by the xDrip team \Zn\n\n\
Close this SSH window to complete updates." 7 50
fi
;;

4)
;;

esac

 
