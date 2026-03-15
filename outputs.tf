output "kyverno_release_name" {
  description = "Helm release name"
  value       = module.kyverno.release_name
}

output "kyverno_namespace" {
  description = "Namespace where Kyverno is deployed"
  value       = module.kyverno.namespace
}

output "kyverno_chart_version" {
  description = "Kyverno Helm chart version"
  value       = module.kyverno.chart_version
}
