# Observability Dashboards

This directory contains JSON layouts for Grafana or Google Cloud Monitoring dashboards to visualize the health of cert-manager and CAS components.

## Files
- `cert-manager-dashboard.json`: A comprehensive dashboard layout that includes widgets for container uptime, crash loops, webhook panics, CPU/Memory utilization, and workqueue depths. It is pre-configured with a filter for `cluster_name`.
