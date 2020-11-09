{% set version = "robo3t-1.2.1-linux-x86_64-3e50a65" %}

robomongo:
  pkg.purged

robo3t_archive:
  archive:
    - if_missing: /opt/{{ version }}
    - extracted
    - name: /opt/
    - source: https://download.robomongo.org/1.2.1/linux/robo3t-1.2.1-linux-x86_64-3e50a65.tar.gz
    - source_hash: md5=8e65429b6b81f096b822d7aeb80eb818
    - archive_format: tar
    - tar_options: z
    - keep: true
    - user: root
    - group: root

/opt/robo3t:
  file.symlink:
    - target: /opt/{{ version }}/

/usr/local/bin/robo3t:
  file.symlink:
    - target: /opt/robo3t/bin/robo3t

/usr/share/applications/robo3t.desktop:
  file.managed:
    - contents: |
        [Desktop Entry]
        Encoding=UTF-8
        Version=1.0
        Type=Application
        Name=Robo 3T - 1.4
        Icon=/opt/robo3t/logo-256x256.png
        Exec=/opt/robo3t/bin/robo3t
        StartupNotify=false
        Categories=Development;IDE;
        Terminal=false

/opt/robo3t/logo:
  cmd.run:
    - name : wget https://dashboard.snapcraft.io/site_media/appmedia/2018/09/logo-256x256.png -O /opt/robo3t/logo-256x256.png
    - creates: /opt/robo3t/logo-256x256.png
