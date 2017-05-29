job "poll_ship" {

  datacenters = ["dc1"]

  type = "batch"

  periodic {
    cron             = "*/3 * * * * *"
    prohibit_overlap = true
  }

  group "instance" {

    restart {
      attempts = 1
      interval = "168h"
      mode     = "fail"
    }

    task "fetch" {
      driver = "raw_exec"
      config {
        command = "/usr/local/bin/envconsul"
        args = ["-prefix=minio/","-prefix=instbackups/shipdata_MGL1704/","-once","/usr/local/bin/fetch_ship_data.sh"]
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
