pycharm2018:
  archive:
    - if_missing: /opt/pycharm-community-2018.3.4
    - extracted
    - name: /opt/
    - source: https://download-cf.jetbrains.com/python/pycharm-community-2018.3.4.tar.gz
    - source_hash: md5=540081c8118af80422b9e95b5ec44b40
    - archive_format: tar
    - tar_options: z
    - keep: true
    - user: root
    - group: root

pycharm2020:
  archive:
    - if_missing: /opt/pycharm-community-2020.3.3
    - extracted
    - name: /opt/
    - source: https://download-cf.jetbrains.com/python/pycharm-community-2020.3.3.tar.gz
    - source_hash: md5=12e20683a01fb7182a029fe1ceeeed95
    - archive_format: tar
    - tar_options: z
    - keep: true
    - user: root
    - group: root

pycharm2022:
  archive:
    - if_missing: /opt/pycharm-community-2022.1.3
    - extracted
    - name: /opt/
    - source: https://download.jetbrains.com/python/pycharm-community-2022.1.3.tar.gz
    - source_hash: sha256=888595caa9510d31fd1b56009b6346fd705e8e7cd36d07205f8bf510b92f26a5
    - archive_format: tar
    - tar_options: z
    - keep: true
    - user: root
    - group: root

/opt/pycharm:
  cmd.run:
    - name: |
        test -d /opt/pycharm-community-2022.1.3 && ln -s /opt/pycharm-community-2022.1.3 /opt/pycharm && exit
        test -d /opt/pycharm-community-2020.3.3 && ln -s /opt/pycharm-community-2020.3.3 /opt/pycharm && exit
        test -d /opt/pycharm-community-2018.3.4 && ln -s /opt/pycharm-community-2018.3.4 /opt/pycharm && exit

    - unless: test -h /opt/pycharm

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
