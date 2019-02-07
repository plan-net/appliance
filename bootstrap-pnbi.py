#!/usr/bin/python -u
# -*- coding: utf-8 -*-

import os
import re
import sys
import tempfile
from subprocess import call, check_call, Popen, PIPE

import time

CURDIR = os.path.abspath(os.curdir)
if len(sys.argv) > 1:
    USERNAME = sys.argv[1]
else:
    USERNAME = os.getlogin()

VERSION = "0.2"  # used for config version (future)
PACKAGES = "linux-headers-amd64 gcc make perl sudo tmux screen git curl " \
           "wget mc htop gimp runit runit-systemd zsh python3-venv " \
           "libgconf-2-4 python3-dev build-essential"
ROBO3T = "robo3t-1.2.1-linux-x86_64-3e50a65"
PYCHARM = "pycharm-community-2018.3.4"
CONDA_PACKAGES = "pandas anaconda-navigator rstudio jupyterlab pymongo " \
                 "psycopg2"
POSTMAN = "https://dl.pstmn.io/download/latest/linux64"
CONDA_COMMAND = """
#!/bin/bash

CONDA=/opt/miniconda3/bin
OLD_PATH=$PATH
PATH=$CONDA:$OLD_PATH
type deactivate >/dev/null 2>&1
echo ""
echo "entering conda environment at $CONDA"
echo "type exit to leave"
echo ""
bash --rcfile <(cat ~/.bashrc ; echo 'PS1="(CONDA) $PS1 "')
echo "welcome back"
echo ""
"""
MONGODB = "mongodb-linux-x86_64-debian92-4.0.5"
MONGODB_KEY = """
SiEA9hE6/T+Cc9DBY2pUOeic08XunLEf9UljiUds5DoT1L+oCMBX9yivUtXv+oOf
Vp65/OywcQd+EAs6sZ+xsKfzlVfT7dmZYWVzGsCr0NW5Ku5h37pA5NOyxtX9X3p7
arzd3YwtGRJdtogPJRe8oqKBIyEGFR7rQBOVDDCLHZL67jKUUZ4tseryv3k5S6da
VBOwH5/s2aHQwvxujzbk1vcR4nB9Eg6L0RC3H3O99b/xpt9MJDpcNpUrob4CxzxC
N16S7vL6SAMkJB45pg1BRYfYEGOdaXxofuGjnnQCdXQlsB6Ib41zW+1rg5nzeSUh
YKDO66SwpZBED70+h1Go55p3Ykedr2VifStdAXXM1PLr/O+p3+24G80SB7uhusoq
HS2iXuTtEESKc6jZoup7IAmfdPq1M9CvNBudT/2YeDhUQe+i0CcXsxY4ivH9QZrB
cjdIIQjkxoovdtvmm100Uo4rAJxuNZ7BqQBvhYZTh5WNtbHBetFDnjD9B9s1tHC+
I90G8KgLWsYm72xFoTyOVsUsOz465aWfmg8ibQtVf+X25wSm3egrQin0fpWcWHOO
lc6NwkzrFTrZuxR7KmgCj2R17w2cad5rXE8qEtMfMvbWaeMeJEx+2zi9FIA4YQ3t
ROa5No1fauLY0YSsCG849ycp2M6tZm6iTVll+lOcKdIfIngqtJ59TNJi60unit0N
TD/xwgt2UQz6x6JVFC6JCLfEflebDunhp2gFfk7Vo3SHqjQSrvSU9tUOWfC4y+cX
ilJGimIpCWs18NmKhbqI5KnkN0rClBBmePsDNvVhKv8ddQhdX9UB6hu27dEuWiyN
eyVfy9OLOrYFz2+5JlShE5ljNCh2y2jVFXPzIx/9r/JxC98mB4gqqnEZ91Jn7s2a
5qkZLiBxiQidYwmdu868zvZ83NZ7p+BAYql2kMLKKKcSAQnvIx5UyQy0Ik54h8oF
snjpexPoxGhhZuHtngGVNHjSvGKU
"""
MONGODB_CONFIG = """
systemLog:
    destination: file
    path: "/srv/mongodb/log/mongodb.log"

storage:
    dbPath: "/srv/mongodb/data"
    engine: "wiredTiger"

net:
    bindIp: "127.0.0.1"

processManagement:
    pidFilePath: "/srv/mongodb/mongod.lock"
"""
MONGODB_INIT = """
conn = new Mongo('mongodb://localhost:27017');
db = conn.getDB("admin");
db.createUser(
  {
    user: "core",
    pwd: "654321",
    roles: [ { role: "root", db: "admin" } ]
  }
);
quit()
"""
MONGODB_RUN = """
#!/bin/sh

exec chpst -umongo /srv/mongodb/bin/mongod --config /srv/mongodb/local.conf --auth --keyFile /srv/mongodb/keyfile
"""
HOSTS = """
10.249.1.70     pnbi_mongodb1 mongodb1
10.249.1.71     pnbi_mongodb2 mongodb2

10.249.1.6      pnbi_worker1 worker1
10.249.1.11     pnbi_worker2 worker2
10.249.1.14     pnbi_worker3 worker3
10.249.1.7      pnbi_salt1 salt master pnbi_salt
10.249.1.8      pnbi_app1 app1
10.249.1.15     pnbi_app2 app2
10.249.1.9      pnbi_conti1 conti1
10.249.1.10     pnbi_file1 file1

10.249.1.51     pnbi_jira_psql jira_psql

10.249.2.2      pnbi_sftp1 sftp1
10.249.2.3      pnbi_proxyExt proxyExt
10.249.2.4      pnbi_postgresExt postgresExt
10.249.2.5      pnbi_jira jira
10.249.2.7      pnbi_git
10.249.2.20     pnbi_psqlExt_audible psqlExt_audible
10.249.1.98     pnbi_ipython ipython-server ipython-srv


10.249.1.151    pnbi_staging_mongodb staging_mongodb
10.249.1.152    pnbi_staging_worker1 staging_worker1
10.249.1.153    pnbi_staging_app staging_app
10.249.1.154    pnbi_staging_proxyExt staging_proxyExt staging.bi.plan-net.com
"""

