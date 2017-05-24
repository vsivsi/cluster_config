# This will unload consul and nomad

sudo launchctl unload /Library/LaunchDaemons/com.hashicorp.nomad.plist
sleep 3
sudo launchctl unload /Library/LaunchDaemons/com.hashicorp.consul.plist

# This will setup consul to reconnect on startup

cp config/peers.json /usr/local/var/consul/raft
