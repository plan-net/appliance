#!/bin/bash

function alive {
    until echo "quit();" | /srv/mongodb/bin/mongo --host 127.0.0.1 --port 27017;
    do
      sleep 1
    done
}

function kill_mongo {
    while ps -C mongod > /dev/null; do killall /srv/mongodb/bin/mongod; done
}

if [ -d /etc/sv/mongodb ]; then
    sv down mongodb
fi

echo "kill existing mongodb service (step 1)"
kill_mongo

echo "start service (step 1)"
/usr/bin/chpst -u mongo /srv/mongodb/bin/mongod --fork -f /srv/mongodb/local.conf
alive

cat > repl.js <<- .
conn = new Mongo('mongodb://localhost:27017');
db = conn.getDB("admin");
rs.initiate();
.

echo "enable replication"
/srv/mongodb/bin/mongo --host 127.0.0.1 --port 27017 < repl.js
rm repl.js

echo "waiting for replica set"
until echo "rs.status()" | /srv/mongodb/bin/mongo --host 127.0.0.1 --port 27017 | grep '"ok" : 1';
    do
      sleep 1
    done

echo "kill existing mongodb service (step 2)"
kill_mongo

echo "start service (step 2)"
/usr/bin/chpst -u mongo /srv/mongodb/bin/mongod --fork -f /srv/mongodb/local.conf
until echo "rs.status()" | /srv/mongodb/bin/mongo --host 127.0.0.1 --port 27017 | grep '"ok" : 1';
    do
      sleep 1
    done

sleep 10

cat > protect.js <<- .
use admin
rs.status()
db.createUser(
    {
        user: "core",
        pwd: "654321",
        roles: [ { role: "root", db: "admin" } ]
    }
);
.

echo "enable protection"
/srv/mongodb/bin/mongo --host 127.0.0.1 --port 27017 admin < protect.js
rm protect.js

kill_mongo
touch /srv/mongodb/data/.core4_installed
