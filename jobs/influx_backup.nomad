job "influx_backup" {

  datacenters = ["dc1"]

  type = "batch"

  periodic {
    cron             = "*/15 * * * * *"
    prohibit_overlap = true
  }

  group "instance" {

    restart {
      attempts = 1
      interval = "168h"
      mode     = "fail"
    }

    task "backup" {
      driver = "raw_exec"
      config {
        command = "/usr/local/bin/envconsul"
        args = ["-prefix=minio/","-prefix=influxbak/","-once","/usr/local/bin/influx_backup.sh"]
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
