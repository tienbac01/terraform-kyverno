locals {
  base_values = {
    replicaCount = var.replica_count
    resources    = var.resources

    admissionController = {
      enabled      = coalesce(var.admission_controller.enabled, true)
      replicaCount = coalesce(var.admission_controller.replica_count, var.replica_count)
      resources    = var.admission_controller.resources
    }

    cleanupController = {
      enabled      = coalesce(var.cleanup_controller.enabled, true)
      replicaCount = coalesce(var.cleanup_controller.replica_count, var.replica_count)
      resources    = var.cleanup_controller.resources
    }

    backgroundController = {
      enabled      = coalesce(var.background_controller.enabled, true)
      replicaCount = coalesce(var.background_controller.replica_count, var.replica_count)
      resources    = var.background_controller.resources
    }

    metricsService = {
      create = var.enable_metrics
      type   = "ClusterIP"
      port   = 8000
    }

    metricsServiceMonitor = {
      enabled = var.enable_metrics
      # adjust label to match your Prometheus operator release label selector
      additionalLabels = { release = "prometheus" }
    }
  }

  values = merge(local.base_values, var.helm_values_overrides)
}

resource "helm_release" "kyverno" {
  name             = "kyverno"
  repository       = "https://kyverno.github.io/kyverno/"
  chart            = "kyverno"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  atomic          = true
  cleanup_on_fail = true

  values = [yamlencode(local.values)]
}

resource "kubernetes_manifest" "disallow_root" {
  count = var.enable_example_policy ? 1 : 0

  manifest = {
    apiVersion = "kyverno.io/v1"
    kind       = "ClusterPolicy"
    metadata = {
      name      = "disallow-root-containers"
      namespace = var.namespace
    }
    spec = {
      validationFailureAction = "Enforce"
      background              = true
      rules = [
        {
          name = "require-run-as-nonroot"
          match = {
            resources = {
              kinds = ["Pod"]
            }
          }
          validate = {
            message = "Containers must not run as root"
            pattern = {
              spec = {
                securityContext = {
                  runAsNonRoot = true
                }
                containers = [
                  {
                    securityContext = {
                      runAsNonRoot = true
                    }
                  }
                ]
                initContainers = [
                  {
                    securityContext = {
                      runAsNonRoot = true
                    }
                  }
                ]
              }
            }
          }
        }
      ]
    }
  }

  depends_on = [helm_release.kyverno]
}
