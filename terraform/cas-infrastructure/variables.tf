variable "project_id" {
  type        = string
  description = "The project ID for the CAS resources"
}

variable "location" {
  type        = string
  description = "Location of the CA pool"
}

variable "pool_name" {
  type        = string
  description = "The name of the CA pool"
}

variable "ca_name" {
  type        = string
  description = "The name of the CA"
}

variable "parent_ca_id" {
  type        = string
  description = "Resource ID of the parent CA"
}

variable "max_duration_years" {
  type    = number
  default = 5
}

variable "lifetime_years" {
  type    = number
  default = 4
}

variable "force_delete" {
  type    = bool
  default = false
}

variable "organization" {
  type = string
}

variable "common_name" {
  type = string
}
