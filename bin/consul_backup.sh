#!/bin/sh
/usr/local/bin/restic init
/usr/local/bin/consul-backinator backup
/usr/local/bin/restic backup ./consul.bak*
