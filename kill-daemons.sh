## This will kill running consul and nomad services

sudo launchctl kill SIGINT system/homebrew.mxcl.nomad
sleep 3
sudo launchctl kill SIGINT system/homebrew.mxcl.consul
