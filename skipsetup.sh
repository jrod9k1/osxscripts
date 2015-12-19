#!/bin/bash

# This script copies the setup file to skip Setup Assistant
# It requires a valid copy of the SetupAssistant plist to work

# User you are targetting

USER="access"

# DO NOT EDIT BELOW THIS LINE

cp com.apple.SetupAssistant.plist /Users/${USER}/Library/Preferences/
