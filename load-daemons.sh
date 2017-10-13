mkdir -p /usr/local/var/consul
mkdir -p /usr/local/etc/consul.d
rm /usr/local/etc/consul.d/*

mkdir -p /usr/local/var/nomad
mkdir -p /usr/local/etc/nomad.d
rm /usr/local/etc/nomad.d/*

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

sudo cp config/consul.plist /Library/LaunchDaemons/com.hashicorp.consul.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/com.hashicorp.consul.plist

sudo cp config/nomad.plist /Library/LaunchDaemons/com.hashicorp.nomad.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/com.hashicorp.nomad.plist

sudo mkdir -p /etc/resolver
sudo cp config/consul.resolver /etc/resolver/consul

if [[ $NODETYPE == "head" ]]
then
  if [[ $TF_VAR_EXTERNAL_HOSTNAME ]]
  then
    sudo launchctl setenv EXTERNAL_HOSTNAME ${TF_VAR_EXTERNAL_HOSTNAME}
    sudo echo setenv EXTERNAL_HOSTNAME ${TF_VAR_EXTERNAL_HOSTNAME} > /etc/launchd.conf
    sudo cp config/caddy.plist /Library/LaunchDaemons/com.mholt.caddy.plist
    sudo launchctl bootstrap system /Library/LaunchDaemons/com.mholt.caddy.plist
  else
    echo "Caddy was not loaded because TF_VAR secrets are missing"
  fi
fi
