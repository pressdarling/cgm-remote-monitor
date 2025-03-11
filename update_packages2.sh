#!/bin/bash

echo
echo "Install packages after the installation of Nightscout. - Navid200"
echo

# Let's upgrade packages if available and install the missing needed packages.

# packages
whichpack=$(which file)
if [ "$whichpack" = "" ]
then
  /xDrip/scripts/wait_4_completion.sh
  sudo apt-get update
  sudo apt-get -y install screen nano qrencode file vis lsb-release apt-transport-https ca-certificates python3-pip bind9-dnsutils
  sudo apt -y install python3-django python3-django-extensions python3-werkzeug python3-qrcode
fi 

# The last item on the above list of packages must be verified in Status.sh to have been installed.  

# Add log
/xDrip/scripts/AddLog.sh "The secondary packages have been installed" /xDrip/Logs

  
