#!/bin/bash

# Full path of this file without filename
pathProject=`dirname $(realpath $0)`

# Cd folder that contain project
cd $pathProject

# Load log4bash (only is was not loaded)
if [ "$(type -t log)" != 'function' ]; then
        source log4bash.sh
fi

function checkInternet {
# Check internet and reset wifi interface if is there is not
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -ne 0 ]]; then
        ip link set dev wlan0 down
        ip link set dev wlan0 up
        log "No connection: Offline"
        exit 1
fi
return 0;
}