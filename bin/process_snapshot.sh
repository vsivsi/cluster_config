#!/bin/bash
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

SNAPID=${1#*/snapshots/}
DATASET=${1%/snapshots/*}

SCRIPT=$(consul kv get $DATASET/script)

CRUISE_ID=$(consul kv get $DATASET/CRUISE_ID)
MEASUREMENT_ID=$(consul kv get $DATASET/MEASUREMENT_ID)

echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $1 >> /usr/local/var/log/hook_processed.log
echo "Restic repo :" $(consul kv get $DATASET/RESTIC_REPOSITORY) >> /usr/local/var/log/hook_processed.log
echo "Snapshot ID: " $SNAPID >> /usr/local/var/log/hook_processed.log
echo "Script to run: $(consul kv get $DATASET/script)" >> /usr/local/var/log/hook_processed.log

echo "DATASET: $DATASET  SNAPID: $SNAPID" >> /usr/local/var/log/hook_processed.log

envconsul -prefix minio/ -prefix $DATASET/ restic restore -t /tmp/$SNAPID $SNAPID >> /usr/local/var/log/hook_processed.log

ls /tmp/$SNAPID >> /usr/local/var/log/hook_processed.log

if [ $CRUISE_ID ] && [ $MEASUREMENT_ID ]
then
   echo "CRUISE_ID: $CRUISE_ID  MEASUREMENT_ID: $MEASUREMENT_ID" >> /usr/local/var/log/hook_processed.log
   $(consul kv get $DATASET/script) -i /tmp/$SNAPID/* -H influx-head.service.consul -d data -c $CRUISE_ID -m $MEASUREMENT_ID
   $(consul kv get $DATASET/script) -i /tmp/$SNAPID/* -o /dev/stdout -c $CRUISE_ID -m $MEASUREMENT_ID >> /usr/local/var/log/hook_processed.log
else
   echo "CRUISE_ID and MEASUREMENT_ID are in datafile" >> /usr/local/var/log/hook_processed.log
   $(consul kv get $DATASET/script) -i /tmp/$SNAPID/*.tsv -H influx-head.service.consul -d data
   $(consul kv get $DATASET/script) -i /tmp/$SNAPID/*.tsv -o /dev/stdout >> /usr/local/var/log/hook_processed.log
fi

rm -r /tmp/$SNAPID
