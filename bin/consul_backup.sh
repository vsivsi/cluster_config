#!/bin/bash
FN=backup.snap
/usr/local/bin/restic6 init -o s3.layout=default
/usr/local/bin/consul snapshot save /tmp/$FN
cat /tmp/$FN | /usr/local/bin/restic6 backup --stdin --stdin-filename $FN --hostname consul
rm /tmp/$FN
