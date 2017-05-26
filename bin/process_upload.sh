#!/bin/bash
echo "Got upload for $2 on $1" >> /usr/local/var/log/uploads.txt
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /usr/bin/env > /usr/local/var/log/upload_env.txt
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /bin/echo "Root:" ${RESTIC_REPO_ROOT} > /usr/local/var/log/upload_restic.txt
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /bin/echo "Name:" ${2} >> /usr/local/var/log/upload_restic.txt
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /bin/echo "RootName:" ${RESTIC_REPO_ROOT}${2} >> /usr/local/var/log/upload_restic.txt
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /usr/local/bin/restic init -r ${RESTIC_REPO_ROOT}${2}
cat $1 | /usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /usr/local/bin/restic backup -r ${RESTIC_REPO_ROOT}${2} --stdin --stdin-filename $2.tsv --hostname uploader
