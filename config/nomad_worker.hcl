bind_addr = "0.0.0.0" # the default

data_dir  = "/usr/local/var/nomad"

server {
  enabled          = true
  bootstrap_expect = 5
}

client {
  enabled       = true
  network_speed = 1000
  node_class = "worker"
  options {
    "driver.raw_exec.enable" = "1"
  }
}

consul {
  address = "127.0.0.1:8500"
}

