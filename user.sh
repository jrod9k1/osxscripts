#!/bin/bash

# This script creates a new user on OS X 10.6 and above
# It is intended to be run via ARD or mass shell

# GroupID 80 is admin and GroupID 20 is standard
# Password is set without quotes. Put two double quotes to negate password
# To skip setup assistant: ~/Library/Preferences/com.apple.SetupAssistant.plist



LastID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
NextID=$((LastID + 1))

. /etc/rc.common
dscl . create /Users/access
dscl . create /Users/access RealName Access
dscl . create /Users/access hint "None"
dscl . create /Users/access picture "/Library/User Pictures/Fun/Chalk.tif"
dscl . passwd /Users/access ""
dscl . create /Users/access UniqueID $NextID
dscl . create /Users/access PrimaryGroupID 20
dscl . create /Users/access UserShell /bin/bash
dscl . create /Users/access NFSHome/Directory /Users/access
cp -R /System/Library/User\ Template/English.lproj /Users/access
chown -R access:staff /Users/access
reboot
