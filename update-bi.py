#!/usr/bin/python3

# wget https://raw.githubusercontent.com/m-rau/appliance/master/update-bi.py
# python3 update-bi.py

from subprocess import check_output, check_call, STDOUT
from os.path import expanduser, abspath, join, exists
from os import chdir, system, unlink, makedirs
import sys

home = abspath(expanduser("~"))
pnbi = join(home, ".pnbi_salt")
worktree = join(pnbi, "appliance")
UPDATE_FILE = join(pnbi, ".upgrade")

def do_update():
    open(UPDATE_FILE, "w").write("")


if not exists(pnbi):
    makedirs(pnbi)
    chdir(pnbi)
    check_call(["/usr/bin/git", "clone",
                "https://github.com/m-rau/appliance.git"])
    check_call(["/usr/bin/wget", "https://bootstrap.saltstack.com",
                "-O", "bootstrap-salt.sh"])
    check_call(["/usr/bin/sudo", "/bin/sh", "bootstrap-salt.sh", "-X",
                "stable"])
    do_update()
else:
    chdir(worktree)
    out = check_output([
        "git", "fetch", "--dry-run"], stderr=STDOUT).decode("utf-8").strip()
    if out != "" or exists(".upgrade"):
        print()
        print("==============================")
        print("Plan.Net Business Intelligence")
        print("==============================")
        print("=> your devops station requires upgrades !\n")
        print()
        print("NOTE: as a core operator it is your responsibility to upgrade")
        print("      your workstation regularly and in time. Upgrades include")
        print("      important security patches as well as productivity tools.")
        print()
        while True:
            print("do you want to upgrade now [y/n]: ", end="")
            inp = input().lower().strip()
            if inp == "y":
                do_update()
                break
            elif inp == "n":
                sys.exit(1)

if exists(UPDATE_FILE):
    print("run upgrade")
    check_call(["git", "pull"])
    cmd = "sudo salt-call --file-root {worktree}/devops -l info --local " \
          "--state-output=changes state.apply setup 2>&1 " \
          "| tee {home}/salt_call.log; chmod 755 {home}/salt_call.log".format(
        worktree=worktree, home=home)
    system(cmd)
    unlink(UPDATE_FILE)

# todo: fix $ systemctrl status console-setup.service