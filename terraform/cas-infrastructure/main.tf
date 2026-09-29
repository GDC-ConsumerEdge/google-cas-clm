# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

resource "google_privateca_ca_pool" "pool" {
  project  = var.project_id
  name     = var.pool_name
  location = var.location
  tier     = "ENTERPRISE"

  publishing_options {
    publish_ca_cert = true
    publish_crl     = true
  }

  issuance_policy {
    maximum_lifetime = "${var.max_duration_years * 365 * 24 * 3600}s"
  }
}

resource "google_privateca_certificate_authority" "root_ca" {
  project                  = var.project_id
  pool                     = google_privateca_ca_pool.pool.name
  certificate_authority_id = var.ca_name
  location                 = var.location
  type                     = "SUBORDINATE"
  lifetime                 = "${var.lifetime_years * 365 * 24 * 3600}s"
  desired_state            = "ENABLED"

  deletion_protection                    = !var.force_delete
  skip_grace_period                      = var.force_delete
  ignore_active_certificates_on_deletion = var.force_delete

  subordinate_config {
    certificate_authority = var.parent_ca_id
  }

  config {
    subject_config {
      subject {
        organization = var.organization
        common_name  = var.common_name
      }
    }
    x509_config {
      ca_options {
        is_ca                  = true
        max_issuer_path_length = 0
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign  = true
        }
        extended_key_usage {
          server_auth = true
          client_auth = true
        }
      }
    }
  }

  key_spec {
    algorithm = "RSA_PSS_2048_SHA256"
  }
}
