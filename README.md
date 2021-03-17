SETUP APPLIANCE WITH VIRTUALBOX
===============================

This guide describes the setup of the core4os development environment as known
as the appliance. This appliance is a Debian 9 Linux hosted in an Oracle 
VirtualBox. Operating system, software installation, configuration and upgrades 
of the development environment are supported with a bootstrap procedure.

APPLIANCE FEATURES
------------------

The appliance ships with the following features:

* various utilities, i.e. git, curl, wget, mc, htop, gcc, tmux, screen, yarn
* frontend development tools, i.e. nodejs and yarn
* a local MongoDB server instance
* Robo3T and MongoDB Compass client
* Postman, the API development environment
* preconfigured hostnames of Plan.Net BI clusters at AWS and SP, including ssh tweaks
* various Desktop tweaks to make your life easier
* preinstalled core3 and core4os sources
* zsh extended Bourne shell, including the Powerlevel9k theme for zsh

On top of the standard setup the appliance ships with optional modules

* Pycharm, the Python Integrated Development Environment
* Chrome browser
* Python 3.8
* R
* Visual Code

VIRTUALBOX INSTALLATION AND PREPARATION
---------------------------------------

### WINDOWS AND MAC

Download and install the latest version from
https://www.virtualbox.org/wiki/Downloads.

### LINUX

There are various step-by-step guides available in the web. See for example
https://tecadmin.net/install-virtualbox-debian-9-stretch/.

#### prerequisites

    su -
    apt-get update
    apt-get upgrade

    # add software repository
    echo "deb <http://download.virtualbox.org/virtualbox/debian> stretch contrib" | tee /etc/apt/sources.list.d/virtualbox.list

    # import sign key
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -

    # install and launch
    apt-get update
    apt-get install virtualbox-6.0

CREATE A VIRTUAL MACHINE
------------------------

Create a new virtual machine with the following settings:

* Linux
* 4 GB RAM or more
* virtual hard disk with fixed size, e.g. 64 GB or more

### INSTALL DEBIAN 9

Download Debian 9 ISO image from 
https://www.debian.org/releases/stretch/debian-installer/index.de.html

Start the virtual machine and select the downloaded image for installation. 
During installation select the following when prompted

* Partitioning method: Guided - use the entire disk
* Partitioning scheme: All files in one partition
* Write changes to disk: Yes
* Scan another CD or DVD: No
* HTTP proxy information: (leave this blank)
* Software to install: 'Debian desktop environment', 'GNOME' and 'standard system utilities'
* Device for boot loader installation: /dev/sda or similar

As a general rule, choose all default settings unless you know what you are doing.

**REMEMBER YOUR PASSWORDS!** You need to remember the administration and your 
personal password. If you do not remember, then you will have to setup a fresh
appliance. We cannot recover any lost or forgotten passwords!

### INSTALL GUEST ADDITIONS

Start the Debian 9 virtual machine, launch a terminal and run the following 
commands:

    su -
    apt update
    apt upgrade
    apt install build-essential module-assistant dkms
    m-a prepare

In the "Devices" menu in VirtualBox, select "Insert Guest Additions CD image."
Then continue on the terminal:

    sh /media/cdrom/VBoxLinuxAdditions.run
    reboot

Setup the display in Debian to suite your needs. Create a permanent, 
auto-mounted shared folder to your host operating system.

INSTALL THE APPLIANCE
---------------------

Open a terminal and run the following commands

    wget https://raw.githubusercontent.com/plan-net/appliance/master2/bootstrap-bi.sh
    bash bootstrap-bi.sh

### ADDITIONAL APPLIANCE MODULES

Software and configuration states are packaged in appliance modules. List 
available appliance modules with

    bi-installer

Install a module of your choice with for example

    bi-installer chrome
    bi-installer vscode
    bi-installer python38
    # etc.

Please note that the latest version of core4os runs best with Python 3.8. 
You should install python38 module!

Continue core4os installation as describe at https://github.com/plan-net/core4.
Note that the appliance you just installed delivers most prerequisites so that
you can directly [start here](https://github.com/plan-net/core4#core4os-installation-backend-only).


ADDITIONAL NOTES
----------------

The Plan.Net BI appliance ships with an automated update. You can enforce 
the update with touch ```~/.pnbi_salt/.upgrade```.

For testing purposes you can pass a branch to ```bootstrap-bi.sh```. The 
default branch is _master2_. To switch for example to develop, run
```bash bootstrap-bi.sh develop```. Please note, that automatic updates 
are working with this branch. You will have to switch back to master manually
by running the ```bootstrap-bi.sh``` script again or by checking out to master
manually in  ```git -C ~/.pnbi_salt/appliance checkout master```.

It is safe to run ```~/.pnbi_salt/appliance/update-bi.py``` manually and at any 
time.
