{% set version = "pycharm-community-2018.3.4" %}

pycharm_archive:
  archive:
    - if_missing: /opt/{{ version }}
    - extracted
    - name: /opt/
    - source: https://download-cf.jetbrains.com/python/{{ version }}.tar.gz
    - source_hash: md5=540081c8118af80422b9e95b5ec44b40
    - archive_format: tar
    - tar_options: z
    - keep: true
    - user: root
    - group: root

/opt/pycharm:
  file.symlink:
    - target: /opt/{{ version }}/xxx

/usr/local/bin/pycharm:
  file.symlink:
    - target: /opt/pycharm/bin/pycharm.sh

/usr/share/applications/jetbrains-pycharm-ce.desktop:
  file.managed:
    - contents: |
        [Desktop Entry]
        Version=1.0
        Type=Application
        Name=PyCharm Community Edition
        Icon=/opt/pycharm/bin/pycharm.svg
        Exec="/opt/pycharm/bin/pycharm.sh" %f
        Comment=Python IDE for Professional Developers
        Categories=Development;IDE;
        Terminal=false
        StartupWMClass=jetbrains-pycharm-ce
