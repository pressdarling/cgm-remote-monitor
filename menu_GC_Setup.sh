#!/bin/bash

echo
echo "Bringing up the Google Cloud menu" - Navid200
echo

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
        \Zr Developed by the xDrip team \Zn\n\n
Use the arrow keys to move the cursor.\n\
Press Enter to execute the highlighted option.\n" 17 50 7\
 "1" "Install Nightscout phase 1 - 15 minutes"\
 "2" "Install Nightscout phase 2 - 5 minutes"\
 "3" "Update platform"\
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
cd /srv
cd "$(< repo)"  # Go to the local database
sudo git reset --hard  # delete any local edits.
sudo git pull  # Update database from remote.
sudo chmod 755 update_scripts.sh
sudo cp -f update_scripts.sh /xDrip/scripts/. # Update the "update scripts" script. 
clear
/xDrip/scripts/update_scripts.sh
/xDrip/scripts/update_packages.sh
/xDrip/scripts/StartUpSetup.sh
clear
dialog --colors --msgbox "        \Zr Developed by the xDrip team \Zn\n\n\
Close this terminal to complete updates." 7 50
;;

4)
;;

esac
 
