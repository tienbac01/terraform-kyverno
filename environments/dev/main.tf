terraform {
  required_version = ">= 1.5"

  backend "kubernetes" {
    namespace     = "kube-system"
    secret_suffix = "tf-kyverno-dev"
    config_path   = "~/.kube/config"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.1"
    }
  }
}

variable "kubeconfig_path" {
  type        = string
  default     = "~/.kube/config"
  description = "Path to kubeconfig"
}

variable "kubernetes_context" {
  type        = string
  default     = null
  description = "Kubeconfig context"
}

variable "replica_count" {
  type        = number
  default     = 1
  description = "Kyverno replica count"
}

variable "chart_version" {
  type        = string
  default     = "3.7.1"
  description = "Kyverno chart version"
}

variable "enable_example_policy" {
  type        = bool
  default     = false
  description = "Deploy sample policy"
}

provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kubernetes_context
}

provider "helm" {
  kubernetes = {
    config_path    = var.kubeconfig_path
    config_context = var.kubernetes_context
  }
}

module "kyverno" {
  source = "../../modules/kyverno"

  namespace             = "kyverno"
  chart_version         = var.chart_version
  replica_count         = var.replica_count
  enable_metrics        = true
  enable_example_policy = var.enable_example_policy
}
