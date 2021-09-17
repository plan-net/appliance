#!/bin/bash

SCRIPT=`realpath $0`

if (( $EUID != 0 )); then
    echo "restarting as sudoer, please enter your password ..."
    sudo /bin/bash $SCRIPT $*
    exit
fi

SALT="/home/$SUDO_USER/.pnbi_salt"
SALTCALL="$SALT/appliance/salt-call"
ROOT="$SALT/appliance/devops"
AVAILABLE="$ROOT/module"
MODULE="$AVAILABLE/$*.sls"
STATE="module/$*"
FLAG="$SALT/installed-modules/$*"
INSTALLED="$SALT/installed-modules"

if [ -f $FLAG ]; then
  echo "$*: already installed"
fi

if [ ! -f $MODULE ]; then
  echo "available modules:"
  ls "$AVAILABLE" | grep -E ".+\.sls$" | xargs -I {} basename {} .sls | xargs -I {} sh -c "test -f $INSTALLED/{} && echo '+ {}' || echo '- {}'"
  exit
fi

$SALTCALL --file-root $ROOT -l info --local --state-output=changes state.apply $STATE
touch $FLAG
