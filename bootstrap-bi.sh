#!/bin/bash

# wget https://raw.githubusercontent.com/m-rau/appliance/master/bootstrap-bi.sh
# bash bootstrap-bi.sh

if (( $EUID != 0 )); then
    echo "restarting as root..."
    echo "$ cd $PWD; /bin/bash $0"
    su -c "cd $PWD; /bin/bash $0"
    exit
fi

if [ -n "$SUDO_USER" ]; then
    USER="$SUDO_USER"
else
    USER="$USERNAME"
fi
USERHOME="/home/$USER"

echo "starting in $USERHOME for $USER"
exit

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
    chown -R $USER:$USER appliance
else
    cd appliance
    git pull
    cd ..
fi

salt-call --file-root $USERHOME/.pnbi_salt/appliance/devops -l info --local state.apply setup 2>&1 | tee $USERHOME/salt_call.log
chmod 755 $USERHOME/salt_call.log

echo
echo "system requires reboot"
echo "hit return to continue"
echo
read answer

reboot
