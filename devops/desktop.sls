{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

/opt/Linux-Wallpaper-24.png:
  file.managed:
    - source: salt://asset/core4os_texture_wallpaper.png

setup_desktop:
  cmd.script:
    - source: salt://script/setup_desktop.py
    - runas: {{ username }}

/etc/gdm3/daemon.conf:
  file.append:
    - text: |
        # GDM configuration storage
        # See /usr/share/gdm/gdm.schemas for a list of available options.

        [daemon]
        AutomaticLoginEnable=True
        AutomaticLogin={{ username }}

        [security]

        [xdmcp]

        [chooser]

        [debug]

wallpaper:
  cmd.run:
    - name: |
        /usr/bin/dconf write "/org/gnome/desktop/screensaver/picture-uri" "'file:///opt/Linux-Wallpaper-24.png'"
        /usr/bin/dconf write "/org/gnome/desktop/background/picture-uri" "'file:///opt/Linux-Wallpaper-24.png'"
    - runas: {{ username }}

/opt/system:
  file.absent

/home/{{ username }}/.oh-my-zsh/.core4_installed:
  file.absent

/home/{{ username }}/bootstrap-pnbi.sh:
  file.absent

/home/{{ username }}/.gnome/.core4_installed:
  file.absent

/home/{{ username }}/powerlevel9k/.core4_installed:
  file.absent

/srv/mongodb-linux-x86_64-debian92-4.0.5/.core4_installed:
  file.absent

/opt/Postman/.core4_installed:
  file.absent

/opt/pycharm-community-2018.3.4/.core4_installed:
  file.absent

/opt/robo3t-1.2.1-linux-x86_64-3e50a65/.core4_installed:
  file.absent

systemctrl_console:
  cmd.run:
    - name: |
        sudo systemctl restart console-setup.service
        touch /home/{{ username }}/.pnbi_salt/.systemctrl_console
    - creates: /home/{{ username }}/.pnbi_salt/.systemctrl_console

plan_net_git:
  cmd.run:
    - name: |
        cd /home/{{ username }}/.pnbi_salt/appliance
        git remote set-url origin https://github.com/plan-net/appliance.git
        touch /home/{{ username }}/.pnbi_salt/.plan_net_git
    - creates: /home/{{ username }}/.pnbi_salt/.plan_net_git
