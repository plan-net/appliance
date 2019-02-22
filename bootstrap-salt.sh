#!/bin/bash

# wget https://raw.githubusercontent.com/m-rau/appliance/master/bootstrap-salt.sh -O - | bash

if (( $EUID != 0 )); then
    echo "restarting as root ..."
    su -c "$0"
    exit
fi

USERHOME="/home/$USERNAME"
test -d "$USERHOME/.pnbi_salt" || mkdir "$USERHOME/.pnbi_salt"
cd "$USERHOME/.pnbi_salt"

if [ ! -f bootstrap-salt.sh ]; then
  wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
  sh bootstrap-salt.sh -X stable
fi

git --version || apt-get install git --yes

if [ ! -d appliance ]; then
  git clone https://github.com/m-rau/appliance.git
else
  cd appliance
  git pull
  cd ..
fi

salt-call --file-root $USERHOME/.pnbi_salt/appliance/devops --local state.apply setup