GNOME = """
[org/gnome/settings-daemon/plugins/xsettings]
overrides={'Gtk/ShellShowsAppMenu': <0>, 'Gdk/WindowScalingFactor': <1>}

[org/gnome/terminal/legacy]
schema-version=uint32 3
theme-variant='dark'

[org/gnome/settings-daemon/plugins/power]
sleep-inactive-battery-type='nothing'
sleep-inactive-ac-timeout=3600
sleep-inactive-ac-type='nothing'
sleep-inactive-battery-timeout=1800

[org/gnome/shell]
favorite-apps=['firefox-esr.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'jetbrains-pycharm-ce.desktop', 'robo3t.desktop', 'anaconda-navigator.desktop', 'postman.desktop', 'libreoffice-calc.desktop', 'org.gnome.Software.desktop']

[org/gnome/shell/window-switcher]
app-icon-mode='both'

[org/gnome/shell/overrides]
dynamic-workspaces=false

[org/gnome/nautilus/preferences]
default-folder-viewer='list-view'
search-filter-time-type='last_modified'

[org/gnome/desktop/interface]
clock-show-date=true
toolkit-accessibility=false
gtk-im-module='gtk-im-context-simple'
clock-show-seconds=true
enable-animations=false
gtk-theme='Adwaita-dark'
icon-theme='Adwaita'

[org/gnome/desktop/screensaver]
picture-uri='file:///opt/system/Linux-Wallpaper-24.jpg'
lock-enabled=false

[org/gnome/desktop/calendar]
show-weekdate=true

[org/gnome/desktop/privacy]
remove-old-temp-files=true
old-files-age=uint32 7
remove-old-trash-files=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:appmenu'
num-workspaces=2

[org/gnome/desktop/datetime]
automatic-timezone=true

[org/gnome/desktop/background]
picture-uri='file:///opt/system/Linux-Wallpaper-24.jpg'
show-desktop-icons=true
"""
DESKTOP = {
    "/usr/share/applications/anaconda-navigator.desktop": """
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Name=Anaconda Navigator
Icon=/opt/miniconda3/lib/python3.7/site-packages/anaconda_navigator/static/images/anaconda.png
Categories=Development;IDE;
Exec=/opt/miniconda3/bin/python /opt/miniconda3/bin/anaconda-navigator
Terminal=false
StartupWMClass=Anaconda-Navigator
    """,
    "/usr/share/applications/robo3t.desktop": """
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Name=Robo 3T - 1.2
Icon=/opt/system/robo3t.png
Categories=Development;IDE;
Terminal=false
Exec=/opt/robo3t/bin/robo3t
    """,
    "/usr/share/applications/jetbrains-pycharm-ce.desktop": """
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm Community Edition
Icon=/opt/pycharm-community-2018.3.4/bin/pycharm.svg
Exec="/opt/pycharm-community-2018.3.4/bin/pycharm.sh" %f
Comment=Python IDE for Professional Developers
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-pycharm-ce
    """,
    "/usr/share/applications/postman.desktop": """
[Desktop Entry]
Version=1.0
Type=Application
Name=Postman Community Edition
Icon=/opt/Postman/app/resources/app/assets/icon.png
Exec="/opt/Postman/app/Postman" %f
Comment=Postman API Development
Categories=Development;IDE;
Terminal=false
    """
}
GDM = """
[daemon]
AutomaticLoginEnable=True
AutomaticLogin={username:s}

[security]

[xdmcp]

[chooser]

[debug]
""".format(username=USERNAME)
SSH_CONFIG = """
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_rsa
"""
ZSH_CONFIG = """
source  ~/powerlevel9k/powerlevel9k.zsh-theme
ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_C4() {
    echo ""
}

POWERLEVEL9K_CUSTOM_C4="ZSH_C4"
POWERLEVEL9K_CUSTOM_C4_FOREGROUND="yellow"
POWERLEVEL9K_CUSTOM_C4_BACKGROUND="black"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs custom_c4)
"""


