# Google CAS CLM generic repository

This repository contains generic assets required for integrating GDC Connected clusters with Google Certificate Authority Service (CAS) via cert-manager.

## Directory Structure
- \`terraform/cas-infrastructure/\`: Sets up CAS pools and CAs.
- \`terraform/wif-setup/\`: Configures Workload Identity Federation (WIF) IAM bindings for access.
- \`observability/alerts/\`: Sets up monitoring alerts for cert-manager.
- \`observability/dashboards/\`: Generic cert-manager JSON dashboard.
- \`manifests/cert-manager/\`: Sample Google CAS Issuer manifests.

## Manual CA Distribution (Without External Secrets Operator)

If you are not using External Secrets Operator (ESO) to automatically sync the CA certificate from Google Secret Manager to Kubernetes, you must manually create a Kubernetes Secret containing the CA Root Certificate. `trust-manager` uses this Secret as the source for distributing the trust bundle across your cluster namespaces.

### 1. Extract the Root CA Certificate
First, retrieve the Root CA certificate (PEM format) from your Google CAS pool and save it locally to a file named `ca.crt`:

```bash
gcloud privateca roots describe YOUR_ROOT_CA_NAME \
  --pool YOUR_POOL_NAME \
  --location YOUR_LOCATION \
  --project YOUR_PROJECT_ID \
  --format="value(pemCaCertificates)" > ca.crt
```

### 2. Create the Kubernetes Secret
Create a generic Secret in the `cert-manager` namespace (where `trust-manager` is typically running) using the downloaded file:

```bash
kubectl create secret generic cas-root-ca \
  --namespace cert-manager \
  --from-file=ca.crt=ca.crt
```

### 3. Deploy Trust Manager and the Bundle
Apply the `trust-manager` Kustomize configuration which includes the `Bundle` custom resource. The `Bundle` is configured to read from the `cas-root-ca` secret and distribute it to any namespace labeled with `trust-manager-sync: "true"`.

```bash
kubectl apply -k manifests/trust-manager/
```

To sync the bundle to a target namespace, label the namespace:
```bash
kubectl label namespace YOUR_APP_NAMESPACE trust-manager-sync="true"
```
