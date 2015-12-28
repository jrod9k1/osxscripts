#!/bin/bash

# This script creates a new user on OS X 10.6 and above
# It is intended to be run via ARD or mass shell

# GroupID 80 is admin and GroupID 20 is standard
# Password is set without quotes. Put two double quotes to negate password
# To skip setup assistant: ~/Library/Preferences/com.apple.SetupAssistant.plist


USERNAME="test"
DISPLAYNAME="Test"
PASSWORD=""

# You should not modify anything below this line

LastID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
NextID=$((LastID + 1))

. /etc/rc.common
dscl . create /Users/"$USERNAME"
dscl . create /Users/"$USERNAME" RealName "$DISPLAYNAME"
dscl . create /Users/"$USERNAME" hint "None"
dscl . create /Users/"$USERNAME" picture "/Library/User Pictures/Fun/Chalk.tif"
dscl . passwd /Users/"$USERNAME" "$PASSWORD"
dscl . create /Users/"$USERNAME" UniqueID "$NextID"
dscl . create /Users/"$USERNAME" PrimaryGroupID 20
dscl . create /Users/"$USERNAME" UserShell /bin/bash
dscl . create /Users/"$USERNAME" NFSHome/Directory /Users/"$USERNAME"
cp -R /System/Library/User\ Template/English.lproj /Users/"$USERNAME"
chown -R "$USERNAME":staff /Users/"$USERNAME"

