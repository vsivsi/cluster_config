#!/bin/bash
/usr/local/bin/restic6 init -o s3.layout=default
/usr/local/bin/influxd backup -host influx-head.service.consul:8088 -database data /tmp/data
/usr/local/bin/restic6 backup --hostname influx /tmp/data
/usr/local/bin/influxd backup -host influx-head.service.consul:8088 -database viz /tmp/viz
/usr/local/bin/restic6 backup --hostname influx /tmp/viz
rm -r /tmp/{data,viz}
