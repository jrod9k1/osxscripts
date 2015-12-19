#!/bin/sh

# Script to change user password via DSCL

USER="username"
PASS="password"

# DO NOT EDIT BELOW THIS LINE

. /etc/rc.common

dscl . -passwd /Users/${USER} ${PASS}