def title(t):
    print("")
    print("%s %s %s" % ("*" * 3, " " * len(t), "*" * 3))
    print("%s %s %s" % ("*" * 3, t, "*" * 3))
    print("%s %s %s" % ("*" * 3, " " * len(t), "*" * 3))


def merge(filename, update):
    start = "# START: CORE4-BOOTSTRAP " + VERSION
    end = "# END: CORE4-BOOTSTRAP " + VERSION
    if os.path.exists(filename):
        body = open(filename, "r").read()
        part1 = re.split("^\# START: CORE4\-BOOTSTRAP.+?\n+", body,
                         flags=re.DOTALL + re.MULTILINE)
        part2 = re.split("^\# END: CORE4\-BOOTSTRAP.+?\n+", body,
                         flags=re.DOTALL + re.MULTILINE)
        update = "\n\n" + start + "\n\n" + update.strip() + "\n\n" + end + "\n\n"
        if len(part2) == 2:
            mod = part2[1].strip()
        else:
            mod = ""
        open(filename, "w").write(part1[0].strip() + update + mod)
    else:
        update = start + "\n\n" + update.strip() + "\n\n" + end + "\n"
        open(filename, "w").write(update)


def home(path):
    if not path.startswith("/"):
        path = "/" + path
    return "/home/" + USERNAME + path


if os.geteuid() != 0:
    cmd = " ".join([sys.executable] + sys.argv)
    print('This is not root. Restarting with\n$ su -c ' + cmd)
    os.execvp("su", ["su", "-c", cmd])

# ########################################################################### #
# welcome
# ########################################################################### #
print("""
██████╗ ███╗   ██╗     ██████╗ ██╗    ██╗   ██╗██████╗ 
██╔══██╗████╗  ██║     ██╔══██╗██║    ██║   ██║██╔══██╗
██████╔╝██╔██╗ ██║     ██████╔╝██║    ██║   ██║██████╔╝
██╔═══╝ ██║╚██╗██║     ██╔══██╗██║    ╚██╗ ██╔╝██╔══██╗
██║     ██║ ╚████║ ██╗ ██████╔╝██║     ╚████╔╝ ██████╔╝
╚═╝     ╚═╝  ╚═══╝ ╚═╝ ╚═════╝ ╚═╝      ╚═══╝  ╚═════╝ 

VERSION {version:s}

This bootstrap script will setup the current VirtualBox 
appliance for user [ {username:s} ].

Please note, that the setup will take quite some time.
So grab a cup of coffee or tea and wait until the 
following components will be installed:

    * files required for VirtualBox guest additions
    * tmux and screen terminal window manager
    * git
    * curl, wget, htop, runit, mc
    * zsh and powerlevel9k shell extension
    * Gimp 
    * Robo3T (AKA Robomongo)
    * Pycharm community edition
    * MongoDB (username "core", password "654321") 
    * Anaconda
    * Postman
    * various desktop startup files
    * Plan.Net BI host names

>>> PRESS RETURN TO CONINUE""".format(version=VERSION, username=USERNAME))

