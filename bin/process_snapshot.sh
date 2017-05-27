#!/bin/bash
echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $1 >> /usr/local/var/log/hook_processed.log
