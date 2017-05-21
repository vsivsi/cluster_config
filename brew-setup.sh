if which brew
then
  brew update
else
  echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew analytics off
fi

# Linux: https://releases.hashicorp.com/consul/0.8.3/consul_0.8.3_linux_amd64.zip
brew install consul

# Linux: https://releases.hashicorp.com/nomad/0.5.6/nomad_0.5.6_linux_amd64.zip
brew install nomad

# Linux:  Pre-installed
brew install gawk
brew install wget

# Linux: apt-get jq  
brew install jq

# For linux: curl -L https://git.io/n-install | bash
brew install n

n lts

# Linux: https://dl.minio.io/server/minio/release/linux-amd64/minio
brew install minio/stable/minio

# Linux: https://dl.minio.io/client/mc/release/linux-amd64/mc
brew install minio/stable/mc

# Linux: 
# wget https://dl.influxdata.com/influxdb/releases/influxdb_1.2.4_amd64.deb
# sudo dpkg -i influxdb_1.2.4_amd64.deb
brew install influxdb

# Linux: 
# wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.2.0_amd64.deb
# sudo dpkg -i grafana_4.2.0_amd64.deb
brew install grafana

# Linux: 
# wget https://dl.influxdata.com/telegraf/releases/telegraf_1.3.0-1_amd64.deb
# sudo dpkg -i telegraf_1.3.0-1_amd64.deb
brew install telegraf

# Linux: https://releases.hashicorp.com/terraform/0.9.5/terraform_0.9.5_linux_amd64.zip
brew install terraform

# Linux: https://releases.hashicorp.com/vault/0.7.2/vault_0.7.2_linux_amd64.zip
brew install vault

# Linux: https://caddyserver.com/download/linux/amd64
# Or: curl https://getcaddy.com | bash
brew install caddy

# Linux: ???
brew install consul-backinator

# Linux
curl -L -O https://github.com/jippi/hashi-ui/releases/download/v0.13.5/hashi-ui-darwin-amd64
cp hashi-ui-darwin-amd64 /usr/local/bin/hashi-ui
chmod 755 /usr/local/bin/hashi-ui

# I have no idea how to install R on Linux, but not necessary?
brew tap homebrew/science
brew install R

# Linux binary is: https://releases.hashicorp.com/envconsul/0.6.2/envconsul_0.6.2_linux_amd64.tgz
curl -L -O 'https://releases.hashicorp.com/envconsul/0.6.2/envconsul_0.6.2_darwin_amd64.tgz' 
tar xvf envconsul_0.6.2_darwin_amd64.tgz
cp envconsul /usr/local/bin
chmod 755 /usr/local/bin/envconsul

# Linux binary is: https://github.com/adnanh/webhook/releases/download/2.6.3/webhook-linux-amd64.tar.gz
curl -L -O 'https://github.com/adnanh/webhook/releases/download/2.6.3/webhook-darwin-amd64.tar.gz' 
tar xvf webhook-darwin-amd64.tar.gz
cp webhook-darwin-amd64/webhook /usr/local/bin
chmod 755 /usr/local/bin/webhook

# Linux binary is: https://github.com/containous/traefik/releases/download/v1.2.3/traefik_linux-amd64
curl -L -O 'https://github.com/containous/traefik/releases/download/v1.2.3/traefik_darwin-amd64'
cp traefik_darwin-amd64 /usr/local/bin/traefik
chmod 755 /usr/local/bin/traefik

# Linux: a linux build will be in bin/linux
# This is a custom build of restic
cp bin/restic /usr/local/bin

# Not needed for Linux...
# This is a custom build of influxdb-relay
cp bin/influxdb-relay /usr/local/bin

# Install packages from github masters:

# Needed for linux?
git clone https://github.com/ctberthiaume/time-series-cop
cd time-series-cop
npm install -g
