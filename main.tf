module "kyverno" {
  source = "./modules/kyverno"

  namespace              = var.namespace
  chart_version          = var.chart_version
  replica_count          = var.replica_count
  resources              = var.resources
  admission_controller   = var.admission_controller
  cleanup_controller     = var.cleanup_controller
  background_controller  = var.background_controller
  enable_metrics         = var.enable_metrics
  enable_example_policy  = var.enable_example_policy
  helm_values_overrides  = var.helm_values_overrides
}
