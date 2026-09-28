# Google CAS Issuer Installation

This directory provides Kustomize configurations to deploy the `google-cas-issuer` controller, which bridges cert-manager and Google Cloud Certificate Authority Service (CAS).

## Files
- `kustomization.yaml`: The entrypoint for Kustomize. It fetches the upstream installation manifest from Jetstack and applies local patches.
- `wif-patch.yaml`: A deployment patch that modifies the `google-cas-issuer-controller-manager` pod. It mounts a projected Service Account token (KSA) and injects the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to authenticate with GDC Workload Identity Federation directly.
- `wif-configmap.yaml`: A ConfigMap providing the Secure Token Service (STS) payload, pointing the Google Cloud SDK inside the pod to exchange the Kubernetes token for a GCP token.
