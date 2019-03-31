#!/bin/bash

# Vars
# Full path of this file without filename
pathProject=`dirname $(realpath $0)`

# Cd folder that contain project
cd $pathProject


# Load log4bash (only is was not loaded)
if [ "$(type -t log)" != 'function' ]; then
        source log4bash.sh
fi

log "Start Install.sh"

# Vars

fileLog="kiosk.log"

scriptUpdate="update.sh"
TODAY=$(date +%F)
autostartFile="/etc/xdg/lxsession/LXDE-pi/autostart"
configFile="/boot/config.txt"

xscreensaverLine="@xscreensaver -no-splash"
pointrpiLine="@point-rpi"

preferencesChromiumFile="/home/pi/.config/chromium/Default/Preferences"
preferencesChromiumFileBpk="$preferencesChromiumFile"
preferencesChromiumFileBpk+="_bkp_$TODAY"

# Kiosk Script Path
kioskScript="${pathProject}/kiosk.sh"
kioskScriptLine="@bash $kioskScript"

echo "This script install Kiosk to Dr Ahorro"
echo "--------------------------------------"
echo "Creator: Nahuel Krowicki"
echo "Contact: nahuelkrowicki@gmail.com"
echo
echo

echo "Remove packages that we don't need"
apt-get purge wolfram-engine scratch scratch2 nuscratch sonic-pi idle3 -y
apt-get purge smartsim java-common minecraft-pi libreoffice* -y

echo "Clean to remove any unnecessary packages"
apt-get clean -y
apt-get autoremove -y

echo "Update our installation of Raspbian."
apt-get update -y
apt-get upgrade -y

echo "Install xdtotool, unclutter and sed"
echo "xdotool: Allow our bash script to execute key presses withouth anyone being on the device"
echo "unclutter: Enable us to hide the mouse from the display"
apt-get install -y xdotool unclutter sed chromium-browser ttf-mscorefonts-installer x11-xserver-utils pv hdparm htop jq vim node

echo "Set up autostart config"
echo "Set up auto login to our user-> Desktop autologin is the default behavior."
echo "If it is not by default follow the following instructions:"
echo "sudo raspi-config"
echo "Go to 3 Boot Options -> B1 Desktop/CLI -> B4 Desktop autologin"

#################################################################################
# start config "configFile"
#################################################################################

tempFile="./temp.txt"

# Remove Black Border Raspberry Pi (on screen)
# Delete "#" on line "#disable_overscan=1"
sed 's/#disable_overscan=1/disable_overscan=1/g' $configFile > $tempFile
cp -f $tempFile $configFile
rm $tempFile

# Rotate display 90 degrees
echo "" >> $configFile
echo "# Rotate display 90 degrees" >> $configFile
echo "display_rotate=1" >> $configFile
# If you are using the Official Raspberry Pi touch screen you can use “lcd_rotate” rather than “display_rotate”.
# NOTE: You can rotate both the image and touch interface 180º by entering lcd_rotate=2 instead

#################################################################################
# end config "configFile"
#################################################################################

#################################################################################
# start config "autostartFile"
#################################################################################

echo "On file $autostartFile..."
echo "Check if exist $xscreensaverLine or add"
if ! grep -q "$xscreensaverLine" "$autostartFile"
then
    # code if not found
	echo $xscreensaverLine >> $autostartFile
fi
echo "Line: $xscreensaverLine -> OK"

echo
echo "Check if exist $pointrpiLine or add"
if ! grep -q "$pointrpiLine" "$autostartFile" 
then
    # code if not found
	echo $pointrpiLine >> $autostartFile
fi
echo "Line: $pointrpiLine -> OK"

echo
echo "Add line to run kiosk script: $kioskScriptLine"
if ! grep -q "$kioskScriptLine" "$autostartFile" 
then
    # code if not found
    echo $kioskScriptLine >> $autostartFile
fi
echo "Line: $kioskScriptLine -> OK"

#################################################################################
# end config "autostartFile"
#################################################################################

# BackupFile Preferences Chromium
echo "Backup file $preferencesChromiumFile to $preferencesChromiumFileBpk"
cp -f $preferencesChromiumFile $preferencesChromiumFileBpk
echo "Backup Preferences Chromium File -> OK"

# Crontab
echo
echo "Add crontab line for run update each 30 minutes"
echo
crontabLine="*/20 * * * * sudo ${pathProject}/$scriptUpdate"
crontabLineEscapeCharacters="${crontabLine//\*/\\*}"
echo "Escape: $crontabLineEscapeCharacters"
crontab -u pi -l > mycron
if ! grep -q "$crontabLineEscapeCharacters" mycron 
then
    # code if not found
    echo "$crontabLine" >> mycron
    crontab -u pi mycron
fi
rm mycron

# Create $fileLog only if not exist
echo "Create fileLog ($fileLog) only if not exist"
if [ ! -f $fileLog ]; then
    echo
    echo "fileLog not found!"
    echo "Create fileLog ($fileLog)"
    echo
    touch $fileLog
fi

echo "Add execution permissions for bash and javascript files"
chmod +x *.sh
chmod +x *.js


echo "Change owner of files"
chown -R pi:pi .

cd backend && npm install -y

# End install
log "End Install.sh ->  Reboot System"

echo "Reboot System"
sudo shutdown -r now