#!/bin/sh

##########################################################################################
# Shell script to create dirextory list from the PirateBox's shared folder		 #
##########################################################################################

#Created 03-06-2013
#Nargren
#UbuntuHak.blogspot.com


#The script creates a "dirlist.html" file in /opt/piratebox/www/ created from the contents of the /Shared
#folder.
# To access this feature, you have to create a link from the index.html to point towards piratebox.lan/dirlist.html
# This can look like the following:
#<a href="piratebox.lan/dirlist.html" title="Download">View Download Folder</a>


#To be added
#Ability to display folders & open them on click

#######################  USAGE  #############################################################################

#Copy this file from your computer to your PirateBox router
#scp PBimgdirlist.sh root@192.168.1.1:/tmp/

#Run the script with
#/tmp/./PBimg_organize.sh

#####################  CONFIGURE ############################################################################

#Route to PirateBox Shared folder

#Shared=/mnt/usb/PirateBox/Shared
Shared=/home/nargren/Pictures

#Route to www folder on PirateBox

#Dirlist=/opt/piratebox/www/dirlist.html
Dirlist=/home/nargren/MyScripts/lighttpd_dirlist/dirlist.html

#Route to the PirateBox's www folder

#www=/opt/piratebox/www/
www=/home/nargren/MyScripts/lighttpd_dirlist/

#List of files

#file=/opt/piratebox/www/file.tmp
#dates=/opt/piratebox/www/date.tmp
#sizes=/opt/piratebox/www/size.tmp

files=/home/nargren/MyScripts/lighttpd_dirlist/files.tmp
paths=/home/nargren/MyScripts/lighttpd_dirlist/paths.tmp
dates=/home/nargren/MyScripts/lighttpd_dirlist/date.tmp
sizes=/home/nargren/MyScripts/lighttpd_dirlist/size.tmp

#Template html dirlist file

template=/home/nargren/MyScripts/lighttpd_dirlist/dirlist_template.html

#Directory depth (tells the script how many directory levels should be searched)
depth=4

#Thumbnail images
video=/home/nargren/MyScripts/lighttpd_dirlist/movie.png
image=/home/nargren/MyScripts/lighttpd_dirlist/image.png
document=/home/nargren/MyScripts/lighttpd_dirlist/document.png
unknown=/home/nargren/MyScripts/lighttpd_dirlist/unknown.png
audio=/home/nargren/MyScripts/lighttpd_dirlist/audio.png
directory=/home/nargren/MyScripts/lighttpd_dirlist/folder.png

#File list from previous run

#prevfile=/opt/piratebox/www/file_old.tmp
prevfiles=/home/nargren/MyScripts/lighttpd_dirlist/files_old.tmp

#####################  START  ############################################################################

#Creating HTML file from template
cp $template $www/dirlist.html
chmod 777 $www/dirlist.html

echo "Template copied into file"	#Such echoes are just for initial runtime check. Not necessary
					#in the final version of the code

#Create list of all file intos a temporary file & count the number of files
find $Shared -maxdepth $depth -printf '%f\n' > $files 				# file name only
find `pwd-P` $Shared -maxdepth $depth > $paths 					# absolute file paths
find $Shared -maxdepth $depth -exec ls -lh {} \; | awk '{print $5}' > $sizes 	# file size only
find $Shared -maxdepth $depth -printf '%CY%Cm%Cd\n' > $dates 			# file date only

echo "file scanned"

lines=$(cat $files | wc -l)		#Counts number of lines and saves to variable

echo "There are $lines file in the folder\nentering loop"

for i in $(seq 1 $lines)		#Carry out the loop as many times as many lines there were counted
do
	name=$(cat $files | sed -n $i'p')	#Read in the name of the file to variable
	path=$(cat $paths | sed -n $i'p')	#Read in the path of the file to variable
	size=$(cat $sizes | sed -n $i'p')	#Read in the size of the file to variable
	date=$(cat $dates | sed -n $i'p')	#Read in the date of the file to variable
	
	filetype=$(cat $files | sed -n $i'p' |awk -F . '{print $NF}') #checking file extension
	
	#This section is repsonsible for checking file extensions and associating thumbnail icons
	
	if [ "$filetype" = "png" ] || [ "$filetype" = "PNG" ] || [ "$filetype" = "jpg" ] || [ "$filetype" = "JPG" ] || [ "$filetype" = "jpeg" ] || [ "$filetype" = "JPEG" ] || [ "$filetype" = "GIF" ] || [ "$filetype" = "gif" ] || [ "$filetype" = "bmp" ] || [ "$filetype" = "BMP" ];
	then
	thumbnail=$image
	
	elif [ "$filetype" = "avi" ] || [ "$filetype" = "AVI" ] || [ "$filetype" = "mp4" ] || [ "$filetype" = "MP4" ] || [ "$filetype" = "mov" ] || [ "$filetype" = "MOV" ] || [ "$filetype" = "mpeg" ] || [ "$filetype" = "MPEG" ] || [ "$filetype" = "flv" ] || [ "$filetype" = "FLV" ] || [ "$filetype" = "wmv" ] || [ "$filetype" = "WMV" ]  || [ "$filetype" = "ogv" ] || [ "$filetype" = "OGV" ];
	then
	thumbnail=$video
	
	elif [ "$filetype" = "doc" ] || [ "$filetype" = "docx" ] || [ "$filetype" = "txt" ] || [ "$filetype" = "pdf" ] || [ "$filetype" = "odt" ];
	then
	thumbnail=$document
	
	elif [ "$filetype" = "mp3" ] || [ "$filetype" = "MP3" ] || [ "$filetype" = "wav" ] || [ "$filetype" = "WAV" ] || [ "$filetype" = "aac" ] || [ "$filetype" = "ogg" ] || [ "$filetype" = "wma" ];
	then
	thumbnail=$audio
	
	elif [ "$filetype" = "$name" ];
	then
	thumbnail=$directory
	
	else
	thumbnail=$unknown
	fi
	
	#This section creates the table in the HTML file
	#Each loop creates a line with 4 columns: thumbnail, name, size, modification date
	
	echo "<tr>" >> $Dirlist

	echo '<td class="img"><img src="'$thumbnail'" class="thumbnail"></td>' >> $Dirlist #good
	#Thumbnail image to indicate whether its a video, picture, music, etc.
	
	echo '<td class="name"><a target="_blank" href="'$path'"> '$name' </a></td>' >> $Dirlist #good
	#Put the name of the file (with link) into next table spot

	echo '<td class="size"> '$size'</td>' >> $Dirlist #good
	#fileize

	echo '<td class="date">'$date'</td>' >> $Dirlist #good
	#Datestamp, only yyyymmdd. Is hh:mm necessary?
	echo "</tr>" >> $Dirlist
	
done

cp $files $prevfiles		#Create a backup of current file' list for comparison on next run

#Finishing end of html elifle
echo "</table>" >> $Dirlist
echo "</div>" >> $Dirlist
echo "</body>" >> $Dirlist
echo "</html>" >> $Dirlist

rm $www/*.tmp			#Remove temp files
echo "FINISHED!"
