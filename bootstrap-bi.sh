#!/bin/bash

# wget https://raw.githubusercontent.com/m-rau/appliance/master/bootstrap-bi.sh -O - | bash

if (( $EUID != 0 )); then
    echo "restarting as root ..."
    su -c "$0"
    exit
fi

if [ -n "$SUDO_USER" ]; then
    USERHOME="/home/$SUDO_USER"
else
    USERHOME="/home/$USERNAME"
fi

test -d "$USERHOME/.pnbi_salt" || mkdir "$USERHOME/.pnbi_salt"
cd "$USERHOME/.pnbi_salt"

if ! [ -x "$(command -v salt-minion)" ]; then
    echo "installing saltstack"
    wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
    sh bootstrap-salt.sh -X stable
fi

if ! [ -x "$(command -v git)" ]; then
    echo "installing git"
    apt-get install git --yes
fi

if [ ! -d appliance ]; then
    git clone https://github.com/m-rau/appliance.git
else
    cd appliance
    git pull
    cd ..
fi

salt-call --file-root $USERHOME/.pnbi_salt/appliance/devops -l debug --local state.apply setup | tee $USERHOME/salt_call.log
