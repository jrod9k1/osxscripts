#!/bin/bash

# Script for binding to directory server OS X

#dsconfigldap -sfa ds1.shawmont.philasd.net -n "ds1" -u diradmin -p shawmont6380 -N

# Configure the server with  dsconfigldap
dsconfigldap -a odserver.philasd.net

# Setup search policies
dscl /Search create / SearchPolicy CSPSearchPath
dscl /Search append / CSPSearchPath /LDAPv3/odserver.school.philasd.net
dscl /Search/Contacts create / SearchPolicy CSPSearchPath
dscl /Search/Contacts append / CSPSearchPath /LDAPv3/odserver.school.philasd.net
# Not too sure on the functionality of this line in later OS X versions
kerberosautoconfig -f /LDAPv3/odserver.school.philasd.net

