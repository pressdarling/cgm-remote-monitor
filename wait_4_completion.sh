#!/bin/bash

# Waiting for background processes to complete

####### Keep this file synchronized with the marked contents of the bootstrap ###
####################### Wait for updates to complete

count=0
apt_present=1
while [ $apt_present -gt 0 ]
do
running_apt=$(ps aux | grep '[a]pt') 
if [ "$running_apt" = "" ]
then
  apt_present=0
else
  echo " $count  Waiting for background processes to complete"
  sleep 10
  count=$((count+10))
fi
done
######################################################################
 
