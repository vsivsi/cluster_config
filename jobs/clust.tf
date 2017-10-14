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
variable "ADMIN_PASSWORD" {}
variable "EXTERNAL_HOSTNAME" {}

provider "consul" {
  address    = "mm0:8500"
  datacenter = "dc1"
}

resource "consul_key_prefix" "valid_cruises" {

   path_prefix = "cruises/"
   subkeys     = {
      "KOK1606"="1"
      "MGL1704"="1"
   }
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

resource "consul_key_prefix" "db_backup_configs" {
  path_prefix = "dbbackups/"

  subkeys = {
    "consul/RESTIC_REPOSITORY"     = "s3:http://minio.service.consul:9000/dbbackups/consul"
    "consul/RESTIC_PASSWORD"       = "${var.RESTIC_PASSWORD}"
    "influx/RESTIC_REPOSITORY"     = "s3:http://minio.service.consul:9000/dbbackups/influx"
    "influx/RESTIC_PASSWORD"       = "${var.RESTIC_PASSWORD}"
    "grafana/RESTIC_REPOSITORY"    = "s3:http://minio.service.consul:9000/dbbackups/grafana"
    "grafana/RESTIC_PASSWORD"      = "${var.RESTIC_PASSWORD}"
    "minio/RESTIC_REPOSITORY"      = "s3:http://minio.service.consul:9000/dbbackups/minio"
    "minio/RESTIC_PASSWORD"        = "${var.RESTIC_PASSWORD}"
  }
}

resource "consul_key_prefix" "inst_backup_configs" {
  path_prefix = "instbackups/"

  subkeys = {

    ### UPS instrument settings
    "ups/RESTIC_REPOSITORY"     = "s3:http://minio.service.consul:9000/instbackups/ups"
    "ups/RESTIC_PASSWORD"       = "${var.RESTIC_PASSWORD}"
    "ups/CPWUSER"               = "admin"
    "ups/CPWPASS"               = "${var.ADMIN_PASSWORD}"
    "ups/UPSIP"                 = "ups"
    "ups/script"                = "lineprotocol-cyberpower-ups-dataLog"
    "ups/CRUISE_ID"             = "MGL1704"
    "ups/MEASUREMENT_ID"        = "ups_status"

    ### Seaflow instrument settings
    "seaflow_MGL1704/RESTIC_REPOSITORY"     = "s3:http://minio.service.consul:9000/instbackups/seaflow_MGL1704"
    "seaflow_MGL1704/RESTIC_PASSWORD"       = "${var.RESTIC_PASSWORD}"
    "seaflow_MGL1704/script"                = "lineprotocol-seaflow"
    "seaflow_MGL1704/CRUISE_ID"             = "MGL1704"
    "seaflow_MGL1704/MEASUREMENT_ID"        = "Seaflow"

    ### Ship data feeds
    "shipdata_MGL1704/RESTIC_REPOSITORY"     = "s3:http://minio.service.consul:9000/instbackups/shipdata_MGL1704"
    "shipdata_MGL1704/RESTIC_PASSWORD"       = "${var.RESTIC_PASSWORD}"
    "shipdata_MGL1704/script"                = "ingest_ship_data.sh"
    "shipdata_MGL1704/CRUISE_ID"             = "MGL1704"

    ### LISST
    "LISST_MGL1704/RESTIC_REPOSITORY"        = "s3:http://minio.service.consul:9000/instbackups/LISST_MGL1704"
    "LISST_MGL1704/RESTIC_PASSWORD"          = "${var.RESTIC_PASSWORD}"
    "LISST_MGL1704/script"                   = "lineprotocol-standard-format"

    ### ECO
    "ECO_MGL1704/RESTIC_REPOSITORY"        = "s3:http://minio.service.consul:9000/instbackups/ECO_MGL1704"
    "ECO_MGL1704/RESTIC_PASSWORD"          = "${var.RESTIC_PASSWORD}"
    "ECO_MGL1704/script"                   = "lineprotocol-standard-format"

    ### PO4
    "PO4_MGL1704/RESTIC_REPOSITORY"          = "s3:http://minio.service.consul:9000/instbackups/PO4_MGL1704"
    "PO4_MGL1704/RESTIC_PASSWORD"            = "${var.RESTIC_PASSWORD}"
    "PO4_MGL1704/script"                     = "lineprotocol-standard-format"

    ### ACS
    "ACS_MGL1704/RESTIC_REPOSITORY"          = "s3:http://minio.service.consul:9000/instbackups/ACS_MGL1704"
    "ACS_MGL1704/RESTIC_PASSWORD"            = "${var.RESTIC_PASSWORD}"
    "ACS_MGL1704/script"                     = "lineprotocol-standard-format"

    ### Temp salinity condtivity
    "TEMPSALSS_KOK1606/RESTIC_REPOSITORY"    = "s3:http://minio.service.consul:9000/instbackups/tempsalss_KOK1606"
    "TEMPSALSS_KOK1606/RESTIC_PASSWORD"      = "${var.RESTIC_PASSWORD}"
    "TEMPSALSS_KOK1606/script"               = "lineprotocol-thsl_wfix"
    "TEMPSALSS_KOK1606/CRUISE_ID"            = "KOK1606"
    "TEMPSALSS_KOK1606/MEASUREMENT_ID"       = "temp_sal_ss"

    ### GPS location
    "GPS_KOK1606/RESTIC_REPOSITORY"    = "s3:http://minio.service.consul:9000/instbackups/gps_KOK1606"
    "GPS_KOK1606/RESTIC_PASSWORD"      = "${var.RESTIC_PASSWORD}"
    "GPS_KOK1606/script"               = "lineprotocol-thsl_wfix-geo"
    "GPS_KOK1606/CRUISE_ID"            = "KOK1606"
    "GPS_KOK1606/MEASUREMENT_ID"       = "cnav_gps_position"

    ### Speed
    "SPEED_KOK1606/RESTIC_REPOSITORY"    = "s3:http://minio.service.consul:9000/instbackups/speed_KOK1606"
    "SPEED_KOK1606/RESTIC_PASSWORD"      = "${var.RESTIC_PASSWORD}"
    "SPEED_KOK1606/script"               = "lineprotocol-thsl_wfix-speed"
    "SPEED_KOK1606/CRUISE_ID"            = "KOK1606"
    "SPEED_KOK1606/MEASUREMENT_ID"       = "cnav_speed_course"

    ### Par
    "PAR_KOK1606/RESTIC_REPOSITORY"    = "s3:http://minio.service.consul:9000/instbackups/par_KOK1606"
    "PAR_KOK1606/RESTIC_PASSWORD"      = "${var.RESTIC_PASSWORD}"
    "PAR_KOK1606/script"               = "lineprotocol-par_KOK1606"
    "PAR_KOK1606/CRUISE_ID"            = "KOK1606"
    "PAR_KOK1606/MEASUREMENT_ID"       = "surface_par"

    ### Seaflow instrument settings
    "seaflow_KOK1606/RESTIC_REPOSITORY"    = "s3:http://minio.service.consul:9000/instbackups/seaflow_KOK1606"
    "seaflow_KOK1606/RESTIC_PASSWORD"      = "${var.RESTIC_PASSWORD}"
    "seaflow_KOK1606/script"               = "lineprotocol-seaflow"
    "seaflow_KOK1606/CRUISE_ID"            = "KOK1606"
    "seaflow_KOK1606/MEASUREMENT_ID"       = "Seaflow"
  }
}

resource "consul_key_prefix" "grafana_config" {
  path_prefix = "grafana/"

  subkeys = {
    ADMIN_PASSWORD = "${var.ADMIN_PASSWORD}"
  }
}

resource "consul_key_prefix" "uploads_backup_config" {
  path_prefix = "uploadbak/"

  subkeys = {
    RESTIC_REPO_ROOT  = "s3:http://minio.service.consul:9000/uploadbackups/"
    RESTIC_PASSWORD   = "${var.RESTIC_PASSWORD}"
  }
}

resource "consul_key_prefix" "caddy_server" {
  path_prefix = "caddy/"
  subkeys = {
    EXTERNAL_HOSTNAME = "${var.EXTERNAL_HOSTNAME}"
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

resource "nomad_job" "minio_backup" {
  jobspec = "${file("minio_backup.nomad")}"
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

resource "nomad_job" "poll_ups" {
   jobspec = "${file("poll_ups.nomad")}"
}

##
## Don't run this job when not on ship
##
# resource "nomad_job" "poll_ship" {
#   jobspec = "${file("poll_ship.nomad")}"
# }

resource "nomad_job" "import_snapshot" {
   jobspec = "${file("import_snapshot.nomad")}"
}

## Migrated to launchd for ports 80 and 443
# resource "nomad_job" "caddy" {
#   jobspec = "${file("caddy.nomad")}"
# }

provider "influxdb" {
  url        = "http://mm0:8086/"
  depends_on = "influxdb-head"
}

resource "influxdb_database" "data" {
  name = "data"
}

resource "influxdb_database" "viz" {
  name = "viz"
}
