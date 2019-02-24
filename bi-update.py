#!/usr/bin/python3

from subprocess import check_output, check_call, STDOUT
from os.path import expanduser, abspath, join, exists
from os import chdir, system, unlink
import sys

home = abspath(expanduser("~"))
worktree = join(home, ".pnbi_salt/appliance")
chdir(worktree)
out = check_output([
    "git", "fetch", "--dry-run"], stderr=STDOUT).decode("utf-8").strip()
if out != "" or exists(".upgrade"):
    print("==============================")
    print("Plan.Net Business Intelligence")
    print("==============================")
    print("=> your devops station requires update\n")
    print()
    print("   NOTE: as a core operator it is your responsibility to upgrade")
    print("         your workstation regularly and in time. Upgrades include")
    print("         important security patches as well as productivity tools.")
    print()
    while True:
        print("   do you want to upgrade now [y/n]: ", end="")
        inp = input().lower().strip()
        if inp == "y":
            open(".upgrade", "w").write("")
            break
        elif inp == "n":
            sys.exit(1)

if exists(".upgrade"):
    print("run upgrade")
    check_call(["git", "pull"])
    cmd = "sudo salt-call --file-root {worktree}/devops -l debug --local " \
          "state.apply setup 2>&1 | tee {home}/salt_call.log; " \
          "chmod 755 {home}/salt_call.log".format(
        worktree=worktree, home=home)
    system(cmd)
    unlink(".upgrade")
