job "import_snapshot" {

  datacenters = ["dc1"]

  type = "batch"

  parameterized {
    payload       = "forbidden"
    meta_required = ["SNAPSHOT_PATH"]
    meta_optional = []
  }

  constraint {
    attribute = "${node.class}"
    value     = "worker"
  }

  group "instance" {

    restart {
      attempts = 1
      interval = "168h"
      mode     = "fail"
    }

    task "process_snapshot" {
      driver = "raw_exec"
      config {
        command = "/usr/local/bin/envconsul"
        args = ["-prefix=minio/","-once","/usr/local/bin/process_snapshot.sh","${NOMAD_META_SNAPSHOT_PATH}"]
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
