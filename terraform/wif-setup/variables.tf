variable "cas_project_id" {
  type        = string
  description = "The project ID where CAS is hosted"
}

variable "location" {
  type        = string
  description = "Location of the CA pool"
}

variable "ca_pool_name" {
  type        = string
  description = "The name of the CA pool"
}

variable "cluster_project_id" {
  type        = string
  description = "The project ID of the GDC connected cluster"
}

variable "cluster_project_number" {
  type        = string
  description = "The project number of the GDC connected cluster"
}

variable "kubernetes_namespace" {
  type        = string
  default     = "cert-manager"
}

variable "kubernetes_service_account" {
  type        = string
  default     = "cert-manager-google-cas-issuer"
}
