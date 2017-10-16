# Run this with sudo -E <script>

case $HOSTNAME in
(mm0)
  NODETYPE="head";;
(mm?)
  NODETYPE="worker";;
(*)
  NODETYPE="dev";;
esac

echo "Setting up $NODETYPE node"

#
# Consul setup
#

mkdir -p /usr/local/var/consul
mkdir -p /usr/local/etc/consul.d
rm /usr/local/etc/consul.d/*

cp config/consul_$NODETYPE.json /usr/local/etc/consul.d

sudo cp config/consul.plist /Library/LaunchDaemons/com.hashicorp.consul.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/com.hashicorp.consul.plist

sudo mkdir -p /etc/resolver
sudo cp config/consul.resolver /etc/resolver/consul

#
# Nomad setup
#

mkdir -p /usr/local/var/nomad
mkdir -p /usr/local/etc/nomad.d
rm /usr/local/etc/nomad.d/*

cp config/nomad_$NODETYPE.hcl /usr/local/etc/nomad.d

sudo cp config/nomad.plist /Library/LaunchDaemons/com.hashicorp.nomad.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/com.hashicorp.nomad.plist

#
# Caddy setup (head node only)
#

if [[ $NODETYPE == "head" ]]
then
  # echo "Here it is: " $TF_VAR_EXTERNAL_HOSTNAME
  if [[ $TF_VAR_EXTERNAL_HOSTNAME ]]
  then

    mkdir -p /usr/local/var/caddy/public
    mkdir -p /usr/local/etc/caddy.d
    rm /usr/local/etc/caddy.d/*

    cp config/Caddyfile /usr/local/etc/caddy.d

    sudo launchctl setenv EXTERNAL_HOSTNAME ${TF_VAR_EXTERNAL_HOSTNAME}
    sudo echo setenv EXTERNAL_HOSTNAME ${TF_VAR_EXTERNAL_HOSTNAME} > /etc/launchd.conf
    sudo echo setenv UPLOAD_PASSWORD ${TF_VAR_UPLOAD_PASSWORD} >> /etc/launchd.conf
    sudo cp config/caddy.plist /Library/LaunchDaemons/com.mholt.caddy.plist
    sudo launchctl bootstrap system /Library/LaunchDaemons/com.mholt.caddy.plist
  else
    echo "Caddy was not loaded because TF_VAR secrets are missing"
  fi
fi
