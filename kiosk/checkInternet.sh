#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")


# Full path of this file without filename
# pathProject=`dirname $(realpath $0)`

# Cd folder that contain project
cd $SCRIPTPATH

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