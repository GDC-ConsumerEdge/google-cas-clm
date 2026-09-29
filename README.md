# Google CAS CLM generic repository

This repository contains generic assets required for integrating GDC Connected clusters with Google Certificate Authority Service (CAS) via cert-manager.

> **Note:** The `cert-manager` namespace is managed by the Google engineering team on GDC Connected and is restricted from user access. Therefore, all add-on components in this repository (like `google-cas-issuer` and `trust-manager`) default to deploying into the `platform-clm` namespace instead.

## Directory Structure
- \`terraform/cas-infrastructure/\`: Sets up CAS pools and CAs.
- \`terraform/wif-setup/\`: Configures Workload Identity Federation (WIF) IAM bindings for access.
- \`observability/alerts/\`: Sets up monitoring alerts for cert-manager.
- \`observability/dashboards/\`: Generic cert-manager JSON dashboard.
- \`manifests/cert-manager/\`: Sample Google CAS Issuer manifests.

## Replacing Variables in Manifests

Before applying the manifests, replace the placeholder variables with your actual configuration values using the following `sed` commands:

```bash
# Replace variables in the Google CAS Issuer manifest
sed -i 's/YOUR_CAS_PROJECT_ID/<your-project-id>/g' manifests/cert-manager/google-cas-issuer.yaml
sed -i 's/YOUR_CAS_LOCATION/<your-cas-location>/g' manifests/cert-manager/google-cas-issuer.yaml
sed -i 's/YOUR_CAS_POOL_NAME/<your-cas-pool-name>/g' manifests/cert-manager/google-cas-issuer.yaml

# Replace the Workload Identity Federation pool ID.
# For GKE and GDC Connected clusters, this is typically formatted as: <CLUSTER_PROJECT_ID>.svc.id.goog
sed -i 's/YOUR_WIF_POOL_ID/<your-wif-pool-id>/g' manifests/google-cas-issuer/wif-patch.yaml
```

## Rendering Upstream Manifests

The base manifests for `google-cas-issuer` and `trust-manager` included in this repository were rendered from their respective upstream Helm charts. They are currently synced to the latest stable versions.

If you ever need to manually fetch and render newer upstream versions in the future, you can do so by running the following Helm commands:

```bash
# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Render the latest cert-manager-google-cas-issuer manifest
helm template cert-manager-google-cas-issuer jetstack/cert-manager-google-cas-issuer > manifests/google-cas-issuer/google-cas-issuer-vX.Y.Z.yaml

# Render the latest trust-manager manifest
helm template trust-manager jetstack/trust-manager > manifests/trust-manager/trust-manager-vX.Y.Z.yaml
```

*Note: If you update to a new version, be sure to update the `resources:` section in the corresponding `kustomization.yaml` files to point to the new filename.*

## Manual CA Distribution (Without External Secrets Operator)

If you are not using External Secrets Operator (ESO) to automatically sync the CA certificate from Google Secret Manager to Kubernetes, you must manually create a Kubernetes Secret containing the CA Root Certificate. `trust-manager` uses this Secret as the source for distributing the trust bundle across your cluster namespaces.

### 1. Extract the Root CA Certificate
First, retrieve the Root CA certificate (PEM format) from your Google CAS pool and save it locally to a file named `ca.crt`:

```bash
gcloud privateca roots describe YOUR_ROOT_CA_NAME \
  --pool YOUR_POOL_NAME \
  --location YOUR_LOCATION \
  --project YOUR_PROJECT_ID \
  --format="value(pemCaCertificates)" | sed 's/;//g' > ca.crt
```

### 2. Create the Kubernetes Secret
Create a generic Secret in the `platform-clm` namespace (where `trust-manager` is typically running) using the downloaded file:

```bash
kubectl create secret generic cas-root-ca \
  --namespace platform-clm \
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

## Sample Test App

A complete sample application is provided to verify your CAS deployment. It spins up an Nginx server that gets a certificate from your CAS pool, and a curl client that connects to it securely using the root CA bundle distributed by `trust-manager`.

For more details, see the [Sample App README](manifests/sample-app-test/README.md).
