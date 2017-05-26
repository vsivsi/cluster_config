#!/bin/bash
echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $1 >> /usr/local/var/hook.log
/usr/local/bin/nomad job dispatch -meta SNAPSHOT_PATH=$1 import_snapshot
