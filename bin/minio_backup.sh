#!/bin/bash
/usr/local/bin/restic init -o s3.layout=default
/usr/local/bin/restic backup --hostname minio /usr/local/var/minio/
