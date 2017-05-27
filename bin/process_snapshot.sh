#!/bin/bash
echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $1 >> /usr/local/var/log/hook_processed.log
echo "Restic repo :" $(/usr/local/bin/consul kv get ${1%/snapshots/*}/RESTIC_REPOSITORY)
echo "Snapshot ID: " ${1#*/snapshots/}
echo "Script to run: /usr/local/bin/$(/usr/local/bin/consul kv get ${1%/snapshots/*}/script)"
