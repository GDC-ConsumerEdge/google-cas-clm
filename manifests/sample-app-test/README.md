# Sample Test Application

This directory contains a sample application to test and verify that your `google-cas-issuer` and `trust-manager` setup is functioning correctly.

## Architecture
- **Nginx Server**: Runs an Nginx web server configured to serve traffic over HTTPS (port 443).
- **Certificate**: A `Certificate` custom resource that requests a TLS certificate from the `generic-google-cas-issuer` for the Nginx server.
- **Curl Client**: A pod running a curl loop. It continually attempts to access the Nginx server using the trust bundle injected by `trust-manager`.

## Prerequisites
1. You must have deployed cert-manager, `google-cas-issuer`, and `trust-manager`.
2. A Google CAS Issuer named `generic-google-cas-issuer` must be available.
3. Your CAS Root CA must be distributed as a ConfigMap named `root-ca-bundle` via `trust-manager`. Note: The sample `client-deployment.yaml` mounts the `root-ca-bundle` ConfigMap (which is standard for `trust-manager` sync targets).

## Deployment

Simply apply the kustomization:
```bash
kubectl apply -k manifests/sample-app-test/
```

## Verification

Check the client logs to confirm successful secure communication:
```bash
kubectl logs -l app=curl-client -n sample-test-app
```
You should see output indicating successful TLS handshakes when using the CA Bundle.
