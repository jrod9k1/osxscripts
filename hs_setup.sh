#!/bin/bash

# Check if we have sudo permissions and if not then obtain them
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Begin the script and prompt the user if they want to runt he script
echo "Welcome to HS Deployment setup."
read -p "Are you sure you want to run this script? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Ok."
    exit 1
fi

# Gather some needed information from the user
echo
echo "Please enter the teacher's first and last names correctly capitalized."
read -p "Teacher Name: " teacher_name
# Use regex to santize teacher name and reprompt if it does not match
while [[ ! $teacher_name =~ ^[A-Za-z]+[\ \t][A-Za-z]+$ ]]; do
    read -p "Teacher Name: " teacher_name
    echo
done

echo
read -p "School Location Code: " loc_code
# Use regex to verify loc code is only 4 digits between 0-9
while [[ ! $loc_code =~ ^[0-9]{4}$ ]]; do
    read -p "School Location Code: " loc_code
    echo
done
echo
echo "[DEBUG] You entered $teacher_name for the name and $loc_code for the location code"
echo

# Give me the teacher's last name
teacher_name_last=$(echo $teacher_name | rev | cut -d' ' -f 1 | rev)
echo "[DEBUG] The teacher's last name is $teacher_name_last"

# Set the hostname to locCode-lastName
echo "[DEBUG] Setting hostname to $loc_code-$teacher_name_last"
scutil --set HostName $loc_code-$teacher_name_last
scutil --set ComputerName $loc_code-$teacher_name_last
scutil --set LocalHostName $loc_code-$teacher_name_last

# Ggrab the first letter of the teacher's first name for use in username
teacher_name_firstletter=${teacher_name:0:1}
teacher_name_user_f=$teacher_name_firstletter$teacher_name_last
teacher_username=$(echo "$teacher_name_user_f" | tr '[:upper:]' '[:lower:]')
echo "[DEBUG] The teacher's username is now $teacher_username"

# Setup some more variables for user creation
teacher_password=""

# Generate the next sequential user ID
LastID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
NextID=$((LastID + 1))

# Create the new user
echo "[DEBUG] Creating the new user with display name $teacher_name and username $teacher_username"
. /etc/rc.common
dscl . create /Users/"$teacher_username"
dscl . create /Users/"$teacher_username" RealName "$teacher_name"
dscl . create /Users/"$teacher_username" hint "None"
dscl . create /Users/"$teacher_username" picture "/Library/User Pictures/Fun/Chalk.tif"
dscl . passwd /Users/"$teacher_username" "$teacher_password"
dscl . create /Users/"$teacher_username" UniqueID "$NextID"
dscl . create /Users/"$teacher_username" PrimaryGroupID 80
dscl . create /Users/"$teacher_username" UserShell /bin/bash
dscl . create /Users/"$teacher_username" NFSHomeDirectory /Users/"$teacher_username"
cp -R /System/Library/User\ Template/English.lproj /Users/"$teacher_username"
chown -R "$NextID":staff /Users/"$teacher_username"

# Setup the user's dock
#sudo -u "$teacher_username" defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
#sudo -u "$teacher_username" defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Chess.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

# Run MS serializer
echo "[DEBUG] Running M$ serializier"
installer -pkg /Users/teacher/Desktop/Support/Microsoft_Office_2016_VL_Serializer.pkg -target /

# Get the followup script chooched
curl jrod.mx/hs/b -o /Users/"$teacher_username"/b
chmod +x /Users/"$teacher_username"/b
curl jrod.mx/hs/j -o /Users/"$teacher_username"/j
chmod +x /Users/"$teacher_username"/j

# Switch to the new created user
echo "[DEBUG] Chooching into newly created user"
/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -switchToUserID $NextID

