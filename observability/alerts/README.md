# Observability Alerts

This directory contains Terraform code to deploy Google Cloud Monitoring Alert Policies for cert-manager and the google-cas-issuer. 

## Files
- `cert-manager-alerts.tf`: Provisions alerting policies such as monitoring for controller downtime (uptime < 1), high pod restart counts, and Google CAS Issuer workqueue failures. 
- `variables.tf`: Defines required variables for the alerts, such as the target GCP `project_id` where the metrics and alerts are hosted.
