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

    task "webhook" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/webhook"
        args = ["--port", "9001", "--hooks", "hooks.json"]
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 50 # MHz
        memory = 32 # MB
        network {
          mbits = 10
          port "webhook" {
             static = 9001
          }
        }
      }

      service {
        name = "webhook"
        tags = ["storage"]
        port = "webhook"
        check {
          name     = "Webhook tcp check"
          type     = "tcp"
          interval = "15s"
          timeout  = "5s"
        }
      }

      template {
        destination   = "hooks.json"
        change_mode   = "signal"
        change_signal = "SIGUSR1"
        data = <<EOF
        [
          {
            "id": "snapshot",
            "execute-command": "/usr/local/bin/nomad",
            "command-working-directory": ".",
            "pass-arguments-to-command": [
               { "source": "payload", "name": "Key" }
            ],
            "trigger-rule": {
               "match": {
                  "type": "regex",
                  "regex": "/snapshots/",
                  "parameter": {
                     "source": "payload",
                     "name": "Key"
                   }
               }
            }
          }
        ]
EOF
      }
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
        destination   = "config.json"
        change_mode   = "signal"
        change_signal = "SIGUSR1"
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
                                "enable": true,
                                "endpoint": "http://127.0.0.1:9001/hooks/snapshot"
                        }
                }
        }
}
EOF
      }
    }
  }
}
