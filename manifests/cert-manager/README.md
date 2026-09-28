# Cert-Manager Manifests

This directory contains resources related directly to the core cert-manager deployment and its custom resources.

## Files
- `google-cas-issuer.yaml`: An example `GoogleCASClusterIssuer` custom resource. This instructs cert-manager on how to communicate with your Google Cloud CAS Pool. It references the project, location, and pool ID.
- `rbac.yaml`: Contains Kubernetes `ClusterRole` definitions required for users or service accounts to request certificates (`certificaterequests` and `certificates`) and approve them via the CAS issuer.
