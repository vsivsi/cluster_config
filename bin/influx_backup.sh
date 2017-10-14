#!/bin/bash
/usr/local/bin/restic init -o s3.layout=default
/usr/local/bin/influxd backup -host influx-head.service.consul:8088 -database data /tmp/data
/usr/local/bin/restic backup --hostname influx /tmp/data
/usr/local/bin/influxd backup -host influx-head.service.consul:8088 -database viz /tmp/viz
/usr/local/bin/restic backup --hostname influx /tmp/viz

until rsync -vv --checksum --stats --progress -auz --compress-level=9 --partial-dir=.rsync-partial --delete /tmp/viz ubuntu@gradientscruise.com:~/influxbackups/
do
  echo "Retrying rsync..."
  sleep 15
done
TS=$(date +"%Y-%m-%dT%H:%M:%SZ")
ssh ubuntu@gradientscruise.com "touch ~/influxbackups/$TS"

rm -r /tmp/{data,viz}
