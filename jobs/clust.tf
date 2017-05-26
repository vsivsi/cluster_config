terraform {
  backend "consul" {
    address = "mm0:8500"
    path    = "terraform"
  }
}

variable "MINIO_ACCESS_KEY" {}
variable "MINIO_SECRET_KEY" {}
variable "MINIO_HEAD_ACCESS_KEY" {}
variable "MINIO_HEAD_SECRET_KEY" {}
variable "RESTIC_PASSWORD" {}
variable "GRAFANA_ADMIN_PASSWORD" {}

provider "consul" {
  address    = "mm0:8500"
  datacenter = "dc1"
}

resource "consul_key_prefix" "server_setup" {

   path_prefix = "server/"
   subkeys     = {
      DNS_NAME = "dev.local"
      MINIO_PREFIX = "/minio2"
      MINIO_HEAD_PREFIX = "/minio"
   }
}

resource "consul_key_prefix" "minio_config" {
  path_prefix = "minio/"

  subkeys = {
    MINIO_ACCESS_KEY = "${var.MINIO_ACCESS_KEY}"
    MINIO_SECRET_KEY = "${var.MINIO_SECRET_KEY}"
    AWS_ACCESS_KEY_ID     = "${var.MINIO_ACCESS_KEY}"
    AWS_SECRET_ACCESS_KEY = "${var.MINIO_SECRET_KEY}"
  }
}

resource "consul_key_prefix" "minio_head_config" {
  path_prefix = "minio-head/"

  subkeys = {

    MINIO_ACCESS_KEY = "${var.MINIO_HEAD_ACCESS_KEY}"
    MINIO_SECRET_KEY = "${var.MINIO_HEAD_SECRET_KEY}"
  }
}

resource "consul_key_prefix" "consul_backup_config" {
  path_prefix = "consulbak/"

  subkeys = {
    RESTIC_REPOSITORY     = "s3:http://minio.service.consul:9000/dbbackups/consul"
    RESTIC_PASSWORD       = "${var.RESTIC_PASSWORD}"
  }
}

resource "consul_key_prefix" "influx_backup_config" {
  path_prefix = "influxbak/"

  subkeys = {
    RESTIC_REPOSITORY     = "s3:http://minio.service.consul:9000/dbbackups/influx"
    RESTIC_PASSWORD       = "${var.RESTIC_PASSWORD}"
  }
}

resource "consul_key_prefix" "grafana_backup_config" {
  path_prefix = "grafanabak/"

  subkeys = {
    RESTIC_REPOSITORY     = "s3:http://minio.service.consul:9000/dbbackups/grafana"
    RESTIC_PASSWORD       = "${var.RESTIC_PASSWORD}"
  }
}

resource "consul_key_prefix" "grafana_config" {
  path_prefix = "grafana/"

  subkeys = {
    ADMIN_PASSWORD = "${var.GRAFANA_ADMIN_PASSWORD}"
  }
}

resource "consul_key_prefix" "uploads_backup_config" {
  path_prefix = "uploadbak/"

  subkeys = {
    RESTIC_REPO_ROOT  = "s3:http://minio.service.consul:9000/uploadbackups/"
    RESTIC_PASSWORD   = "${var.RESTIC_PASSWORD}"
  }
}

provider "nomad" {
  address = "http://mm0:4646"
}

resource "nomad_job" "hashi-ui" {
   jobspec = "${file("hashi-ui.nomad")}"
}

resource "nomad_job" "minio-head" {
  jobspec = "${file("minio-head.nomad")}"
}

resource "nomad_job" "minio" {
  jobspec = "${file("minio.nomad")}"
}

resource "nomad_job" "consul_backup" {
  jobspec = "${file("consul_backup.nomad")}"
}

resource "nomad_job" "influx_backup" {
  jobspec = "${file("influx_backup.nomad")}"
}

resource "nomad_job" "grafana_backup" {
  jobspec = "${file("grafana_backup.nomad")}"
}

resource "nomad_job" "influxdb-head" {
   jobspec = "${file("influxdb-head.nomad")}"
}

resource "nomad_job" "grafana" {
   jobspec = "${file("grafana.nomad")}"
}

resource "nomad_job" "tileserver" {
   jobspec = "${file("tileserver.nomad")}"
}

resource "nomad_job" "uploadserver" {
   jobspec = "${file("uploadserver.nomad")}"
}

## Parameterized jobs don't register correctly
# resource "nomad_job" "import_snapshot" {
#   jobspec = "${file("import_snapshot.nomad")}"
# }

# resource "nomad_job" "caddy" {
#    jobspec = "${file("caddy.nomad")}"
# }

provider "influxdb" {
  url      = "http://mm0:8086/"
}

resource "influxdb_database" "data" {
  name = "data"
}

resource "influxdb_database" "viz" {
  name = "viz"
}
