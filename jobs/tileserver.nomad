job "tileserver" {
  datacenters = ["dc1"]
  type = "service"

  constraint {
    attribute = "${node.class}"
    value     = "head"
  }

  group "instance" {
    task "mbtileserver" {

      artifact {
         source = "http://minio.service.consul:9000/assets/templates.zip"
         destination = "."
      }

      artifact {
         source = "http://minio.service.consul:9000/assets/ocean.mbtiles"
         destination = "tiles/"
      }

      driver = "raw_exec"
      config {
        command = "/usr/local/bin/mbtileserver"
        args = ["-d", "tiles/"]
      }

      resources {
        cpu = 100
        memory = 512
        network {
          mbits = 100
          port "tiles" {
             static = 8000
          }
        }
      }

      service {
        name = "tileserver"
        tags = ["monitoring"]
        port = "tiles"
        check {
          name     = "Tileserver tcp check"
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
