job "hashi-ui" {
  datacenters = ["dc1"]
  type = "service"

  constraint {
    attribute = "${node.class}"
    value     = "head"
  }

  group "hashi-ui" {
    task "hashi-ui" {
      driver = "raw_exec"
      config {
        command = "/usr/local/bin/hashi-ui"
        args = ["--nomad-enable", "--consul-enable", "--listen-address=0.0.0.0:${NOMAD_PORT_hashi_ui}"]
      }

      resources {
        cpu = 20
        memory = 10
        network {
          mbits = 10
          port "hashi_ui" {
             static = 3001
          }
        }
      }

      service {
        name = "hashi-ui"
        tags = ["monitoring"]
        port = "hashi_ui"
        check {
          name     = "Hashi-ui tcp check"
          type     = "tcp"
          interval = "15s"
          timeout  = "5s"
        }
      }

      logs {
        max_files = 3
        max_file_size = 10
      }
    }
  }
}
