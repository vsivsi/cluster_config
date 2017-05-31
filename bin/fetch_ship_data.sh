#! /bin/bash
# Note that this script may fail if there are multiple copies running at the same time
# Or if a person is logged into the device Web Management UI
# It should recover on future runs once the contention is released

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

restic6 init -o s3.layout=default

restic6 backup --hostname $CRUISE_ID /Volumes/MGL1704/raw/serial/MGL-cnav.* /Volumes/MGL1704/raw/serial/MGL-tsgraw.*
