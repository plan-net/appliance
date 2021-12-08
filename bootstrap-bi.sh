#!/bin/bash

# wget https://raw.githubusercontent.com/plan-net/appliance/master2/bootstrap-bi.sh
# bash bootstrap-bi.sh

if (( $EUID != 0 )); then
    echo "restarting as root, please enter your password ..."
    su -c "export AUTO=1; cd $PWD; /bin/bash $0 $*"
    exit
fi

if [[ $AUTO -ne 1 ]]; then
    echo "you must not start this script as root"
    exit
fi

if [ -n "$SUDO_USER" ]; then
    USER="$SUDO_USER"
else
    USER="$USERNAME"
fi
USERHOME="/home/$USER"

if [[ $# -eq 0 ]] ; then
    BRANCH="master2"
else
    BRANCH="$1"
fi

HL='\033[1;32m'
DG='\033[1;30m'
G='\u001b[38;5;22m'
NC='\033[0m' # No Color

clear
printf "${HL}
  ____  _   _ ____ ___                       
 |  _ \| \ | | __ )_ _|                      
 | |_) |  \| |  _ \| |                       
 |  __/| |\  | |_) | |                       
 |_|   |_| \_|____/___|                      
   __ _ _ __  _ __ | (_) __ _ _ __   ___ ___ 
  / _\` | '_ \| '_ \| | |/ _\` | '_ \ / __/ _ \\
 | (_| | |_) | |_) | | | (_| | | | | (_|  __/
  \__,_| .__/| .__/|_|_|\__,_|_| |_|\___\___|
       |_|   |_|

VERSION 2.1${NC} as $USER in $USERHOME

This script will setup your Debian virtualbox (appliance branch $BRANCH)

It features:

    * various ${HL}utilities${NC}, i.e. git, curl, wget, mc, htop, gcc, 
      tmux, screen, yarn
    * ${HL}zsh${NC} extended Bourne shell, including the 
      ${HL}Powerlevel9k${NC} theme for zsh
    * a local ${HL}MongoDB server${NC} instance
    * ${HL}Robo3T${NC} and MongoDB ${HL}Compass${NC} client
    * ${HL}Postman${NC}, the API development environment
    * hostnames of Plan.Net BI ${HL}clusters at AWS and SP${NC}, including 
      ssh tweaks
    * various ${HL}Desktop tweaks${NC} to make your life easier
    * preinstalled ${HL}core3 and core4os${NC} sources
    * additional optional modules for Pycharm, Chrome, Visual Code, R and 
      Python 3.8

Installation will take several minutes.
So, grab a cup of coffee while you go!

Press ${HL}<RETURN>${NC} to continue (or CTRL-C to quit) ... "
read
echo ""

test -d "$USERHOME/.pnbi_salt" || mkdir "$USERHOME/.pnbi_salt"
chown $USER:$USER "$USERHOME/.pnbi_salt"
cd "$USERHOME/.pnbi_salt"

if ! [ -x "$(command -v salt-minion)" ]; then
    echo "installing saltstack"
    wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
    sh bootstrap-salt.sh -X stable 3003.3
fi

if ! [ -x "$(command -v git)" ]; then
    echo "installing git"
    apt-get install git --yes
fi

if [ ! -d appliance ]; then
    git clone https://github.com/plan-net/appliance.git
else
    cd appliance
    git pull
    cd ..
fi
cd appliance
git checkout -f "$BRANCH"
cd ..

test -f $USERHOME/.pnbi_salt/.update && rm $USERHOME/.pnbi_salt/.update
salt-call --file-root $USERHOME/.pnbi_salt/appliance/devops -l info --local --state-output=changes state.apply setup 2>&1 | tee $USERHOME/salt_call.log
chown $USER:$USER $USERHOME/salt_call.log
chmod 777 $USERHOME/salt_call.log
chown -R $USER:$USER "$USERHOME/.pnbi_salt"

echo
echo "system requires reboot"
echo "hit return to continue"
echo
read answer

reboot
