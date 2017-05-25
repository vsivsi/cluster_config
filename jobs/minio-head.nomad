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

    task "minio" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/minio"
        args = ["server", "--address", "${NOMAD_ADDR_s3_head}", "--config-dir", ".", "/usr/local/var/minio/"]
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 250
        memory = 1024
        network {
          mbits = 100
          port "s3_head" {
             static = 9000
          }
        }
      }

      service {
        name = "minio-head"
        tags = ["storage"]
        port = "s3_head"
        check {
          name     = "Minio-head tcp check"
          type     = "tcp"
          interval = "15s"
          timeout  = "5s"
        }
      }

      template {

         destination   = "config.json"
         change_mode   = "signal"
         change_signal = "SIGUSR1"
         data          = <<EOF

{
        "version": "18",
        "credential": {
                "accessKey": "{{ key "minio-head/MINIO_ACCESS_KEY" }}",
                "secretKey": "{{ key "minio-head/MINIO_SECRET_KEY" }}"
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
      }

      # Controls the timeout between signalling a task it will be killed
      # and killing the task. If not set a default is used.
      # kill_timeout = "20s"
    }
  }
}
