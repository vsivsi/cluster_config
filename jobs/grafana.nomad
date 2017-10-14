job "grafana" {

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

    task "grafana" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/grafana-server"
        args = [
         "--config", "grafana.ini",
         "--homepath", "/usr/local/opt/grafana/share/grafana",
         "cfg:default.paths.logs=/usr/local/var/log/grafana",
         "cfg:default.paths.data=/usr/local/var/lib/grafana",
         "cfg:default.paths.plugins=/usr/local/var/lib/grafana/plugins"
        ]
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 500
        memory = 2048
        network {
          mbits = 100
          port "grafana" {
             static = 3000
          }
        }
      }

      service {
        name = "grafana"
        tags = ["dashboard"]
        port = "grafana"
        check {
          name     = "Grafana tcp check"
          type     = "tcp"
          interval = "15s"
          timeout  = "5s"
        }
      }

      template {
         destination   = "grafana.ini"
         change_mode   = "signal"
         change_signal = "SIGUSR1"
         data          = <<EOF

[server]
# Protocol (http, https, socket)
protocol = http
# This will need to change on the ship
# domain = localhost
domain = {{ key "caddy/EXTERNAL_HOSTNAME" }}
# Note sure if this is needed yet
root_url = %(protocol)s://%(domain)s:/grafana

[security]
admin_password = {{ key "grafana/ADMIN_PASSWORD" }}
disable_gravatar = true

[auth.anonymous]
enabled = false

[users]
auto_assign_org = Gradients
auto_assign_org_role = Editor

[analytics]
reporting_enabled = false
check_for_updates = false

[alerting]
enabled = false

EOF
      }
    }
  }
}
