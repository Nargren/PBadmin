PBadmin
=======
# Under testing! Use with EXTREME CARE! #


###PirateBox Administrator Script Package:###

#####------FUNCTIONS------<br>
Copy, move , rename, remove files from the Shared folder<br>
Search for files & directories on the whole box<br>
List all files & directories currently shared<br>
Change SSID<br>
Reboot<br>
Check uptime<br>
Check number of connected users<br>
Check available space on router<br>
Edit piratebox.conf<br>
Edit network<br>
<br>
#####------USE------<br>
Copy PBadmin.sh over to your OpenWRT router running PirateBox:<br>
scp PBadmin.sh root@PirateBoxIP:/tmp<br>
<br>
(NOTE! /tmp is purged on router restart.)<br>
<br>
run with<br>
/tmp/./PBadmin.sh<br>

###Image gallery creator###
Shell script that takes all .bmp, .png,.jpg and .gif files from the /Shared folder and creates a simple 
image gallery from them.

Currently under testing/development.
To run the script do the following:
scp PBimg_organize.sh root@192.168.1.1:/tmp/
ssh root@192.168.1.1
/tmp/./PBimg_organize.sh

(If you can, you can copy the script somehwere alse on the router as well, /etc for example)

The script runs and creates the website picutres.html that can be accessed later on.
The image gallery is accessible through "pictures.html".
Example: piratebox.lan/pictures.html

The script has to be run first. Do:
