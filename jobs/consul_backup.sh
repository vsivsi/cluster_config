#!/bin/sh
restic init
consul-backinator backup
restic backup .
