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

resource "google_monitoring_alert_policy" "clm_uptime_low" {
  project      = var.project_id
  display_name = "Cert Manager Controllers - Uptime is Low (Pod Down)"
  combiner     = "OR"
  severity     = "CRITICAL"

  conditions {
    display_name = "Controller Uptime < 1"
    condition_prometheus_query_language {
      query               = "sum by (cluster_name, container_name) (avg_over_time({\"__name__\"=\"external.googleapis.com/prometheus/up\",\"monitored_resource\"=\"k8s_container\",\"namespace_name\"=~\"platform-clm\",\"container_name\"=~\"cert-manager.*|trust-manager.*\"}[5m])) < 1"
      duration            = "7200s"
      evaluation_interval = "60s"
    }
  }

  documentation {
    content   = "Critical: The pod $${metric.label.container_name} is unreachable."
    mime_type = "text/markdown"
    subject   = "$${metric.label.container_name} Down"
  }
}

resource "google_monitoring_alert_policy" "cert_manager_pod_restarts" {
  project      = var.project_id
  display_name = "Cert Manager Controllers - High Pod Restarts"
  combiner     = "OR"
  severity     = "WARNING"

  conditions {
    display_name = "Pod Restarts > 10 in 1h"
    condition_prometheus_query_language {
      query               = "sum by (cluster_name, pod_name, container_name) (increase({\"__name__\"=\"kubernetes.io/anthos/container/restart_count\",\"namespace_name\"=~\"platform-clm\",\"pod_name\"=~\"cert-manager.*|trust-manager.*\"}[1h])) > 10"
      duration            = "300s"
      evaluation_interval = "60s"
    }
  }

  documentation {
    content   = "Warning: Container $${resource.label.container_name} in pod $${resource.label.pod_name} has high restart count."
    mime_type = "text/markdown"
  }
}

resource "google_monitoring_alert_policy" "cas_issuer_errors" {
  project      = var.project_id
  display_name = "Google CAS Issuer - Errors"
  combiner     = "OR"
  severity     = "CRITICAL"

  conditions {
    display_name = "CAS Issuer Workqueue Errors > 0"
    condition_prometheus_query_language {
      query               = "sum by (cluster_name, container_name) (increase({\"__name__\"=\"external.googleapis.com/prometheus/workqueue_adds_total\",\"namespace_name\"=\"platform-clm\",\"container_name\"=\"google-cas-issuer\"}[5m])) > 0"
      duration            = "300s"
      evaluation_interval = "60s"
    }
  }

  documentation {
    content   = "Critical: Google CAS Issuer is failing to issue certificates. Check pod logs."
    mime_type = "text/markdown"
    subject   = "Google CAS Issuer Failure"
  }
}
