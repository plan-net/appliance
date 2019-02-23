{% set username = salt['environ.get']('SUDO_USER') or salt['environ.get']('USERNAME') %}

/opt/Linux-Wallpaper-24.png:
  file.managed:
    - source: salt://asset/core4_wallpaper.png

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