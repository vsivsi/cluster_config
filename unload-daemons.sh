## This will unload consul and nomad

./kill-daemons.sh

sleep 5

sudo launchctl bootout system/homebrew.mxcl.nomad
sudo launchctl bootout system/homebrew.mxcl.consul

## This will setup consul to reconnect on startup
# Disables this for now because it didn't work anyway...
# cp config/peers.json /usr/local/var/consul/raft