try:
    input = raw_input
except NameError:
    pass

input()

WD = tempfile.mkdtemp()
if not os.path.exists(WD):
    os.makedirs(WD)
print("*** working dir: %s" % (WD))
os.chdir(WD)
print("*** username: %s" % (USERNAME))
check_call(["chown", USERNAME + ":" + USERNAME, WD])

# ########################################################################### #
# general settings
# ########################################################################### #

title("general user settings")
check_call(["usermod", "-G", "vboxsf", "-a", USERNAME])
check_call(["usermod", "-G", "sudo", "-a", USERNAME])

# ########################################################################### #
# tools
# ########################################################################### #

title("tools")
check_call(["apt-get", "update"])
check_call(["apt-get", "install", "--yes"] + PACKAGES.split())

# ########################################################################### #
# robo3t
# ########################################################################### #

if not os.path.exists("/opt/" + ROBO3T + "/.core4_installed"):
    title("robo3t setup")
    if os.path.exists("/opt/" + ROBO3T):
        check_call(["rm", "-R", "-f", "-v", "/opt/" + ROBO3T])
    check_call(["wget", "https://download.robomongo.org/1.2.1/linux/" + ROBO3T
                + ".tar.gz"])
    check_call(["tar", "-x", "-v", "-f", ROBO3T + ".tar.gz"])
    check_call(["mv", ROBO3T, "/opt/"])
    if os.path.exists("/opt/robo3t"):
        check_call(["rm", "/opt/robo3t"])
    check_call(["ln", "-s", "/opt/" + ROBO3T, "/opt/robo3t"])
    if os.path.exists("/usr/local/bin/robo3t"):
        check_call(["rm", "/usr/local/bin/robo3t"])
    check_call(["ln", "-s", "/opt/robo3t/bin/robo3t", "/usr/local/bin/robo3t"])
    open("/opt/" + ROBO3T + "/.core4_installed", "w").write(VERSION)

# ########################################################################### #
# postman
# ########################################################################### #

if not os.path.exists("/opt/Postman"):
    title("Postman setup")
    if os.path.exists("/opt/Postman"):
        check_call(["rm", "-R", "-f", "-v", "/opt/Postman"])
    check_call(["wget", POSTMAN])
    check_call(["tar", "-x", "-v", "-f", "linux64"])
    check_call(["mv", "Postman", "/opt/"])
    if os.path.exists("/usr/local/bin/postman"):
        check_call(["rm", "/usr/local/bin/postman"])
    check_call(
        ["ln", "-s", "/opt/Postman/app/Postman", "/usr/local/bin/postman"])
    open("/opt/Postman/.core4_installed", "w").write(VERSION)

# ########################################################################### #
# Pycharm
# ########################################################################### #

if not os.path.exists("/opt/" + PYCHARM + "/.core4_installed"):
    title("pycharm setup")
    if os.path.exists("/opt/" + PYCHARM):
        check_call(["rm", "-R", "-f", "-v", "/opt/" + PYCHARM])
    check_call(["wget", "https://download-cf.jetbrains.com/python/" + PYCHARM
                + ".tar.gz"])
    check_call(["tar", "-x", "-v", "-f", PYCHARM + ".tar.gz"])
    check_call(["mv", PYCHARM, "/opt/"])
    if os.path.exists("/opt/pycharm"):
        check_call(["rm", "/opt/pycharm"])
    check_call(["ln", "-s", "/opt/" + PYCHARM, "/opt/pycharm"])
    if os.path.exists("/usr/local/bin/pycharm"):
        check_call(["rm", "/usr/local/bin/pycharm"])
    check_call(["ln", "-s", "/opt/pycharm/bin/pycharm.sh",
                "/usr/local/bin/pycharm"])
    open("/opt/" + PYCHARM + "/.core4_installed", "w").write(VERSION)

# ########################################################################### #
# miniconda with plugins
# ########################################################################### #

# - anaconda-navigator
# - pandas
# - rstudio
# - jupyterlab and ipython notebooks

