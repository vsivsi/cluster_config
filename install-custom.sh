# Install packages from github masters:

# Needed for linux?
if ! [ -e time-series-cop ]
then
git clone https://github.com/ctberthiaume/time-series-cop.git
fi
cd time-series-cop
git pull
npm install -g
cd ..

if ! [ -e data-integration-uploader ]
then
git clone https://github.com/ctberthiaume/data-integration-uploader.git
fi
cd data-integration-uploader
git pull
npm install
zip -r ../data_uploader.zip *
cd ..
mc cp data_uploader.zip minio/assets/data_uploader.zip

# Install grafana plugins

if ! [ -e armbrustlab-2dscatter-panel ]
then
git clone https://github.com/ctberthiaume/armbrustlab-2dscatter-panel.git
fi
cd armbrustlab-2dscatter-panel
git pull
rm -rf /usr/local/var/lib/grafana/plugins/armbrustlab-2dscatter-panel
cp -r dist /usr/local/var/lib/grafana/plugins/armbrustlab-2dscatter-panel
cd ..

if ! [ -e armbrustlab-cruisetrack-panel ]
then
git clone https://github.com/ctberthiaume/armbrustlab-cruisetrack-panel.git
fi
cd armbrustlab-cruisetrack-panel
git pull
rm -rf /usr/local/var/lib/grafana/plugins/armbrustlab-cruisetrack-panel
cp -r dist /usr/local/var/lib/grafana/plugins/armbrustlab-cruisetrack-panel
cd ..
