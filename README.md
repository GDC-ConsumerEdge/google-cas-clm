# Google CAS CLM generic repository

This repository contains generic assets required for integrating GDC Connected clusters with Google Certificate Authority Service (CAS) via cert-manager.

## Directory Structure
- \`terraform/cas-infrastructure/\`: Sets up CAS pools and CAs.
- \`terraform/wif-setup/\`: Configures Workload Identity Federation (WIF) IAM bindings for access.
- \`observability/alerts/\`: Sets up monitoring alerts for cert-manager.
- \`observability/dashboards/\`: Generic cert-manager JSON dashboard.
- \`manifests/cert-manager/\`: Sample Google CAS Issuer manifests.
