#!/bin/bash
if [ "`id -u`" != "0" ]
then
echo "Script needs root - pleass run sudo ./run_server_linux.sh"
echo "Cannot continue.."
exit 5
fi


# This function kills the exiting server if it exists so that it will not interfeer with the port
function kill_existing_server() {
    sudo ps -ef |  grep python3.*3389 | grep -v grep |  awk  '{print $2}' | \
    while read -r pid ; do
        sudo kill -9 "$pid"; 
    done
}

kill_existing_server

export SECRET_KEY=$(uuidgen)
export ENV_DEBUG=False
export ENV_TOKEN=$(uuidgen)
export NS_CONFIG_FILE=/etc/nsconfig
export SCRIPT_DIR=$( dirname -- "$0"; )
export APP_JSON_FILE=$SCRIPT_DIR/app.json

if test -f "/etc/free-dns.sh"; then
. /etc/free-dns.sh
else
export HOSTNAME=$(ls /etc/letsencrypt/live | grep -v README)
fi

export printfVar="https://$HOSTNAME:3389/variables?token=$ENV_TOKEN"

python3 $SCRIPT_DIR/manage.py migrate  >> /tmp/variables_log 2>&1

#make sure to put this after the migrate, as the migrate might fail.
export KILL_AFTER_IDLE_TIME=900

CERT_LOCATION="/etc/letsencrypt/live/"$HOSTNAME

# echo PLEASE CONNECT TO https://$HOSTNAME:3389/variables?token=$ENV_TOKEN

# echo "PLEASE CONNECT TO $printfVar"
# echo "env_token is: $ENV_TOKEN"
# echo "hostname: $HOSTNAME"

clear
   dialog --colors --no-shadow --infobox "Press ENTER to return to the main menu." 3 46

# tput civis

printf '\e[1;44m%-6s\e[m' 
printf '\n'
printf '\e[1;44m%-6s\e[m' " "
printf '                                                                   \n'
printf '\e[1;44m%-6s\e[m' " "
printf '                    Developed by the xDrip team                    \n'
printf '\e[1;44m%-6s\e[m' " "
printf '                                                                   \n'
printf '\e[1;44m%-6s\e[m' " "
printf '                                                                   \n'
printf '\e[1;44m%-6s\e[m' " "
printf '  Click on this \e]8;;%s\e\\link\e]8;;\e\\ to open a web page for editing variables.     \n' "$printfVar"
printf '\e[1;44m%-6s\e[m' " "
printf '                                                                   \n'
printf '\e[1;44m%-6s\e[m' " "
printf '                                                                   \n'
printf '\e[1;44m%-6s\e[m' " "
printf '  The server will run for 15 minutes and then stop if not used.    \n'
printf '\e[1;44m%-6s\e[m' " "
printf '  Press Ctrl + C to stop it earlier.                               \n'
printf '\e[1;44m%-6s\e[m' " "
printf '                                                                   \n'


# read -p "" -n1 -s
# tput cnorm
# echo "The server will run for 15 minutes, and after that will stop (if not used). Press ctrl C to stop it before that."
# echo

#python3 manage.py runserver 0.0.0.0:3389  >> /tmp/variables_log 2>&1
python3 $SCRIPT_DIR/manage.py runserver_plus 0.0.0.0:3389 --cert-file $CERT_LOCATION/cert.pem --key-file $CERT_LOCATION/privkey.pem  >> /tmp/variables_log 2>&1 &

# echo press any key to return to the menu. The server will continue to run for 15 minutes until stoped.
read

 