if not os.path.exists("/opt/miniconda3/.core4_installed"):
    title("miniconda setup")
    if os.path.exists("/opt/miniconda3"):
        check_call(["rm", "-R", "-f", "-v", "/opt/miniconda3"])
    check_call(["wget", "https://repo.continuum.io/miniconda/"
                        "Miniconda3-latest-Linux-x86_64.sh"])
    check_call(["bash", "Miniconda3-latest-Linux-x86_64.sh", "-b", "-p",
                "/opt/miniconda3"])
    env = os.environ
    env["PATH"] = "/opt/miniconda3/bin:" + env["PATH"]
    check_call(["/opt/miniconda3/bin/conda", "upgrade", "--all", "-y"],
               env=env)
    check_call(["/opt/miniconda3/bin/conda", "install", "-q", "-y"] +
               CONDA_PACKAGES.split(), env=env)
    open("/usr/local/bin/conda", "w").write(CONDA_COMMAND)
    check_call(["chmod", "-v", "755", "/usr/local/bin/conda"])
    open("/opt/miniconda3/.core4_installed", "w").write(VERSION)

# ########################################################################### #
# MongoDB
# ########################################################################### #

if not os.path.exists("/srv/" + MONGODB + "/.core4_installed"):
    title("MongoDB setup")
    call(["sv", "down", "mongodb"])
    if os.path.exists("/srv/" + MONGODB):
        check_call(["rm", "-R", "-f", "-v", "/srv/" + MONGODB])
    check_call(["wget", "https://fastdl.mongodb.org/linux/" + MONGODB
                + ".tgz"])
    check_call(["tar", "-x", "-v", "-f", MONGODB + ".tgz"])
    check_call(["mv", MONGODB, "/srv/"])
    if os.path.exists("/srv/mongodb"):
        check_call(["rm", "-R", "-v", "-f", "/srv/mongodb"])
    os.makedirs("/srv/mongodb")
    os.makedirs("/srv/mongodb/data")
    os.makedirs("/srv/mongodb/log")
    check_call(["ln", "-s", "/srv/" + MONGODB + "/bin", "/srv/mongodb/bin"])
    open("/srv/mongodb/keyfile", "w").write(MONGODB_KEY.strip())
    open("/srv/mongodb/local.conf", "w").write(MONGODB_CONFIG)
    check_call(["adduser", "--system", "--no-create-home", "--disabled-login",
                "--group", "mongo"])
    check_call(["chmod", "-v", "600", "/srv/mongodb/keyfile"])
    check_call(["chown", "-v", "-R", "-f", "-L", "mongo:mongo",
                "/srv/mongodb"])
    check_call(["/usr/bin/chpst", "-u", "mongo", "/srv/mongodb/bin/mongod",
                "--fork", "-f", "/srv/mongodb/local.conf"])
    while True:
        try:
            proc = Popen(
                ["/srv/mongodb/bin/mongo", "--host", "127.0.0.1", "--port",
                 "27017"], stdin=PIPE)
            proc.stdin.write(MONGODB_INIT)
            proc.wait()
            break
        except:
            print("waiting ...")
            time.sleep(1)
    check_call(["killall", "/srv/mongodb/bin/mongod"])
    if os.path.exists("/etc/sv/mongodb"):
        check_call(["rm", "-R", "-v", "-f", "/etc/sv/mongodb"])
    os.makedirs("/etc/sv/mongodb")
    open("/etc/sv/mongodb/run", "w").write(MONGODB_RUN.strip())
    check_call(["chmod", "755", "/etc/sv/mongodb/run"])
    if os.path.exists("/etc/service/mongodb"):
        check_call(["rm", "-R", "-v", "-f", "/etc/service/mongodb"])
    check_call(["ln", "-s", "/etc/sv/mongodb", "/etc/service/mongodb"])
    call(["sv", "up", "mongodb"])
    call(["sv", "status", "mongodb"])
    open("/srv/" + MONGODB + "/.core4_installed", "w").write(VERSION)

# ########################################################################### #
# /etc/hosts
# ########################################################################### #

title("/etc/hosts")
merge("/etc/hosts", HOSTS)

# ########################################################################### #
# images
# ########################################################################### #

title("images")
if not os.path.exists("/opt/system"):
    os.makedirs("/opt/system")

if not os.path.exists("/opt/system/robo3t.png"):
    call(["wget", "https://dashboard.snapcraft.io/site_media"
                  "/appmedia/2018/09/logo-256x256.png",
          "-O", "/opt/system/robo3t.png"])

