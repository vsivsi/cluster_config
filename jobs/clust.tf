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
    RESTIC_REPOSITORY     = "s3:http://minio.service.consul:9000/consulbak"
    RESTIC_PASSWORD       = "${var.RESTIC_PASSWORD}"
    AWS_ACCESS_KEY_ID     = "${var.MINIO_ACCESS_KEY}"
    AWS_SECRET_ACCESS_KEY = "${var.MINIO_SECRET_KEY}"
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

resource "nomad_job" "minio" {
  jobspec = "${file("consul_backup.nomad")}"
}

# resource "nomad_job" "caddy" {
#    jobspec = "${file("caddy.nomad")}"
# }
