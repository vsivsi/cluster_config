#!/bin/bash
echo "Registering $1" 1>&2

if consul kv get uploadbackups/$1/headerjson
then
   exit
else
   consul kv put uploadbackups/$1/headerjson - 1>&2
   consul kv put uploadbackups/$1/RESTIC_REPOSITORY $(consul kv get uploadbak/RESTIC_REPO_ROOT)$1 1>&2
   consul kv put uploadbackups/$1/RESTIC_PASSWORD $(consul kv get uploadbak/RESTIC_PASSWORD) 1>&2
   consul kv put uploadbackups/$1/script lineprotocol-standard-format 1>&2
   consul kv get uploadbackups/$1/headerjson
   exit
fi
