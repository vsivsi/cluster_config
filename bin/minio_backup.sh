#!/bin/bash
/usr/local/bin/restic6 init -o s3.layout=default
/usr/local/bin/restic6 backup --hostname minio /usr/local/var/minio/
