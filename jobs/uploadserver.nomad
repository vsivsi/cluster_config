job "uploadserver" {
  datacenters = ["dc1"]
  type = "service"

  constraint {
    attribute = "${node.class}"
    value     = "head"
  }

  group "instance" {
    task "data-upload-server" {

      artifact {
         source = "http://minio.service.consul:9000/assets/data_uploader.zip"
         destination = "."
      }

      driver = "raw_exec"
      config {
        command = "/usr/local/bin/node"
        args = ["app.js", "-p", "${NOMAD_PORT_upload}", "-s", "/usr/local/bin/process_upload.sh"]
      }

      resources {
        cpu = 50
        memory = 128
        network {
          mbits = 10
          port "upload" {
             static = 8080
          }
        }
      }

      service {
        name = "uploadserver"
        tags = ["monitoring"]
        port = "upload"
        check {
          name     = "Uploadserver tcp check"
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
