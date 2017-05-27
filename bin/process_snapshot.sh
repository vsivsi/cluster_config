#!/bin/bash
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

SNAPID=${1#*/snapshots/}
DATASET=${1%/snapshots/*}

echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $1 >> /usr/local/var/log/hook_processed.log
echo "Restic repo :" $(consul kv get $DATASET/RESTIC_REPOSITORY) >> /usr/local/var/log/hook_processed.log
echo "Snapshot ID: " $SNAPID >> /usr/local/var/log/hook_processed.log
echo "Script to run: $(consul kv get $DATASET/script)" >> /usr/local/var/log/hook_processed.log

echo "DATASET: $DATASET  SNAPID: $SNAPID" >> /usr/local/var/log/hook_processed.log

envconsul -prefix minio/ -prefix $DATASET/ restic restore -t /tmp/$SNAPID $SNAPID >> /usr/local/var/log/hook_processed.log

ls /tmp/$DATASET >> /usr/local/var/log/hook_processed.log

$(consul kv get $DATASET/script) -i /tmp/$SNAPID/*.tsv -H influx-head.service.consul -d data

$(consul kv get $DATASET/script) -i /tmp/$SNAPID/*.tsv -o /dev/stdout >> /usr/local/var/log/hook_processed.log

rm -r /tmp/$SNAPID
