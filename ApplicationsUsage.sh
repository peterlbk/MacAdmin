#!/bin/sh

# Check if app is installed
APP="/Applications/App Store.app"
if [ -z "$APP" ]; then
    echo "<result>N/A</result>"
else

# Get use count
USECOUNT=$(mdls -name kMDItemUseCount "$APP" | awk '{ print $3 }')

    if [[ "$USECOUNT" == *"null"* ]]; then
        echo "<result>UNUSED</result>"
    else
        echo "<result>${USECOUNT}</result>"
    fi
fi