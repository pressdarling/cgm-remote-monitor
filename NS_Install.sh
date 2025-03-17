#!/bin/bash

echo
echo "JamOrHam Nightscout Installer - Designed for Google Compute Minimal Ubuntu 20 micro instance"
echo

if [ "`id -u`" != "0" ]
then
echo "Script needs root - use sudo bash NS_Install.sh"
echo "Cannot continue.."
exit 5
fi

clear
dialog --colors --msgbox "      \Zr Developed by the xDrip team \Zn\n\n\
The required packages will now be installed.  This process will take approximately 16 minutes to complete.  Please keep this terminal open during the installation.  Press Enter to proceed.\n\n\
If this is not a convenient time, press ESC to cancel." 14 50
if [ $? = 255 ]
then
clear
exit
fi
clear

if [ ! -s /var/SWAP ]
then
echo "Creating swap file"
dd if=/dev/zero of=/var/SWAP bs=1M count=2000
chmod 600 /var/SWAP
mkswap /var/SWAP
fi
swapon 2>/dev/null /var/SWAP

# Please don't add any utility installs here.  Please instead, add them to update_packages.sh.
/xDrip/scripts/update_packages.sh

# Create mongo user and admin.
/xDrip/scripts/wait_4_completion.sh

wait  # Wait for background processes to complete
mongosh Nightscout --eval 'db.createUser({user: "username", pwd: "password", roles:["readWrite"]})'

wait  # Wait for background processes to complete
mongosh admin --eval 'db.createUser({user: "mongoadmin", pwd: "mongoadmin", roles:["userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase"]})'

cd /srv 

echo "Installing Nightscout"
cd "$(< repo)" 
git reset --hard  # delete any local edits.
git pull  # Update database from remote.

/xDrip/scripts/wait_4_completion.sh
apt-get update
npm install
# sudo npm run postinstall
npm run-script post-generate-keys

for loop in 1 2 3 4 5 6 7 8 9
do
read -t 0.1 dummy
done

# Add log
/xDrip/scripts/AddLog.sh "Installation phase 1 completed" /xDrip/Logs

/xDrip/scripts/reboot.sh 

  
