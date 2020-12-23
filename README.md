SETUP APPLIANCE WITH VIRTUALBOX
===============================

This guide describes the setup of Oracle VirtualBox and the installation of the
Plan.Net Business Intelligence appliance on Debian 9 (Stretch). Please note that
only Debian 9 is supported at the moment.

The appliance ships with the following features:

* various utilities, i.e. git, curl, wget, mc, htop, gcc, tmux, screen, yarn
* zsh extended Bourne shell, including the Powerlevel9k theme for zsh
* a local MongoDB server instance
* Robo3T
* Postman, the API development environment
* Chromium, the Open-Source browser, Gimp, the GNU Image
  Manipulation Program, Meld, the graphical diff tool
* hostnames of Plan.Net BI clusters at AWS and SP, including ssh tweaks
* various Desktop tweaks to make your life easier
* preinstalled core3 and core4os sources

Optional modules are available and can be installed:
* chrome
* pycharm
* python38
* R
* vscode

Install these with for example ``bi-installer R``.


Install Virtualbox
------------------

### Windows and Mac Installation

Download and install the latest version from
https://www.virtualbox.org/wiki/Downloads.

### Linux Installation

There are various step-by-step guides available in the web. See for example 
https://tecadmin.net/install-virtualbox-debian-9-stretch/.

#### prerequisites

    sudo apt-get update
    sudo apt-get upgrade

#### add software repository

    echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

#### import sign key

    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

#### install and launch

    sudo apt-get update
    sudo apt-get install virtualbox-6.0


Create a Virtual Machine
------------------------

Launch virtualbox with the following settings:

* 4gB RAM or more
* virtual hard disk with *fixed size*, e.g. 64gB or more


Install Debian 9
----------------

Download Debian 9 ISO image from 
https://www.debian.org/releases/stretch/debian-installer/index.de.html

Start the virtual machine and select the downloaded image for installation.

**REMEMBER YOUR PASSWORDS!** You need to remember the administration and your
personal password. If you do not remember, then you will have to setup a fresh
appliance. We cannot recover any lost or forgotten passwords!


Install Guest Additions
-----------------------

Start the Debian 9 virtual machine, launch a terminal and run the following 
commands:

    su -
    apt update
    apt upgrade
    apt install build-essential module-assistant dkms
    m-a prepare
    sh /media/cdrom/VBoxLinuxAdditions.run
    reboot

Setup the display in Debian to suite your needs.


Install Plan.Net BI appliance
-----------------------------

Open a terminal and run the following commands

    wget https://raw.githubusercontent.com/plan-net/appliance/master/bootstrap-bi.sh
    bash bootstrap-bi.sh


ADDITIONAL NOTES
================

* The Plan.Net BI appliance ships with an automated update. You can enforce the
  update with `touch ~/.pnbi_salt/.upgrade`.

* For testing purposes you can pass a branch to `bootstrap-bi.sh`. The default
  branch is *master*. To switch for example to develop, run 
  `bash bootstrap-bi.sh develop`. **Please note**, that automatic updates are
  working with this branch. You will have to switch back to master manually
  by running the `bootstrap-bi.sh` script again or by checking out to master
  manually in `git -C ~/.pnbi_salt/appliance checkout master`.
  
* It is safe to run `~/.pnbi_salt/appliance/bootstrap-bi.sh` or 
  `~/.pnbi_salt/appliance/update-bi.py`
  manually and at any time.
