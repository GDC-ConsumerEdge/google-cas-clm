# Workload Identity Federation (WIF) Setup

This Terraform module grants the necessary IAM roles to the Kubernetes Service Account running the `google-cas-issuer` pod on your GDC Connected cluster, allowing it to request certificates from CAS.

## Files
- `main.tf`: Creates a `google_privateca_ca_pool_iam_member` binding. It dynamically constructs the WIF principal URI referencing your GDC cluster's Workload Identity Pool and grants `roles/privateca.certificateRequester` on the CA Pool.
- `variables.tf`: Defines inputs for the CAS project, GDC cluster project, and the specific Kubernetes namespace and service account name.
