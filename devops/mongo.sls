{% set version = "mongodb-linux-x86_64-debian92-4.0.13" %}

https://fastdl.mongodb.org/linux/mongodb-shell-linux-x86_64-debian11-5.0.9.tgz

mongo_group:
  group.present:
    - name: mongo

mongo:
  user.present:
    - fullname: MongoDB user
    - createhome: false
    - shell: /usr/sbin/nologin
    - groups:
      - mongo

/srv/mongodb:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/srv/mongodb/data:
  file.directory:w
    - user: mongo
    - group: root
    - mode: 770
    - makedirs: True

/srv/mongodb/log:
  file.directory:
    - user: mongo
    - group: root
    - mode: 755
    - makedirs: True

mongo_archive:
  archive:
    - if_missing: /srv/{{ version }}
    - extracted
    - name: /srv/
    - source: https://fastdl.mongodb.org/linux/{{ version }}.tgz
    - source_hash: md5=66905685ed6859c2fbe70de562917e7d
    - archive_format: tar
    - tar_options: z
    - keep: false
    - user: root
    - group: root

/srv/mongodb/bin:
  file.symlink:
    - target: /srv/{{ version }}/bin

mongo_keyfile:
  cmd.run:
    - name: |
        openssl rand -base64 741 > /srv/mongodb/keyfile
        chmod 0600 /srv/mongodb/keyfile
        chown mongo:root /srv/mongodb/keyfile
    - creates: /srv/mongodb/keyfile

/srv/mongodb/local.conf:
  file.managed:
    - contents: |
        systemLog:
            destination: file
            path: "/srv/mongodb/log/mongodb.log"

        storage:
            dbPath: "/srv/mongodb/data"
            engine: "wiredTiger"

        net:
            bindIp: "127.0.0.1"

        processManagement:
            pidFilePath: "/srv/mongodb/log/mongod.lock"

        replication:
           oplogSizeMB: 1000
           replSetName: rs0

setup_mongo:
  cmd.script:
    - source: salt://script/setup_mongo.sh
    - creates: /srv/mongodb/data/.core4_installed

/etc/sv/mongodb:
  file.directory:
    - mode: 750
    - makedirs: True

mongodb_runit:
  file.managed:
    - name: /etc/sv/mongodb/run
    - mode: 750
    - contents: |
        #!/bin/sh

        ls -tp /srv/mongodb/log/mongodb.log.* | grep -v '/$' | tail -n +3 | tr '\n' '\0' | xargs -0 -I {} echo {}
        exec /usr/bin/chpst -u mongo /srv/mongodb/bin/mongod --auth -f /srv/mongodb/local.conf

mongodb_service_link:
  file.symlink:
    - name: /etc/service/mongodb
    - target: /etc/sv/mongodb

mongodb_service:
  cmd.run:
    - name: |
        until sv start mongodb;
        do
          sleep 1
        done
