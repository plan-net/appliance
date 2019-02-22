#!/bin/bash

# wget https://raw.githubusercontent.com/m-rau/appliance/master/bootstrap-salt.sh -O - | bash

cd $PWD
test -d .pnbi_salt || mkdir .pnbi_salt
cd .pnbi_salt
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
sh bootstrap-salt.sh -X stable

