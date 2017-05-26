#!/bin/bash
echo "Got upload for $2 on $1" >> /usr/local/var/log/uploads.txt
cat $1 | /usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /usr/local/bin/restic backup -r $RESTIC_REPO_ROOT$2 --stdin --stdin-filename $2.tsv --hostname uploader
