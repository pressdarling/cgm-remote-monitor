#!/bin/bash

echo
echo "Install packages. - Navid200"
echo

# Reduce the number of snapshots kept from the default 3 to 2 to reduce disk space usage.
sudo snap set system refresh.retain=2

# Let's upgrade packages if available and install the missing needed packages.
/xDrip/scripts/wait_4_completion.sh
sudo apt-get update

#Ubuntu upgrade available
NextUbuntu="$(apt-get -s upgrade | grep 'Inst base' | awk '{print $4}' | sed 's/(//')"
if [ "$NextUbuntu" = "13ubuntu10.2" ] # Only upgrade if we have tested the next release (24.04.2)
then
  sudo apt-get -y upgrade
fi

# packages
whichpack=$(which gpg)
if [ "$whichpack" = "" ]
then
  /xDrip/scripts/wait_4_completion.sh
  sudo apt-get -y install jq net-tools gnupg
  # The last item on the above list of packages must be verified in Status.sh to have been installed.
fi 

# mongo
whichpack="$(mongod --version | sed -n 1p)"
if [ ! "${whichpack%%.*}" = "db version v8" ]
then
  /xDrip/scripts/wait_4_completion.sh
  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list   
  /xDrip/scripts/wait_4_completion.sh
  sudo apt-get update
  sudo apt-get install -y mongodb-org=8.0.0 mongodb-org-database=8.0.0 mongodb-org-server=8.0.0 mongodb-mongosh mongodb-org-mongos=8.0.0 mongodb-org-tools=8.0.0

  echo "mongodb-org hold" | sudo dpkg --set-selections
  echo "mongodb-org-database hold" | sudo dpkg --set-selections
  echo "mongodb-org-server hold" | sudo dpkg --set-selections
  echo "mongodb-mongosh hold" | sudo dpkg --set-selections
  echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
  echo "mongodb-org-tools hold" | sudo dpkg --set-selections

  /xDrip/scripts/wait_4_completion.sh
  systemctl start mongod
  systemctl enable mongod

fi

# node - We install version 16 of node here, which automatically  updates npm to 8.
whichpack=$(node -v)
if [ ! "${whichpack%%.*}" = "v16" ]
then
/xDrip/scripts/wait_4_completion.sh
sudo /xDrip/scripts/nodesource_setup.sh
/xDrip/scripts/wait_4_completion.sh
sudo apt-get install nodejs -y
# Nightscout needs version 6 of npm.  So, we are going to install that version now effectivwely downgrading it.  
sudo npm install -g npm@6.14.18
fi

# Add log
/xDrip/scripts/AddLog.sh "The packages have been installed" /xDrip/Logs

  
