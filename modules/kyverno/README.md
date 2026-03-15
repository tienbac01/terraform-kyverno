# Kyverno Terraform Module

Installs Kyverno via the official Helm chart and optionally deploys an example policy.

## Inputs
- `namespace` (string): Namespace for Kyverno. Default `kyverno`.
- `chart_version` (string): Kyverno Helm chart version pin.
- `replica_count` (number): Default replicas for controllers.
- `resources` (object): Requests/limits for core deployment.
- `admission_controller`, `cleanup_controller`, `background_controller` (object): Per-controller enablement, replica count, resources.
- `enable_metrics` (bool): Expose metrics service and ServiceMonitor.
- `helm_values_overrides` (map): Extra Helm values merged into defaults.
- `enable_example_policy` (bool): Deploy sample `ClusterPolicy` disallowing root containers.

## Outputs
- `release_name`: Helm release name.
- `namespace`: Target namespace.
- `chart_version`: Chart version deployed.

## Notes
- `create_namespace` is enabled on the Helm release for automatic namespace creation.
- ServiceMonitor is enabled when `enable_metrics` is true; adjust `additionalLabels` to match your Prometheus Operator selector.
