#!/bin/bash
echo "Got upload for $2 on $1" >> /usr/local/var/log/uploads.txt
export NAME=$2
export FILE=$1
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /bin/bash -c '/bin/echo "RootName:" ${RESTIC_REPO_ROOT}${NAME} > /usr/local/var/log/upload_restic.txt'
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /bin/bash -c '/usr/local/bin/restic init -r ${RESTIC_REPO_ROOT}${NAME}'
/usr/local/bin/envconsul -prefix=minio/ -prefix=uploadbak/ /bin/bash -c 'cat $FILE | /usr/local/bin/restic backup -r ${RESTIC_REPO_ROOT}${NAME} --stdin --stdin-filename $NAME.tsv --hostname uploader'
