#!/bin/bash

# Bind macOS computer to AD
# Author: Gerard Russell

read -p "AD Username: " aduser

# Set the hostname to the standard mac-serialnumber format
serial=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
hostname="MAC-$serial"
hostname=`echo $hostname | cut -c 1-15` # Truncate hostname to 15 chars because macOS does not realise it's $currentYear
scutil --set HostName $hostname
scutil --set ComputerName $hostname
scutil --set LocalHostName $hostname

echo "Set hostname to $hostname"

# Do the thing
dsconfigad \
    -a $hostname \
    -u $aduser \
    -ou "OU=Mac OS X,OU=Desktops,DC=dc,DC=site,DC=net" \
    -domain dc.site.net \
    -mobile enable \
    -mobileconfirm enable \
    -localhome enable \
    -useuncpath enable \
    -groups "Domain Admins,Enterprise Admins,Desktop Support" \
    -alldomains enable

# :)