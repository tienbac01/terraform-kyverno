variable "namespace" {
  description = "Namespace to deploy Kyverno"
  type        = string
  default     = "kyverno"
}

variable "chart_version" {
  description = "Kyverno Helm chart version"
  type        = string
  default     = "3.7.1"
}

variable "replica_count" {
  description = "Global replica count for Kyverno pods"
  type        = number
  default     = 1
}

variable "resources" {
  description = "Resource requests/limits for core Kyverno deployment"
  type = object({
    requests = optional(map(string))
    limits   = optional(map(string))
  })
  default = {}
}

variable "admission_controller" {
  description = "Admission controller specific settings"
  type = object({
    enabled       = optional(bool, true)
    replica_count = optional(number, null)
    resources = optional(object({
      requests = optional(map(string))
      limits   = optional(map(string))
    }), null)
  })
  default = {}
}

variable "cleanup_controller" {
  description = "Cleanup controller specific settings"
  type = object({
    enabled       = optional(bool, true)
    replica_count = optional(number, null)
    resources = optional(object({
      requests = optional(map(string))
      limits   = optional(map(string))
    }), null)
  })
  default = {}
}

variable "background_controller" {
  description = "Background controller specific settings"
  type = object({
    enabled       = optional(bool, true)
    replica_count = optional(number, null)
    resources = optional(object({
      requests = optional(map(string))
      limits   = optional(map(string))
    }), null)
  })
  default = {}
}

variable "enable_metrics" {
  description = "Expose metrics service and ServiceMonitor"
  type        = bool
  default     = true
}

variable "helm_values_overrides" {
  description = "Additional Helm values overrides"
  type        = map(any)
  default     = {}
}

variable "enable_example_policy" {
  description = "Deploy example Kyverno ClusterPolicy"
  type        = bool
  default     = false
}
