## This will kill running cluster services

sudo launchctl kill SIGINT system/homebrew.mxcl.caddy

sudo launchctl kill SIGINT system/homebrew.mxcl.nomad
sleep 3
sudo launchctl kill SIGINT system/homebrew.mxcl.consul
