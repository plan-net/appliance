#!/usr/bin/python3

gnome_config = """
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
favorite-apps=['chromium.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'jetbrains-pycharm-ce.desktop', 'robo3t.desktop', 'anaconda-navigator.desktop', 'postman.desktop', 'libreoffice-calc.desktop', 'org.gnome.Software.desktop']
enabled-extensions=['alternate-tab@gnome-shell-extensions.gcampax.github.com']

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
picture-uri='file:///opt/Linux-Wallpaper-24.jpg'
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
picture-uri='file:///opt/Linux-Wallpaper-24.jpg'
show-desktop-icons=true
"""

import configparser
from subprocess import check_output

config = configparser.ConfigParser()
config.read_string(gnome_config)

for section in config.sections():
    for key, value in config.items(section):
        path = "/{}/{}".format(section, key)
        out = check_output(["/usr/bin/dconf", "read", path])
        if out == b"":
            out = check_output(["/usr/bin/dconf", "write", path, value])
            print(path, out)
