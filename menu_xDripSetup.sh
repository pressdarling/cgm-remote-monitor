#!/bin/bash

echo
echo "Bringing up the utilities menu" - Navid200
echo

clear
Choice=$(dialog --colors --nocancel --nook --menu "\
        \Zr Developed by the xDrip team \Zn\n\n\
Click OK or press Enter to select the highlighted option.\n" 12 50 2\
 "1" "QR code to make xDrip master"\
 "2" "Return"\
 3>&1 1>&2 2>&3)

 clear

case $Choice in

1)
/xDrip/scripts/qrCodeMaster.sh
;;

2)
;;

esac
  
