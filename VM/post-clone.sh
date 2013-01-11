#!/bin/bash
## post-clone.sh
## Developer: Espartaco Palma (esparta@gmail.com)
## Date: 2013-01-10
## LastMod: 2013-01-10
## License: GPL
## Description: Procedure to reconfigure networks cards of cloned RHEL
##      server due some issues with the Mac Address on boot
## Tested on: RHEL6.3 , Centos 6.3 & Oracle Linux 6.3
## Reference(s):
## http://www.centos.org/docs/5/html/5.2/Virtualization/sect-Virtualization-Tips_and_tricks-Duplicating_an_existing_guest_and_its_configuration_file.html

PATH="/etc/sysconfig/network-script/"
FILE="ifcfg-eth"
# Count the number of network cards
nc=$(/sbin/ip -o link | /usr/bin/wc -l)
let "n=$nc-1"
#for every network card ...
for ((i=0; i<$n; ++i )) ; do
  let "j=$i+$n";
  ## setting the Mac Address of the new card
  H=$(/sbin/ifconfig eth$j) && H=${H#*HWaddr } && H=${H%% *}
  O=$(/bin/grep "HWADDR" $PATH$FILE$i)
  /bin/sed -i "s/$O/HWADDR=\"$H\"/g" $PATH$FILE$i
  ## setting the new UUID
  U=$(/bin/grep "UUID"   $PATH$FILE$i)
  NU=$(/usr/bin/uuidgen)
  /bin/sed -i "s/$U/UUID=\"$NU\"/g"  $PATH$FILE$i
done
## Need to reconstruct the network persistent rules, delete & reboot
## Don't worry, it's safe ;-)
/bin/rm -f /etc/udev/rules.d/70-persistent-net.rules
/usr/bin/reboot
