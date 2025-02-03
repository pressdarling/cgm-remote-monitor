#!/bin/bash

echo
echo "Nightscout variables"
echo

dialog --colors --msgbox "              \Zr Developed by the xDrip team \Zn\n\n\
You will be editing the file containing the variables.  The key combinations for text editor functions will be displayed at the bottom of the screen.\n\
^ represents the control key.  For example, ^X means pressing the control and x keys simultaneously.\n\n\
To save, press Ctrl + O, then press Enter to confirm.\n\n\
After editing and saving the variables file, you will need to reboot the server for the changes to take effect.\n\n\
Press Enter now to proceed to the text editor." 19 66
clear

sudo nano /etc/nsconfig
 
