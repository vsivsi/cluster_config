#!/bin/sh
/usr/local/bin/restic init
/usr/local/bin/influxd backup -database data data
/usr/local/bin/restic backup --hostname influx ./data
/usr/local/bin/influxd backup -database viz viz
/usr/local/bin/restic backup --hostname influx ./viz
