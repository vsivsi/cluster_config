#!/bin/bash
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

SNAPID=${1#*/snapshots/}
DATASET=${1%/snapshots/*}

echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $1 >> /usr/local/var/log/hook_processed.log
echo "Restic repo :" $(consul kv get ${1%/snapshots/*}/RESTIC_REPOSITORY) >> /usr/local/var/log/hook_processed.log
echo "Snapshot ID: " ${1#*/snapshots/} >> /usr/local/var/log/hook_processed.log
echo "Script to run: $(consul kv get ${1%/snapshots/*}/script)" >> /usr/local/var/log/hook_processed.log

echo "DATASET: $DATASET  SNAPID: $SNAPID" >> /usr/local/var/log/hook_processed.log

envconsul -prefix minio/ -prefix ${1%/snapshots/*}/ restic restore -t /tmp/${1#*/snapshots/} ${1#*/snapshots/} >> /usr/local/var/log/hook_processed.log

ls /tmp/${1#*/snapshots/} >> /usr/local/var/log/hook_processed.log

$(consul kv get ${1%/snapshots/*}/script) -i /tmp/${1#*/snapshots/}/*.tsv -H influx-head.service.consul -d data

$(consul kv get ${1%/snapshots/*}/script) -i /tmp/${1#*/snapshots/}/*.tsv -o /dev/stdout >> /usr/local/var/log/hook_processed.log

rm -r /tmp/${1#*/snapshots/}
