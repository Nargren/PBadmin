PBadmin
=======
#### Under testing! Use with EXTREME CARE! ####


PirateBox Administrator Script Package:

------FUNCTIONS------
Copy, move , rename, remove files from the Shared folder
Search for files & directories on the whole box
List all files & directories currently shared
Change SSID
Reboot
Check uptime
Check number of connected users
Check available space on router
Edit piratebox.conf
Edit network

------USE------
Copy PBadmin.sh over to your OpenWRT router running PirateBox:
scp PBadmin.sh root@PirateBoxIP:/tmp

(NOTE! /tmp is purged on router restart.)

run with
/tmp/./PBadmin.sh
