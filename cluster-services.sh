mkdir -p /usr/local/var/consul
mkdir -p /usr/local/etc/consul.d

mkdir -p /usr/local/var/nomad
mkdir -p /usr/local/etc/nomad.d

mkdir -p /usr/local/etc/jobs

case $HOSTNAME in
(mm0)
  NODETYPE="head";;
(mm?)
  NODETYPE="worker";;
(*)
  NODETYPE="dev";;
esac

echo "Setting up $NODETYPE node"

cp config/consul_$NODETYPE.json /usr/local/etc/consul.d
cp config/nomad_$NODETYPE.hcl /usr/local/etc/nomad.d
cp jobs/* /usr/local/etc/jobs/

sudo cp config/consul.plist /Library/LaunchDaemons/com.hashicorp.consul.plist
sudo launchctl unload /Library/LaunchDaemons/com.hashicorp.consul.plist
sudo launchctl load /Library/LaunchDaemons/com.hashicorp.consul.plist
sudo cp config/nomad.plist /Library/LaunchDaemons/com.hashicorp.nomad.plist
sudo launchctl unload /Library/LaunchDaemons/com.hashicorp.nomad.plist
sudo launchctl load /Library/LaunchDaemons/com.hashicorp.nomad.plist
sudo mkdir -p /etc/resolver
sudo cp config/consul.resolver /etc/resolver/consul

