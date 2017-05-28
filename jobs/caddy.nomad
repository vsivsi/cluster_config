job "caddy" {

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

    task "caddy" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/caddy"
        args = ["-conf", "Caddyfile", "-host", "0.0.0.0"]
      }

      env {
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          mbits = 100
          port "webalt" {
             static = 2015 
          }
        }
      }

      service {
        name = "caddy"
        tags = ["proxy"]
        port = "webalt"
        check {
          name     = "Caddy tcp check"
          type     = "tcp"
          interval = "15s"
          timeout  = "5s"
        }
      }

      # The "template" stanza instructs Nomad to manage a template, such as
      # a configuration file or script. This template can optionally pull data
      # from Consul or Vault to populate runtime configuration data.
      #
      # For more information and examples on the "template" stanza, please see
      # the online documentation at:
      #
      #     https://www.nomadproject.io/docs/job-specification/template.html
       
      template {
         data          = <<EOF

:{{ env "NOMAD_PORT_webalt" }}

proxy {{ key "server/MINIO_HEAD_PREFIX" }} minio-head.service.consul:9000  {
    header_upstream X-Forwarded-Proto {scheme}
    header_upstream X-Forwarded-Host {host}
    header_upstream Host {host}
}

# proxy {{ key "server/MINIO_PREFIX" }} minio.service.consul:9000  {
#    header_upstream X-Forwarded-Proto {scheme}
#    header_upstream X-Forwarded-Host {host}
#    header_upstream Host {host}
# }

EOF

         destination   = "Caddyfile"
         change_mode   = "signal"
         change_signal = "SIGUSR1"
      }

      # Controls the timeout between signalling a task it will be killed
      # and killing the task. If not set a default is used.
      # kill_timeout = "20s"
    }
  }
}


