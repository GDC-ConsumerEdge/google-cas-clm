terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

locals {
  # Construct the direct Workload Identity principal string for GDC
  wif_principal = "principal://iam.googleapis.com/projects/${var.cluster_project_number}/locations/global/workloadIdentityPools/${var.cluster_project_id}.svc.id.goog/subject/ns/${var.kubernetes_namespace}/sa/${var.kubernetes_service_account}"
}

resource "google_privateca_ca_pool_iam_member" "cas_pool_requester" {
  project  = var.cas_project_id
  location = var.location
  ca_pool  = "projects/${var.cas_project_id}/locations/${var.location}/caPools/${var.ca_pool_name}"
  
  role     = "roles/privateca.certificateRequester"
  member   = local.wif_principal
}
