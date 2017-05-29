#!/bin/bash
/usr/local/bin/restic init
/usr/local/bin/restic backup --hostname minio /usr/local/var/minio/
