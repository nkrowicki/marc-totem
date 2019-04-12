#!/bin/bash

# Vars

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
# Absolute PROJECT path
PROJECTPATH=$(dirname "$SCRIPTPATH")
# Absolute BACKEND path
BACKENDPATH="$PROJECTPATH/backend"

# Cd folder that contain this script
cd $SCRIPTPATH