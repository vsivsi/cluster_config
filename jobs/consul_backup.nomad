job "consul_backup" {

  datacenters = ["dc1"]

  type = "batch"

  periodic {
    cron             = "*/1 * * * * *"
    prohibit_overlap = true
  }

  constraint {
    attribute = "${node.class}"
    value     = "head"
  }

  group "instance" {

    task "backup" {
      driver = "raw_exec"
      config {
        command = "/usr/local/bin/envconsul"
        args = ["-prefix=minio/","-prefix=consulbak/","-once","/usr/local/bin/consul_backup.sh"]
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
