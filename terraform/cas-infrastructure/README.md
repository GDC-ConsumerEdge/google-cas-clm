# CAS Infrastructure

This Terraform module provisions the core Google Cloud Certificate Authority Service (CAS) resources.

## Files
- `main.tf`: Creates an Enterprise tier `google_privateca_ca_pool` and a Subordinate `google_privateca_certificate_authority`. It configures the X.509 constraints, max lifetimes, and key specifications.
- `variables.tf`: Defines inputs such as project, location, pool name, CA details, and retention policies.
