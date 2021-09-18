#!/usr/bin/python3

import datetime
import sys
from glob import glob
from os import chdir, system, unlink, makedirs, getlogin
from os.path import expanduser, abspath, join, exists, basename
from subprocess import check_output, check_call, STDOUT, DEVNULL

home = abspath(expanduser("~"))
pnbi = join(home, ".pnbi_salt")
worktree = join(pnbi, "appliance")
UPDATE_FILE = join(pnbi, ".upgrade")
INSTALLED_MODULES = join(pnbi, "installed-modules/*")

username = getlogin()


def do_update():
    open(UPDATE_FILE, "w").write("")


chdir(worktree)
try:
    out = check_output([
        "git", "fetch", "--dry-run"], stderr=STDOUT).decode(
        "utf-8").strip()
except:
    print("no connection...\n... cannot check for upgrades!\nskip")
    sys.exit()

if out != "" or exists(UPDATE_FILE):
    do_update()
    print("get upgrade")
    branch = check_output([
        "git", "rev-parse", "--symbolic-full-name", "--abbrev-ref", 
        "HEAD"], stderr=DEVNULL).decode("utf-8").strip()
    check_call(["git", "fetch"], stderr=STDOUT, stdout=DEVNULL)
    print()
    title = "PN BI APPLIANCE ({})".format(branch)
    print("=" * len(title))
    print(title)
    print("=" * len(title))
    print()
    print("=> your devops station requires upgrades !")
    print()
    print("NOTE: as a core user it is your responsibility to upgrade")
    print("      your workstation regularly and in time. Upgrades include")
    print("      important security patches as well as productivity tools.")
    print()
    out = check_output([
        "git", "--no-pager", "log",
        "--pretty=format:%s %Cgreen(%cr)%Creset by %C(bold blue)%an%Creset",
        "{branch}..origin/{branch}".format(branch=branch)]).decode(
            "utf-8").strip()
    if out:
        print("CHANGES:")
        print()
        lines = ["  " + i for i in out.split("\n")
                 if not i.strip().startswith("#")]
        sys.stdout.write("\n".join(lines))
        print()
        print()
    while True:
        print("do you want to upgrade now [y/n]: ", end="")
        inp = input().lower().strip()
        if inp == "y":
            break
        elif inp == "n":
            sys.exit(1)

if exists(UPDATE_FILE):
    t0 = datetime.datetime.now()
    chdir(worktree)
    check_call(["git", "reset", "--hard", "origin/" + branch])
    check_call(["git", "pull"])
    print("run upgrade")
    cmd = "sudo truncate --size 0 {home}/salt_call.log".format(home=home)
    system(cmd)
    cmd = "sudo chmod 777 {home}/salt_call.log".format(home=home)
    system(cmd)
    module = ["setup"]
    module += ["module/" + basename(m) for m in glob(INSTALLED_MODULES)]
    for mod in module:
        print()
        print("*" * 80)
        print("***", mod)
        print("*" * 80, "\n")
        cmd = "sudo ./salt-call --file-root {worktree}/devops -l info --local " \
              "--state-output=changes state.apply {module} 2>&1 " \
              "| tee -a {home}/salt_call.log 2>&1".format(
            worktree=worktree, home=home, module=mod)
        system(cmd)
    cmd = "sudo chmod 777 {home}/salt_call.log".format(home=home)
    system(cmd)
    if exists(UPDATE_FILE):
        unlink(UPDATE_FILE)
    out = False
    error = False
    for line in open(join(home, "salt_call.log"), "r"):
        if line.lower().startswith("summary for local"):
            out = True
        if out:
            if line.lower().startswith("failed:"):
                if int(line.split()[1]) > 0:
                    error = True
    print()
    cmd = "sudo chown -R {username}:{username} {pnbi}".format(
        username=username, pnbi=pnbi)
    system(cmd)
    print("RUNTIME:", datetime.datetime.now() - t0)
    if error:
        print()
        print("!!! THERE HAVE BEEN FAILURES WITH YOUR UPGRADE")
        print("!!! PLEASE CONTACT bi-ops@plan-net.com")
        print("!!! AND ATTACH FILE {home}/salt_call.log".format(home=home))
        print()
