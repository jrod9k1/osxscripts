# Login to the SDP Admin account (or any account of your choosing)
# Replace PASSWORD_HERE with the user's password
exec osascript <<EOF
tell application "System Events"
keystroke "SDP"
keystroke return
delay 1
keystroke "PASSWORD_HERE"
keystroke return
delay 1
end tell
EOF
