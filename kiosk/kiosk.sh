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

# Vars
fileConfig="/home/pi/Desktop/configKiosk.json"

preferencesChromiumFile="/home/pi/.config/chromium/Default/Preferences"

# TODO: URL = localhost and start node express server that read image files 
url="$pathProject/../frontend/web/index.html"
log "Set url: $url"

log "Enable SSH Server"
if [ ! $(systemctl -q is-active ssh) ]; then
    sudo systemctl enable ssh
    sudo systemctl start ssh
fi
log "SSH Server UP!"


log "Hide the mouse from the display whenever it has been idle for longer then 0.5 seconds"
unclutter -idle 0.5 -root &

log "Disable scren saver"
xset s noblank
xset s off
xset -dpms

log "Use sed to search throught the Chromium preferences file and clear out any flags that would make the warning bar appear, a behavior you dont really want happening on yout Raspberry Pi Kiosk."
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' $preferencesChromiumFile
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' $preferencesChromiumFile

log "Execute Chromium" 
/usr/bin/chromium-browser --noerrdialogs --disable-infobars --incognito --start-maximized --kiosk --force-device-scale-factor=1 $url &
