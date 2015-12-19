#!/bin/bash

# Script for binding to directory server OS X, just fill in the details

SERVERADDRESS="10.0.0.1"
SERVERNAME="SERVERNAME"
USER="diradmin"
PASS="diradmin_password"

# DO NOT EDIT BELOW THIS LINE

dsconfigldap -sfa $SERVERADDRESS -n $SERVERNAME -u $USER -p $PASS -N
