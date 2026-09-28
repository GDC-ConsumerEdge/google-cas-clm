# Trust Manager Installation

This directory provides manifests for deploying `trust-manager`, an addon for cert-manager that distributes trust bundles (like root CA certificates) across namespaces securely.

## Files
- `kustomization.yaml`: The entrypoint for Kustomize. It fetches the upstream `trust-manager` installation manifests and includes our custom Bundle resource.
- `bundle.yaml`: A `Bundle` custom resource definition. It is configured to read your Root CA certificate from a secret (`cas-root-ca`) in the cert-manager namespace and sync it as a ConfigMap to any namespace labeled with `trust-manager-sync: "true"`.
