#!/bin/sh
echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $1 >> /usr/local/var/hook.log
nomad job dispatch import_snapshot -meta SNAPSHOT_PATH=$1
