#!/bin/bash

echo
echo "Bringing up the menu" - Navid200
echo

while :
do

clear
Choice=$(dialog --colors --nocancel --help-button --menu "\
        \Zr Developed by the xDrip team \Zn\n\n
Click OK or press Enter to select the highlighted option.\n\n" 18 50 8\
 "1" "Status (may take up to 2 minutes.)"\
 "2" "Logs"\
 "3" "Google Cloud setup"\
 "4" "Nightscout setup"\
 "5" "xDrip setup"\
 "6" "Data"\
 "7" "Reboot server (Nightscout)"\
 "8" "Exit to shell (terminal)"\
 3>&1 1>&2 2>&3)

 response=$?
 if [ $response = 2 ] # Help
 then
   clear
   dialog --colors --no-shadow --infobox "Press any key to return to the main menu." 3 46

   tput civis
   printf '\e[1;44m%-6s\e[m' 
   printf '\n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '                                                    \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '           Developed by the xDrip team              \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '                                                    \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf ' Click the links below to access the corresponding  \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf ' support pages.                                     \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '                                                    \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '                                                    \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '   \e]8;;https://navid200.github.io/xDrip/docs/Nightscout/GCNS/Tips.html\e\\ Tips \e]8;;\e\\                                           \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '                                                    \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '   \e]8;;https://navid200.github.io/xDrip/docs/Nightscout/GCNS/FAQ.html\e\\ FAQ \e]8;;\e\\                                            \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '                                                    \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '   \e]8;;https://navid200.github.io/xDrip/docs/Nightscout/GCNS/Troubleshooting.html\e\\ Troubleshooting \e]8;;\e\\                                \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '                                                    \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '   \e]8;;https://github.com/NightscoutFoundation/xDrip/discussions\e\\ Contact us \e]8;;\e\\                                     \n'
   printf '\e[1;44m%-6s\e[m' " "
   printf '                                                    \n'
   read -p "" -n1 -s
   tput cnorm
 fi

 clear

case $Choice in

1)
/xDrip/scripts/Status.sh
;;

2)
dialog --colors --title "\Zr Developed by the xDrip team \Zn"   --textbox /xDrip/Logs 26 74 
;;

3)
/xDrip/scripts/menu_GC_Setup.sh
;;

4)
/xDrip/scripts/menu_NS_setup.sh
;;

5)
/xDrip/scripts/menu_xDripSetup.sh
;;

6)
/xDrip/scripts/menu_Data.sh
;;

7)
dialog --colors --yesno "       \Zr Developed by the xDrip team \Zn\n\n\
Are you sure you want to reboot the server?\n
If you do, all unsaved open files will close without saving.\n"  9 50
response=$?
if [ $response = 255 ] || [ $response = 1 ]
then
clear
else
/xDrip/scripts/reboot.sh
fi
;;

8)
cd /tmp
clear
dialog --colors --msgbox "        \Zr Developed by the xDrip team \Zn\n\n\
You will now exit to the shell (terminal).  To return to the menu, enter \"menu\" in the terminal without the quotes." 9 50
clear
exit
;;

esac

done

 
