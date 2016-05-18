#!/bin/bash

wifi_ssid="PhilaSD WiFi"
wifi_pass="PASSWORD HERE"

# Make sure wifi is turned on
networksetup -setairportpower en0 on

# Join the wifi SSID
networksetup -setairportnetwork en0 $wifi_ssid $wifi_password
