#!/bin/sh

##########################################################################################
# "Administrator script package" to easily manage PirateBox Files & Directories over SSH #
##########################################################################################

#Created 02-02-2013

#######################  USAGE  #############################################################################

### FOR TESTING PURPOSES ONLY! ####
### /tmp is purged on reboot!!!  ###

#Copy this file from your computer to your PirateBox router
#scp PBadmin.sh root@PirateboxIP:/tmp/

#To run the script
#cd /tmp && ./PBadmin.sh

#####################  CONFIGURE  ############################################################################

#Route to PirateBox Shared folder
route=/mnt/usb/PirateBox/Shared

#Define your favourite text editor. Vi, vim or on Matthias' custom image you can use nano.
editor=vi


#####################  FUNCTIONS  ############################################################################

list()
	{	
	clear
	echo "Show files of sub-directories? (y/n)"
	read sd	
	if [ $sd = y ] || [ $sd = Y]; then
	echo ""
	echo "-----------------------------------------"
	echo -e '\033[;31m Currently shared files on the PirateBox:\033[0m';
	echo "-----------------------------------------"
	ls -l -h -R $route
	else
	echo ""
	echo "-----------------------------------------"
	echo -e '\033[;31m Currently shared files on the PirateBox:\033[0m';
	echo "-----------------------------------------"
	ls -l -h $route
	fi
	}

search()
	{
	clear
	echo "Which File or Directory are you looking for?"
	read lf
	if [ $lf != 9 ] ; then
	find / -maxdepth 20 -name $lf
	else
	echo "Returning to the main menu."
	fi
	}

del_file()
	{
	clear
	echo ""
	echo "-----------------------------------------"
	echo -e '\033[;31m Currently shared files on the PirateBox:\033[0m';
	echo "-----------------------------------------"
	ls -l -h -R $route
	echo "Which file do you want to remove?"
	echo "(Remember to include sub-directory in path if necessary)"
	read delfile
	if [ $delfile != 9 ] ; then
	rm $delfile
	else
	echo "No change. Returning to the main menu."
	fi
	}

del_dir()
	{
	clear
	echo ""
	echo "-----------------------------------------"
	echo -e '\033[;31m Currently shared files on the PirateBox:\033[0m';
	echo "-----------------------------------------"
	ls -l -h -R $route | egrep '^d'
	echo "Which folder you want to remove?"
	echo "(Remember to include sub-directory in path if necessary)"	
	read directory
	if [ $directory != 9 ] ; then
	rm -r $route/$directory
	else
	echo "No change. Returning to the main menu."
	fi
	}

makedir()
	{
	clear
	echo "Enter the name of the directory you would like to create:"
	echo "(Remember to include sub-directory in path if necessary)"
	read directory
	if [ $directory != 9 ] ; then
	mkdir $route/$directory
	echo "Directory successfully created!"
	else
	echo "No change. Returning to the main menu."
	fi
	}

edit()
	{
	clear
	echo ""
	echo "-----------------------------------------"
	echo -e '\033[;31m Currently shared files on the PirateBox:\033[0m';
	echo "-----------------------------------------"
	ls -l -h -R $route
	echo "Rename file or move file to Directory"
	echo "(Remember to include sub-directoy in path if necessary)"
	echo "File to be renamed OR moved:"
	read file1
	echo "Rename file to OR move file to directory:"
	read file2
	if [ $file1 != 9 ] || [ $file2 != 9] ; then
	mv -i $route/$file1 $route/$file2
	else
	echo "No change. Returning to the main menu."
	fi
	}

HELP()
	{
	clear
	echo ""
	echo "1. In any menu, if you press '9' you will be returned to the main menu."
	echo ""
	echo "2. Action with multiple files:"
	echo "You can move or delete multiple files at once by using the '*'. Example: if you want to move all jpg files to a directory 'Pictures' then choose option 'MOVE' and for the file to be moved write *.jpg and specify 'Pictures' as directory. Deleting multiple files can be done similarly. BE CAREFUL WITH '*'! You cannot undo accidentally deletes."
	echo ""
	echo "3. '[2] Rename OR Move File'has a dual function, it can either rename a file or move a file to another directory. To rename a file, give the current name of the file as the first input and the new name of the file as the second input. If you want to move a file, then as first input give the name of the file and for the second input enter the name of the directory you want to move it to."
	echo ""
	echo "4. Try to avoid using white spaces in file names for easier handling. File & folder names containing white space can be addressed like: 'File one with white space' write 'File\ one\ with\ white\ space'"
	}

