#!/bin/bash

set -e  # Exit on any error

# --- Step 0: Build your custom monitoring agent Docker image ---
echo "[*] Building Docker image: monitoring-agent"
docker build -t monitoring-agent-kasi .

# --- Step 1: Run node_exporter on host to expose system metrics ---
echo "[*] Running node_exporter container"
docker run -d --restart=always \
  --name node_exporter_machine \
  -p 9100:9100 \
  quay.io/prometheus/node-exporter

# --- Step 2: Determine host IP for Prometheus target ---
HOST_IP=$(hostname -I | awk '{print $1}')
echo "[*] Host IP detected: $HOST_IP"

# --- Step 3: Generate Prometheus configuration ---
echo "[*] Generating prometheus.yml with node_exporter target"
cat > prometheus.yml <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['${HOST_IP}:9100']
EOF

# --- Step 4: Run custom monitoring agent container ---
echo "[*] Starting monitoring-agent container"
docker run -d --restart=always \
  --name monitor_agent_machine \
  -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml \
  -p 3000:3000 -p 9090:9090 -p 3100:3100 \
  monitoring-agent-kasi

echo "[✔] Monitoring agent is up and running!"
echo "Access Grafana at: http://localhost:3000 (default user: admin / admin)"
