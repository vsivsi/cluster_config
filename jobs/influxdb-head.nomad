job "minio-head" {

  datacenters = ["dc1"]

  type = "service"

  constraint {
    attribute = "${node.class}"
    value     = "head"
  }

  group "instance" {

    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "influxdb" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/influxd"
        args = ["run", "-config", "./influxdb.conf"]
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 1000
        memory = 4096
        network {
          mbits = 100
          port "influx_head" {
             static = 8086
          }
          port "influx_rpc" {
             static = 8088
          }
        }
      }

      service {
        name = "influx-head"
        tags = ["database"]
        port = "influx_head"
        check {
          name     = "Influx-head tcp check"
          type     = "tcp"
          interval = "15s"
          timeout  = "5s"
        }
      }

      template {
         destination   = "influxdb.conf"
         change_mode   = "signal"
         change_signal = "SIGUSR1"
         data          = <<EOF

         reporting-disabled = false
         bind-address = ":8088"

         [meta]
           dir = "/usr/local/var/influxdb/meta"
           retention-autocreate = true
           logging-enabled = true

         [data]
           dir = "/usr/local/var/influxdb/data"
           wal-dir = "/usr/local/var/influxdb/wal"
           query-log-enabled = true
           cache-max-memory-size = 1073741824
           cache-snapshot-memory-size = 26214400
           cache-snapshot-write-cold-duration = "10m0s"
           compact-full-write-cold-duration = "4h0m0s"
           max-series-per-database = 1000000
           max-values-per-tag = 100000
           trace-logging-enabled = false

         [coordinator]
           write-timeout = "10s"
           max-concurrent-queries = 0
           query-timeout = "0s"
           log-queries-after = "0s"
           max-select-point = 0
           max-select-series = 0
           max-select-buckets = 0

         [retention]
           enabled = true
           check-interval = "30m0s"

         [shard-precreation]
           enabled = true
           check-interval = "10m0s"
           advance-period = "30m0s"

         [admin]
           enabled = false
           bind-address = ":8083"
           https-enabled = false
           https-certificate = "/etc/ssl/influxdb.pem"

         [monitor]
           store-enabled = true
           store-database = "_internal"
           store-interval = "10s"

         [subscriber]
           enabled = true
           http-timeout = "30s"
           insecure-skip-verify = false
           ca-certs = ""
           write-concurrency = 40
           write-buffer-size = 1000

         [http]
           enabled = true
           bind-address = ":8086"
           auth-enabled = false
           log-enabled = true
           write-tracing = false
           pprof-enabled = true
           https-enabled = false
           https-certificate = "/etc/ssl/influxdb.pem"
           https-private-key = ""
           max-row-limit = 0
           max-connection-limit = 0
           shared-secret = ""
           realm = "InfluxDB"
           unix-socket-enabled = false
           bind-socket = "/var/run/influxdb.sock"

         [[graphite]]
           enabled = false
           bind-address = ":2003"
           database = "graphite"
           retention-policy = ""
           protocol = "tcp"
           batch-size = 5000
           batch-pending = 10
           batch-timeout = "1s"
           consistency-level = "one"
           separator = "."
           udp-read-buffer = 0

         [[collectd]]
           enabled = false
           bind-address = ":25826"
           database = "collectd"
           retention-policy = ""
           batch-size = 5000
           batch-pending = 10
           batch-timeout = "10s"
           read-buffer = 0
           typesdb = "/usr/share/collectd/types.db"
           security-level = "none"
           auth-file = "/etc/collectd/auth_file"

         [[opentsdb]]
           enabled = false
           bind-address = ":4242"
           database = "opentsdb"
           retention-policy = ""
           consistency-level = "one"
           tls-enabled = false
           certificate = "/etc/ssl/influxdb.pem"
           batch-size = 1000
           batch-pending = 5
           batch-timeout = "1s"
           log-point-errors = true

         [[udp]]
           enabled = false
           bind-address = ":8089"
           database = "udp"
           retention-policy = ""
           batch-size = 5000
           batch-pending = 10
           read-buffer = 0
           batch-timeout = "1s"
           precision = ""

         [continuous_queries]
           log-enabled = true
           enabled = true
           run-interval = "1s"
EOF
      }
    }
  }
}