vihelp()
	{
	echo ""
	echo "Vi help: 'i' lets you insert text. Hitting 'Esc' cancels text input. Typing ':x' and hitting enter will exit and save changes, ':q!' will exit without saving changes."
	echo ""
	}

restart()
	{
	clear
	echo "Are you sure you want to reboot the router?(y/n)"
	read ch
	if [ $ch = y ] || [ $ch = Y ]; then
	reboot
	fi
	}

chkspace()
	{
	clear
	df -h
	}

editnetw()
	{
	clear 
	echo "This option allows you to edit the network configuration files. Changes in IP address and DNS can be set here."
	if [ $editor = vi ];then
	vihelp
	echo "Do you wish to continue? (y/n)"
	read ch
	if [ $ch = y ] || [ $ch = Y ]; then
	$editor /etc/config/network
	fi
	else
	echo "Do you wish to continue? (y/n)"
	read ch
	if [ $ch = y ] || [ $ch = Y ]; then
	$editor /etc/config/network
	fi
	fi
	}

editPB()
	{
	clear 
	echo "This option allows you to edit 'piratebox.conf'. Changes in IP address and DNS can be set here."
	if [ $editor = vi ];then
	vihelp	
	echo "Do you wish to continue? (y/n)"
	read ch
	if [ $ch = y ] || [ $ch = Y ]; then
	$editor /opt/piratebox/conf/piratebox.conf
	fi
	else
	echo "Do you wish to continue? (y/n)"
	read ch
	if [ $ch = y ] || [ $ch = Y ]; then
	$editor /opt/piratebox/conf/piratebox.conf
	fi
	fi
	}


chSSID()
	{
	clear 
	echo "This option allows you to change the SSID of the PirateBox network."
	if [ $editor = vi ];then
	vihelp	
	echo "Do you wish to continue? (y/n)"
	read ch
	if [ $ch = y ] || [ $ch = Y ]; then
	$editor /etc/config/wireless
	fi
	else
	echo "Do you wish to continue? (y/n)"
	read ch
	if [ $ch = y ] || [ $ch = Y ]; then
	$editor /etc/config/wireless
	fi
	fi
	}


time()
	{
	clear
	echo "The Router has been running for:" 
	uptime | awk '{print $3,$4}'
	}

stationcnt()
	{
	clear
	echo "Number of connected users:"
	cat /opt/piratebox/www/station_cnt.txt | awk '{print $16}'
	}	

quit()
	{
	clear
	echo "Returning to the OpenWRT terminal..."
	echo "To re-launch run: ./PBadmin.sh"
	}

#####################  SUB-MENU  ##############################################################################

config()		
{
	clear
	echo ""
	echo "Configuration Options. Be careful here!"
	yourch=""
	while [ "$yourch" != "9" ]
	do
		echo ""
		echo "[1] Reboot"
		echo "[2] Check Space on Router and Drive"
		echo "[3] Edit Network settings (IP)"
		echo "[4] Edit 'PirateBox.conf'"
		echo "[5] Change SSID"
		echo "[6] Uptime"
		echo "[7] Number of Connected Users"
		echo "[9] Back to Main Menu"
		read yourch

		case $yourch in

			'1') restart;;
			'2') chkspace;;
			'3') editnetw;;
			'4') editPB;;
			'5') chSSID;;
			'6') time;;
			'7') stationcnt;;
			 *) ;;
		     esac
	done
}

#####################  MAIN MENU  ############################################################################
choice=""
while [ "$choice" != "q" ]
do
	echo ""
	echo "-----------------------------------------"
	echo "* * * * * * * * MAIN MENU * * * * * * * *"
	echo "-----------------------------------------"
	echo "In any option, if you press '9' you are returned to the Main Menu!"	
	echo ""
	echo "[1] List of Files & Directories"
	echo "[2] Find a File or Directory"
	echo "[3] Rename OR Move File"
	echo "[4] Make New Directory"
	echo "[5] Remove File"
	echo "[6] Remove Directory"
	echo "[7] Clear Screen"
	echo "[8] Configure"
	echo "[9] HELP"
	echo "[q] EXIT"
	read choice

	case $choice in

		'1') list;;
		'2') search;;
		'3') edit;;
		'4') makedir;;
		'5') del_file;;
		'6') del_dir;;
		'7') clear;;
		'8') config;;
		'9') HELP;;
		'q') quit;;
		 *) echo "PEBKAC";;
	     esac
done
