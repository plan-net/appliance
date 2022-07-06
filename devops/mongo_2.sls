{% set version = "mongodb-src-r4.4.15" %}

mongo_build:
  cmd.run:
    - name: |
        ECHO {{ version }}
        #cd /tmp
        #mkdir install
        #cd install
        #wget -c https://fastdl.mongodb.org/src/{{ version }}.tar.gz
        #tar xzf {{ version }}.tar.gz
        #cd {{ version }}
        #python3 buildscripts/scons.py install-mongod --disable-warnings-as-errors CCFLAGS="-march=armv8-a+crc"
        #cd build/opt/mongo
        #cp mongod /srv/{{ version }}/bin/
    - cwd: /tmp
    - shell: /bin/bash
    - timeout: 300
    - unless: test -x /tmp/install/{{ version }}/build/opt/mongo/mongod
