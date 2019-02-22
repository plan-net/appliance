#!/bin/bash

# wget https://raw.githubusercontent.com/m-rau/appliance/master/bootstrap-salt.sh -O - | bash

cd
test -d .pnbi_salt || mkdir .pnbi_salt
cd .pnbi_salt
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
su sh bootstrap-salt.sh
