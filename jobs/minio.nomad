job "minio" {

  datacenters = ["dc1"]

  type = "service"

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  group "instance" {

    count = 4

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "minio" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/minio"
        args = ["server", "--address", "${NOMAD_ADDR_s3}", "--config-dir", ".", "http://mm1/usr/local/var/minio/","http://mm2/usr/local/var/minio/","http://mm3/usr/local/var/minio/","http://mm4/usr/local/var/minio/"]
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 1000 # 1000 MHz
        memory = 1024 # 1GB
        network {
          mbits = 500
          port "s3" {
             static = 9000
          }
        }
      }

      service {
        name = "minio"
        tags = ["storage"]
        port = "s3"
        check {
          name     = "Minio tcp check"
          type     = "tcp"
          interval = "15s"
          timeout  = "5s"
        }
      }

      template {
        data          = <<EOF

{
        "version": "18",
        "credential": {
                "accessKey": "{{ key "minio/MINIO_ACCESS_KEY" }}",
                "secretKey": "{{ key "minio/MINIO_SECRET_KEY" }}"
        },
        "region": "us-east-1",
        "browser": "on",
        "logger": {
                "console": {
                        "enable": true
                },
                "file": {
                        "enable": false,
                        "filename": ""
                }
        },

        "notify": {

                "webhook": {
                        "1": {
                                "enable": false,
                                "endpoint": ""
                        }
                }
        }
}

EOF

        destination   = "config.json"
        change_mode   = "signal"
        change_signal = "SIGUSR1"
      }

      # Controls the timeout between signalling a task it will be killed
      # and killing the task. If not set a default is used.
      # kill_timeout = "20s"
    }
  }
}
