#!/bin/sh
FN=grafana.bak
/usr/local/bin/restic init
echo ".backup $FN" /usr/bin/sqlite3 /usr/local/var/lib/grafana/grafana.db
cat $FN | /usr/local/bin/restic backup --stdin --stdin-filename $FN --hostname grafana
