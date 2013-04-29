#!/bin/sh

##########################################################################################
# Script to create image gallery from the PirateBox's images stored in the shared folder #
##########################################################################################

#Created 28-04-2013

#The script creates a "pictures.html" file in /opt/piratebox/www/ and inserts all images from the /Shared
#folder into it as thumbnails.
# To access this feature, you have to create a link from the index.html to point towards piratebox.lan/pictures.html
#<a href="piratebox.lan/pictures.html">View Image Gallery!</a>


#######################  USAGE  #############################################################################

#Copy this file from your computer to your PirateBox router
#scp PBimg_organize.sh root@PirateboxIP:/tmp/

#To run the script
#cd /tmp && ./PBadmin.sh

#####################  CONFIGURE  ############################################################################

#Route to PirateBox Shared folder
Shared=/mnt/usb/PirateBox/Shared

#Route to www folder on PirateBox
Pictures=/opt/piratebox/www/pictures.html

#temporary imagelist file
temp=/opt/piratebox/www/imlist.tmp

#####################  START  ############################################################################
#Creating html file first
echo $'<!DOCTYPE html>' > $Pictures
echo $'<html lang="en">' >> $Pictures
echo $'<head>' >> $Pictures
echo $'	<link rel="shortcut icon" href="favicon.ico">' >> $Pictures
echo $'<title>PirateBox - Image Gallery</title>' >> $Pictures
echo $'</head>' >> $Pictures
echo $'<style>' >> $Pictures
echo $'div.img' >> $Pictures
echo $'	 {' >> $Pictures
echo $'  margin:2px;' >> $Pictures
echo $'  height:auto;' >> $Pictures
echo $'  width:auto;' >> $Pictures
echo $'  float:left;' >> $Pictures
echo $'  text-align:center;' >> $Pictures
echo $'  }' >> $Pictures
echo $'div.img img' >> $Pictures
echo $' {' >> $Pictures
echo $'	display:inline;' >> $Pictures
echo $'	}' >> $Pictures
echo $'</style>' >> $Pictures
echo $'</head>' >> $Pictures
echo $'<body>' >> $Pictures

#Create list of .png, .jpg and .bmp files into a temporary file & count the number of pictures
ls $Shared | grep .png > $temp
ls $Shared | grep .jpg >> $temp
ls $Shared | grep .bmp >> $temp
ls $Shared | grep .gif >> $temp
lines=$(cat $temp | wc -l)

for i in $(seq 1 $lines)
do

	name=$(cat $temp | sed -n $i'p')

	echo $'<div class="img">' >> $Pictures
	echo $'<a target="_blank" href="Shared/'$name'">' >> $Pictures
	echo $'<img src="Shared/'$name'" alt="Shared/'$name'" width="150" height="150"></a></div>' >> $Pictures
	echo "" >> $Pictures
	
done

#Finishing end of html file
echo "</body>" >> $Pictures
echo "</html>" >> $Pictures

rm $temp #Remove temp file
