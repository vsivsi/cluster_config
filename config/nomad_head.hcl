bind_addr = "0.0.0.0" # the default

data_dir  = "/usr/local/var/nomad"

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled       = true
  network_speed = 1000
  node_class    = "head"
  no_host_uuid  = true
  gc_interval   = "15m"
  gc_max_allocs = "5000"
  options {
    "driver.raw_exec.enable" = "1"
  }
}

consul {
  address = "127.0.0.1:8500"
  server_auto_join = true
  client_auto_join = true
}
