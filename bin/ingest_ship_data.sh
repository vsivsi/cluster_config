#! /bin/bash
# Note that this script may fail if there are multiple copies running at the same time
# Or if a person is logged into the device Web Management UI
# It should recover on future runs once the contention is released

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

echo "Ingesting ship data from: $1 for cruise: $2"

lineprotocol-cnav_33103-GPVTG -c $2 -m cnav_speed_course -i <(cat $1/MGL-cnav.* | gawk 'NR%60==1 { print; getline; print; }') -H influx-head.service.consul -d data

lineprotocol-cnav_33103-GPGGA -c $2 -m cnav_gps_position -i <(cat $1/MGL-cnav.* | gawk 'NR%60==1 { print; getline; print; }') -H influx-head.service.consul -d data

lineprotocol-tsgraw_33721 -c $2 -m temp_sal_ss -i <(cat $1/MGL-tsgraw.* | gawk 'NR%3==1') -H influx-head.service.consul -d data
