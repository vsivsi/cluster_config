#!/bin/bash
echo "Got upload for $2 on $1" >> /usr/local/var/log/uploads.txt
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /bin/echo ${RESTIC_REPO_ROOT} > /usr/local/var/log/upload_env.txt
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /usr/local/bin/restic init -r ${RESTIC_REPO_ROOT}${2}
cat $1 | /usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /usr/local/bin/restic backup -r ${RESTIC_REPO_ROOT}${2} --stdin --stdin-filename $2.tsv --hostname uploader
