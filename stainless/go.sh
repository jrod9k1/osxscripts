#!/bin/bash

# Variables

resource_location="jrod.mx"
input_file="test.csv"
teacher_password=""

# Do we have sudo?
if [ $EUID != 0 ]; then
      echo "This script must be run with sudo permissions."
      exit $?
fi

# Gather some data about the machine and compare it with the data file

echo "Welcome to HS Deployment Setup (Stainless)"
#serial=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
serial="SC02RJBC9FVH5"
echo "[DEBUG] Your SN is $serial"
teacher_name="$(cat $input_file | grep $serial | awk -F"," '{print $6}')"
# Remove those damn carriage returns. Knock it off google apps
teacher_name=$(echo $teacher_name|tr -d '\r')
loc_code="$(cat $input_file | grep $serial | awk -F',' '{print $1}')"
echo "[DEBUG] This laptop is assigned to $teacher_name"
echo "[DEBUG] This laptop is destined for LOC: $loc_code"
echo

# Fix the name formatting
teacher_name_lc="$(echo "$teacher_name" | tr '[:upper:]' '[:lower:]')"
echo "[DEBUG] The lowercase teacher name is $teacher_name_lc"
teacher_name_first="$(echo $teacher_name_lc | awk '{print $1}')"
echo "[DEBUG] The teacher's first name is $teacher_name_first"
teacher_name_last="$(echo $teacher_name_lc | rev | cut -d' ' -f 1 | rev)"
echo "[DEBUG] The teacher's last name is $teacher_name_last"
teacher_name_first="$(tr '[:lower:]' '[:upper:]' <<< ${teacher_name_first:0:1})${teacher_name_first:1}"
teacher_name_last="$(tr '[:lower:]' '[:upper:]' <<< ${teacher_name_last:0:1})${teacher_name_last:1}"
echo "[DEBUG] The teacher's first name is now $teacher_name_first"
echo "[DEBUG] The teacher's last name is now $teacher_name_last"
teacher_name_clean="${teacher_name_first} ${teacher_name_last}"
echo "[DEBUG] The teacher's full name is now $teacher_name_clean"
echo ${#teacher_name_clean}
echo

# Format names for use in username and hostname
teacher_name_firstletter=${teacher_name_clean:0:1}
teacher_name_user_f="$teacher_name_firstletter$teacher_name_last"
echo "The teacher stage username is $teacher_name_user_f"
teacher_username=$(echo "$teacher_name_user_f" | tr '[:upper:]' '[:lower:]')
echo "[DEBUG] The teacher's username is now $teacher_username"
echo

# Set the hostname
echo "[DEBUG] Setting hostname to $loc_code-$teacher_name_last"
hostname="$loc_code-$teacher_name_last"
#scutil --set HostName $hostname
#scutil --set ComputerName $hostname
#scutil --set LocalHostName $hostname
echo

# Create the new teacher user
echo "The teacher name is $teacher_name_clean"
echo "The username is $teacher_username"
echo


. /etc/rc.common

LastID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
NextID=$((LastID + 1))

dscl . create /Users/"$teacher_username"
dscl . create /Users/"$teacher_username" RealName "$teacher_name_clean"
echo $teacher_name_clean | pbcopy
dscl . create /Users/"$teacher_username" hint "None"
dscl . create /Users/"$teacher_username" picture "/Library/User Pictures/Fun/Chalk.tif"
dscl . passwd /Users/"$teacher_username" "$teacher_password"
dscl . create /Users/"$teacher_username" UniqueID "$NextID"
dscl . create /Users/"$teacher_username" PrimaryGroupID 80
dscl . create /Users/"$teacher_username" UserShell /bin/bash
dscl . create /Users/"$teacher_username" NFSHomeDirectory /Users/"$teacher_username"
cp -R /System/Library/User\ Template/English.lproj /Users/"$teacher_username"
chown -R "$NextID":staff /Users/"$teacher_username"

# Run the M$ Serializer
echo "[DEBUG] Running M$ serializier"
#installer -pkg /Users/teacher/Desktop/Support/Microsoft_Office_2016_VL_Serializer.pkg -target /
echo

# Install Java
echo "[DEBUG] Installing java"
#curl jrod.mx/hs/JavaForOSX.pkg -o ./JavaForOSX.pkg
#installer -pkg JavaForOSX.pkg -target /
#rm JavaForOSX.pkg
echo

# Remove myself
echo "[DEBUG] Removing myself"
# rm -- "$0"

