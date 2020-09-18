#!/bin/bash

# Rijo Thomas (rt1d6m7)
# script for installing prometheus and node_exporter in ubuntu
# grafana dashboard - https://grafana.com/grafana/dashboards/1860

echo -e "\n>_ CREATING USER & DIRECTORIES\n"

sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter

sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

echo -e "\n>_ DOWNLOADING & INSTALLING PROMETHEUS\n"

cd /tmp
curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest \
| grep "browser_download_url.*prometheus.*linux-amd64\.tar\.gz" \
| cut -d ":" -f 2,3 \
| tr -d \" \
| wget -qi -

tarprom="$(find . -name "prometheus*")"
tar -xzf $tarprom

sudo cp *prometheus*linux-amd64/prometheus /usr/local/bin/
sudo cp *prometheus*linux-amd64/promtool /usr/local/bin/

sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo cp -r *prometheus*linux-amd64/consoles /etc/prometheus
sudo cp -r *prometheus*linux-amd64/console_libraries /etc/prometheus

sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

rm -rf *prometheus*linux-amd64*

echo -e "\n>_ DOWNLOADING & INSTALLING NODE_EXPORTER\n"

curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest \
| grep "browser_download_url.*node_exporter.*linux-amd64\.tar\.gz" \
| cut -d ":" -f 2,3 \
| tr -d \" \
| wget -qi -

tarnode="$(find . -name "node_exporter*")"
tar -xzf $tarnode

sudo cp *node_exporter*linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

rm -rf *node_exporter*linux-amd64*

echo -e "\n>_ CONFIGURING PROMETHEUS\n"

cat << EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']  
EOF

sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

echo -e "\n>_ CREATING PROMETHEUS SERVICE\n"

cat << EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --storage.tsdb.retention.time=1y \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n>_ CREATING NODE EXPORTER_SERVICE\n"

cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n>_ STARTING SERVICES"

sudo systemctl daemon-reload
sudo systemctl start prometheus node_exporter
sudo systemctl enable prometheus node_exporter
