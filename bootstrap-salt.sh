#!/bin/bash

# https://raw.githubusercontent.com/m-rau/appliance/master/bootstrap-salt.sh

cd
test -d .pnbi_salt || mkdir .pnbi_salt
cd .pnbi_salt
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
su -u root sh bootstrap-salt.sh
