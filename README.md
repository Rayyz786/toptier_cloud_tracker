# Event-Driven Serverless E-Commerce Inventory Monitoring Engine

A production-grade, event-driven serverless architecture designed to perform low-latency, automated data scraping across targeted retail API endpoints. This framework optimizes inventory change discovery while programmatically evading advanced edge-network bot mitigations.

## 🏛️ Architectural Overview

The infrastructure leverages a fully decoupled, serverless orchestration layer to execute high-frequency data extraction pipelines with minimal resource consumption:

1. **Orchestration Layer**: Amazon EventBridge schedules automated triggers at strict high-frequency intervals.
2. **Compute Layer**: Containerized Python runtimes execute headlessly inside AWS Lambda to isolate and process target DOM hierarchies without environment persistence.
3. **Anonymization Module**: Outbound browser instances orchestrate programmatic network hops through authenticated residential proxy nodes, bypassing Cloudflare/Akamai anti-scraping blocks.
4. **Ingress Alerting Gateway**: Verified state changes trigger real-time HTTP POST payload handshakes to mobile push notification APIs for immediate edge notification.

## 🛠️ Tech Stack & Capabilities

- **Infrastructure as Code**: Terraform (AWS Lambda, IAM, CloudWatch, EventBridge Event Streams)
- **CI/CD Automation**: GitHub Actions (Declarative workflow execution runner matrix)
- **Browser Virtualization**: Playwright (Headless runtime optimization)
- **Runtime Environment**: Python 3.10 / Pip

## 🚀 Local Initialization

### 1. Configure the Infrastructure Environment
Initialize the local working state and verify configuration definitions:
```bash
terraform init
terraform validate
```

### 2. Run the Headless Scraper Context
Ensure local environment injections are securely bound to your shell runtime profile:
```bash
export APP_NOTIFY_TOKEN="your_token"
export APP_NOTIFY_USER="your_user"
python3 cloud_track.py
```

## 🔒 Security & Least Privilege Design
This platform adheres to absolute strict zero-trust security strategies. No long-lived cloud master keys, application access tokens, or connection credentials are hardcoded into the codebase. All runtime credentials pass dynamically into the execution context using encrypted environment variables via GitHub Actions Secrets and AWS Lambda Environment Blocks.
