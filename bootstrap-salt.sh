#!/bin/bash

cd
test -d .pnbi_salt || mkdir .pnbi_salt
cd .pnbi_salt
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
sudo sh bootstrap-salt.sh
