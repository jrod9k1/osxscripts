# Turn airport on, replace on with off to turn off obv.
networksetup -setairportpower en1 on

# Clear a users dock, run under relevant user
defaults write com.apple.dock static-only -bool TRUE
killall Dock


# Keep a computer awake as long as you want
caffeinate -dims -t 9999 &

# One liner to connect to wireless SSID
networksetup -setairportnetwork en1 "ssid" "password"

# Logout all interactive sessions on the system
killall loginwindow


# Change a users password
. /etc/rc.common
dscl . -passwd /Users/userhere passhere

# Remove a user
. /etc/rc.common
dscl . delete /Users/user
