
echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew analytics off
brew install consul
brew install nomad
brew install gawk
brew install jq
brew install n
n lts
brew install minio/stable/minio
brew install minio/stable/mc
brew install influxdb
brew install grafana
brew install telegraf
brew install terraform
brew install vault
brew install caddy
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

# This is a custom build of restic
cp bin/restic /usr/local/bin

# This is a custom build of influxdb-relay
cp bin/influxdb-relay /usr/local/bin

# Install packages from github masters:

git clone https://github.com/ctberthiaume/time-series-cop
cd time-series-cop
npm install -g
