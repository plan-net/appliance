#!/bin/bash

SCRIPT=`realpath $0`

if (( $EUID != 0 )); then
    echo "restarting as sudoer, please enter your password ..."
    sudo /bin/bash $SCRIPT $*
    exit
fi

SALT="/home/$SUDO_USER/.pnbi_salt"
ROOT="$SALT/appliance/devops"
MODULE="$ROOT/module/$*.sls"
STATE="module/$*"
FLAG="$SALT/installed-modules/$*"

if [ -f $FLAG ]; then
  echo "$*: already installed"
fi

if [ ! -f $MODULE ]; then
  echo "$*: not found"
  exit
fi

salt-call --file-root $ROOT -l info --local --state-output=changes state.apply $STATE
touch $FLAG
