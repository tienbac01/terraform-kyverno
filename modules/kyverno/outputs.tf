output "release_name" {
  description = "Helm release name"
  value       = helm_release.kyverno.name
}

output "namespace" {
  description = "Namespace where Kyverno is installed"
  value       = helm_release.kyverno.namespace
}

output "chart_version" {
  description = "Kyverno chart version"
  value       = helm_release.kyverno.version
}
