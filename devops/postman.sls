{% set VERSION = "x64-7.36.1" %}

postman_version:
  cmd.run:
    - name: |
        curl --quiet -I -X GET https://dl.pstmn.io/download/latest/linuxx64 > /tmp/postman.version 2>/dev/null
        cat /tmp/postman.version | grep "application/gzip" || exit 0
        cat /tmp/postman.version | grep "{{ VERSION }}.tar.gz" && exit 0
        cd /tmp
        curl -X GET https://dl.pstmn.io/download/latest/linuxx64 > Postman-linux-{{ VERSION }}.tar.gz
        tar -xvf Postman-linux-{{ VERSION }}.tar.gz
        rm -Rf /opt/Postman
        mv Postman /opt/

/usr/local/bin/postman:
  file.symlink:
    - target: /opt/Postman/Postman

/usr/share/applications/postman.desktop:
  file.managed:
    - contents: |
        [Desktop Entry]
        Version=1.0
        Type=Application
        Name=Postman Community Edition
        Icon=/opt/Postman/app/resources/app/assets/icon.png
        Exec="/opt/Postman/app/Postman" %f
        Comment=Postman API Development
        Categories=Development;IDE;
        Terminal=false
