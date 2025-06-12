# monitoring_agent
monitoring_agent

Absolutely! Here's a **`README.md`** file you can include in your repository for your custom Docker-based monitoring agent. This guide covers building, running, and what the image contains.

---

## 🖥️ Monitoring Agent (Prometheus + Grafana + Loki + Promtail)

This project provides a pre-packaged monitoring stack (Prometheus, Grafana, Loki, Promtail) in a Docker container. It's designed to be deployed on any Linux host to monitor that host’s metrics and logs, including:

* **System metrics** via `node_exporter`
* **System logs** via `promtail` + `loki`
* **Visualizations** via `Grafana` with auto-provisioned dashboards

---

### 📦 What’s Included

| Component      | Purpose                                    |
| -------------- | ------------------------------------------ |
| Prometheus     | Scrape and store system metrics            |
| Grafana        | Visualize metrics and logs                 |
| Loki           | Store logs                                 |
| Promtail       | Collect system logs for Loki               |
| node\_exporter | Export Linux host metrics (CPU, RAM, etc.) |

---

### 🛠️ Prerequisites

* Docker installed and running on the target machine

---

### 🚀 Getting Started

#### 1. Clone the repository

```bash
git clone https://github.com/your-repo/monitoring-agent.git
cd monitoring-agent
```

#### 2. Make the script executable

```bash
chmod +x install-monitoring-agent.sh
```

#### 3. Run the setup script

```bash
./install-monitoring-agent.sh
```

This script will:

* Build the Docker image
* Start `node_exporter` on the host
* Detect the host IP and configure Prometheus
* Start the monitoring agent container with all services inside

---

### 🔧 Configuration

You can customize Prometheus scrape jobs by modifying:

```yaml
prometheus.yml
```

Dashboards and data sources are provisioned automatically using Grafana provisioning files stored in:

```plaintext
grafana/provisioning/datasources/
grafana/provisioning/dashboards/
```

---

### 📊 Accessing the UI

* **Grafana**: [http://localhost:3000](http://localhost:3000)
  Default credentials: `admin / admin`
* **Prometheus**: [http://localhost:9090](http://localhost:9090)
* **Loki**: [http://localhost:3100](http://localhost:3100)

> ⚠️ Replace `localhost` with the server IP when accessing from a remote machine.

---

### 📈 Default Dashboards

* **Loki System Logs** (ID: 13639)
* **Node Exporter Full** (ID: 1860)

These are auto-imported in Grafana if provisioning is correctly configured.

---

### 🧹 Cleanup

To stop and remove the containers:

```bash
docker rm -f monitor_agent node_exporter
```

---

### 📁 Project Structure

```
.
├── Dockerfile
├── install-monitoring-agent.sh
├── prometheus.yml
├── loki-config.yaml
├── grafana/
│   └── provisioning/
│       ├── datasources/
│       └── dashboards/
└── supervisord.conf
```

---

### 🧠 Notes

* IP addresses are dynamically detected using `hostname -I` in the install script
* Logs are stored in `/var/log/supervisor` inside the container
* Make sure your host’s firewall allows ports `3000`, `9090`, `3100`, and `9100`

---

### 📬 Contributions

Feel free to open issues or submit pull requests to improve this monitoring stack.

---

