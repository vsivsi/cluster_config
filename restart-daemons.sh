## This will (re)start running consul and nomad services

sudo launchctl kickstart -k system/homebrew.mxcl.nomad
sleep 3
sudo launchctl kickstart -k system/homebrew.mxcl.consul
