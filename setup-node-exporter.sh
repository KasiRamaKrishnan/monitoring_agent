#!/bin/bash

set -e

# Define version
NODE_EXPORTER_VERSION="1.8.1"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Define download URL
FILENAME="node_exporter-${NODE_EXPORTER_VERSION}.${OS}-${ARCH}"
URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${FILENAME}.tar.gz"

echo "Downloading Node Exporter from: $URL"

# Download and extract
curl -LO "$URL"
tar -xzf "${FILENAME}.tar.gz"
cd "$FILENAME"

# Move binary to /usr/local/bin
sudo mv node_exporter /usr/local/bin/
cd ..
rm -rf "$FILENAME" "${FILENAME}.tar.gz"

# Create a systemd service (Linux/WSL systemd enabled only)
if pidof systemd >/dev/null; then
  echo "Creating systemd service..."
  sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reexec || true
  sudo systemctl daemon-reload
  sudo systemctl enable node_exporter
  sudo systemctl start node_exporter

  echo "✅ Node Exporter installed and running as a systemd service."
else
  # For WSL/non-systemd Linux fallback
  echo "Systemd not detected. Running in background..."
  nohup node_exporter > node_exporter.log 2>&1 &
  echo "✅ Node Exporter is running in background on port 9100."
fi

echo "🎯 Visit http://localhost:9100/metrics to confirm it's working."

