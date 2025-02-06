#!/bin/bash

dialog --colors --msgbox "     \Zr Developed the xDrip team \Zn\n\n\
Copy the URL shown on the following page and paste it into a web browser. You will have 15 minutes to edit your variables in the browser." 10 50
clear

sudo /xDrip/ConfigServer/run_server_linux.sh
 
