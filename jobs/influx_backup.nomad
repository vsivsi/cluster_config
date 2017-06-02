job "influx_backup" {

  datacenters = ["dc1"]

  type = "batch"

  periodic {
    cron             = "@hourly"
    prohibit_overlap = true
  }

  constraint {
    attribute = "${node.class}"
    value     = "head"
  }

  group "instance" {

    restart {
      attempts = 1
      interval = "168h"
      mode     = "fail"
    }

    task "backup" {
      driver = "raw_exec"
      user = "admin"
      config {
        command = "/usr/local/bin/envconsul"
        args = ["-prefix=minio/","-prefix=dbbackups/influx/","-once","/usr/local/bin/influx_backup.sh"]
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