if not os.path.exists("/opt/system/Linux-Wallpaper-24.jpg"):
    call(["wget", "http://www.technocrazed.com/wp-content/uploads"
                  "/2015/12/Linux-Wallpaper-24.jpg",
          "-O", "/opt/system/Linux-Wallpaper-24.jpg"])

# ########################################################################### #
# Desktop starters
# ########################################################################### #

for desk, body in DESKTOP.items():
    if not os.path.exists(desk):
        open(desk, "w").write(body.strip())

# ########################################################################### #
# gnome settings
# ########################################################################### #

title("gnome 3 settings")
open("settings", "w").write(GNOME)
os.system('su ' + USERNAME + ' -c "/usr/bin/dconf load / < settings"')

# ########################################################################### #
# ssh config
# ########################################################################### #

title("ssh config")
merge(home("/.ssh/config"), SSH_CONFIG)

# ########################################################################### #
# zsh shell
# ########################################################################### #

if not os.path.exists(home("/.oh-my-zsh/.core4_installed")):
    title("zsh shell")
    if os.path.exists(home("/.oh-my-zsh")):
        check_call(["rm", "-R", "-f", "-v", home("/.oh-my-zsh")])
    if os.path.exists(home("/.zshrc")):
        check_call(["rm", "-R", "-f", "-v", home("/.zshrc")])
    check_call(["git", "clone",
                "https://github.com/robbyrussell/oh-my-zsh.git",
                home("/.oh-my-zsh")])
    check_call(["cp", home("/.oh-my-zsh/templates/zshrc.zsh-template"),
                home("/.zshrc")])
    check_call(["chown", "-R", "-v", USERNAME + ":" + USERNAME,
                home("/.zshrc")])
    check_call(["chown", "-R", "-v", USERNAME + ":" + USERNAME,
                home("/.oh-my-zsh")])
    check_call(["usermod", "--shell", "/usr/bin/zsh", USERNAME])
    merge(home("/.zshrc"), ZSH_CONFIG)
    open(home("/.oh-my-zsh/.core4_installed"), "w").write(VERSION)

# ########################################################################### #
# powerlevel9k
# ########################################################################### #

if not os.path.exists(home("/powerlevel9k/.core4_installed")):
    title("powerlevel9k zsh extension")
    if os.path.exists(home("/powerlevel9k")):
        check_call(["rm", "-R", "-f", "-v", home("/powerlevel9k")])
    check_call(["git", "clone", "https://github.com/bhilburn/powerlevel9k.git",
                home("/powerlevel9k")])
    check_call(["chown", "-R", "-v", USERNAME + ":" + USERNAME,
                home("/powerlevel9k")])
    check_call(["wget", "https://github.com/powerline/powerline/raw/develop"
                        "/font/PowerlineSymbols.otf"])
    check_call(["wget", "https://github.com/powerline/powerline/raw/develop"
                        "/font/10-powerline-symbols.conf"])
    if not os.path.exists(home("/.local/share/fonts/")):
        os.makedirs(home("/.local/share/fonts/"))
    check_call(["mv", "PowerlineSymbols.otf", home("/.local/share/fonts/")])
    check_call(["fc-cache", home("/.local/share/fonts/")])
    if not os.path.exists(home("/.config/fontconfig/conf.d/")):
        os.makedirs(home("/.config/fontconfig/conf.d/"))
    check_call(["mv", "10-powerline-symbols.conf",
                home("/.config/fontconfig/conf.d/")])
    check_call(["chown", "-R", "-v", USERNAME + ":" + USERNAME,
                home("/.local/share/fonts")])
    check_call(["chown", "-R", "-v", USERNAME + ":" + USERNAME,
                home("/.config/fontconfig/conf.d")])
    open(home("/powerlevel9k/.core4_installed"), "w").write(VERSION)

# ########################################################################### #
# auto login
# ########################################################################### #

title("auto login")
merge("/etc/gdm3/daemon.conf", GDM)

# finish

os.chdir(CURDIR)
call(["rm", "-R", "-f", WD])

print("\ndone.\n")
print("To finish the setup you need to reboot\n\n"
      ">>> PRESS RETURN TO CONINUE (press CTRL+C to stop)")
input()

call(["reboot"])
