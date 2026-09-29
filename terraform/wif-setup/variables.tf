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
  default     = "platform-clm"
}

variable "kubernetes_service_account" {
  type        = string
  default     = "cert-manager-google-cas-issuer"
}
