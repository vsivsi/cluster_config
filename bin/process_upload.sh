#!/bin/bash
echo "Backing up upload for $2, cruise $3 at $1" # >> /usr/local/var/log/uploads.txt

envconsul -prefix=minio/ -prefix=uploadbackups/$2/ restic init
cat $1 | envconsul -prefix=minio/ -prefix=uploadbackups/$2/ restic backup --stdin --stdin-filename $2__$3.tsv --hostname uploader
