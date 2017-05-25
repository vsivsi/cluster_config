#!/bin/sh
FN=backup.snap
/usr/local/bin/restic init
/usr/local/bin/consul snapshot save $FN
cat $FN | /usr/local/bin/restic backup --stdin --stdin-filename $FN
