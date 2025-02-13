#!/bin/bash

echo
echo "Rebooting"
echo

clear
sudo reboot
dialog --colors --no-cancel --ok-label "Please wait" --pause "       \Zr Developed by the xDrip team \Zn\n\n\
Please wait 25 seconds for the system to reboot. An expected error message will then appear. Wait an additional 30 seconds before attempting to reconnect." 14 50 25
exit 

