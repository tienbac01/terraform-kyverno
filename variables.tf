variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kubernetes_context" {
  description = "Optional kubeconfig context to use"
  type        = string
  default     = null
}

variable "namespace" {
  description = "Namespace to deploy Kyverno into"
  type        = string
  default     = "kyverno"
}

variable "chart_version" {
  description = "Kyverno Helm chart version"
  type        = string
  default     = "3.7.1"
}

variable "replica_count" {
  description = "Default replica count for Kyverno components"
  type        = number
  default     = 1
}

variable "resources" {
  description = "Resource requests/limits for the Kyverno main deployment"
  type = object({
    requests = optional(map(string), { cpu = "100m", memory = "256Mi" })
    limits   = optional(map(string), { cpu = "500m", memory = "512Mi" })
  })
  default = {}
}

variable "admission_controller" {
  description = "Admission controller settings"
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
  description = "Cleanup controller settings"
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
  description = "Background controller settings"
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
  description = "Expose metrics service and ServiceMonitor for Prometheus"
  type        = bool
  default     = true
}

variable "enable_example_policy" {
  description = "Deploy example ClusterPolicy that disallows running as root"
  type        = bool
  default     = true
}

variable "helm_values_overrides" {
  description = "Arbitrary Helm values overrides merged on top of defaults"
  type        = map(any)
  default     = {}
}
