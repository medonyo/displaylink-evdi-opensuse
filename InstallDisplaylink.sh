#!/bin/bash

WORKDIR="build"

# code copied from https://github.com/AdnanHodzic/displaylink-debian/blob/master/displaylink-debian.sh
########################################################################################dw
# define the version to get as the latest available version
version=`wget -q -O - https://www.displaylink.com/downloads/ubuntu | grep "download-version" | head -n 1 | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/'`
# define download url to be the correct version
dlurl="https://www.displaylink.com/"`wget -q -O - https://www.displaylink.com/downloads/ubuntu | grep 'class="download-link"' | head -n 1 | perl -pe '($_)=/<a href="\/([^"]+)"[^>]+class="download-link"/'`
driver_dir=$version

download() {
local dlfileid=$(echo $dlurl | perl -pe '($_)=/.+\?id=(\d+)/')
default=y
echo -en "\nPlease read the Software License Agreement available at: \n$dlurl\nDo you accept?: [Y/n]: "
read ACCEPT
ACCEPT=${ACCEPT:-$default}
case $ACCEPT in
		y*|Y*)
				echo -e "\nDownloading DisplayLink Ubuntu driver:\n"
				wget -O DisplayLink_Ubuntu_${version}.zip "--post-data=fileId=$dlfileid&accept_submit=Accept" $dlurl
				# make sure file is downloaded before continuing
				if [ $? -ne 0 ]
				then
					echo -e "\nUnable to download Displaylink driver\n"
					exit
				fi
				;;
		*)
				echo "Can't download the driver without accepting the license agreement!"
				exit 1
				;;
esac
}
#########################################################################################up

# Unpack the driver
cd ${WORKDIR}
download

unzip DisplayLink_Ubuntu_${version}.zip
installer=`find *.run -type f -print0` 
chmod 755 $installer
./$installer --noexec --keep
installer_dir=`echo $installer | rev | cut -f2- -d '.'| rev`
cd $installer_dir

# Patch the installer, so it can installer everything on openSUSE Tumbleweed
patch -p0 < ../../displaylink-installer.sh.opensuse.patch
