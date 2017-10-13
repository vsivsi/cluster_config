## This will (re)start running cluster services

sudo launchctl kickstart -k system/homebrew.mxcl.caddy

sudo launchctl kickstart -k system/homebrew.mxcl.consul
sleep 3
sudo launchctl kickstart -k system/homebrew.mxcl.nomad
