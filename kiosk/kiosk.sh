#!/bin/bash

#######################################################################
# Start Vars declaration

# Load pathsUtils (only is was not loaded)
if [ -z "$SCRIPT" ]; then 
      source /home/pi/marc-totem/kiosk/pathUtils.sh
fi

# Server PORT
PORT="8080"

preferencesChromiumFile="/home/pi/.config/chromium/Default/Preferences"

# Command line for load default img to load when errors occurs
show_default_image="eog -f /home/pi/marc-totem/frontend/public/default-image.png"

# url
url="http://localhost:$PORT"

# End Vars declaration
#######################################################################


# Load log4bash (only is was not loaded)
if [ "$(type -t log)" != 'function' ]; then
        source log4bash.sh
fi

#######################################################################
# Start Functions declaration

# Function start_server
start_server(){
        if killall node 2> /dev/null ; then
            log "Execute killall node"
        else
            log "Execute killall node"
        fi

        log "Cd ..backend"
        cd ../backend
        log "Run npm start &"
        npm start &
        sleep 15
}

# Function start_chromium
start_chromium(){
    # Start chromium
        log "Use sed to search throught the Chromium preferences file and clear out any flags that would make the warning bar appear, a behavior you dont really want happening on yout Raspberry Pi Kiosk."
        if sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' $preferencesChromiumFile ; then
        log "Line Chromium preferences exited cleanly -> OK"
        fi
        if sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' $preferencesChromiumFile ; then
        log "Line Chromium preferences exited cleanly -> OK"
        fi

        log "Execute Chromium" 
        /usr/bin/chromium-browser --noerrdialogs --disable-infobars --incognito --start-maximized --kiosk --force-device-scale-factor=1 $url &
}

# Function validateLicense
validate_license(){
    
    # License File Path
    licenseFile="/home/pi/license.txt"

    MAC="$(cat /sys/class/net/eth0/address)"
    MACFILE="$(cat $licenseFile)"

    log "Check License"

    if [ $MAC == $MACFILE ]; then
        log "License ok"
    else
        log "Check license fail"
        exit
    fi
}
# End Functions declaration
#######################################################################

# Call function to Validate License
validate_license

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



##########################################################################
# Start check node server

##########################################################
# Start verify $PORT
# Verify if port $PORT is listen
log "Verify status port $PORT:"

if sudo lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
    log "Port $PORT: LISTEN"
else
    log "Port $PORT: NOT LISTEN"
    start_server

    if ! pidof node >/dev/null ; then
        log "Node process not found"
        start_server

    fi

fi
# End verify $PORT
##########################################################


##########################################################
# Start Verify HTTP CODE response
log "Verify HTTP CODE return of localhost:$PORT.."
HTTP_RESPONSE_CODE=`curl -Is localhost:$PORT | head -1 | awk '{ print $2 }'`

# If HTTP_RESPONSE_CODE is empty assign 1
[ -z "$HTTP_RESPONSE_CODE" ] && HTTP_RESPONSE_CODE=1

log "HTTP RESPONSE CODE IS: $HTTP_RESPONSE_CODE"

if [ $HTTP_RESPONSE_CODE -ne 200 ]; then
        start_server

        if [ $HTTP_RESPONSE_CODE -ne 200 ]; then
            $show_default_image &
        else
            start_chromium
        fi
else
        start_chromium

fi
# End Verify HTTP CODE response
##########################################################

# End check node server
##########################################################################


