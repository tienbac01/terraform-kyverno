# Terraform Kyverno Deployment

Production-ready Terraform project to install Kyverno via the official Helm chart (pinned) with environment-specific configs and Kubernetes remote state.

## Architecture
- Root defines provider versions and reusable variables; module `modules/kyverno` handles Helm release, namespace creation, metrics, and optional sample policy.
- Environments `environments/dev` and `environments/prod` consume the module with different replica counts and independent Kubernetes backend state.
- Helm chart pinned (`chart_version`, default 3.7.1), metrics + ServiceMonitor enabled by default, controllers individually tunable.

## Usage
1. Select environment: `cd environments/dev` or `cd environments/prod`.
2. Initialize with Kubernetes remote state (kept in `kube-system` so it survives workload teardown):
   ```bash
   terraform init \
     -backend-config="namespace=kube-system" \
     -backend-config="secret_suffix=tf-kyverno-<env>" \
     -backend-config="config_path=~/.kube/config"
   ```
3. Review changes:
   ```bash
   terraform plan -out plan.tfplan
   ```
4. Apply:
   ```bash
   terraform apply plan.tfplan
   ```
5. Destroy (keeps backend state intact):
   ```bash
   terraform destroy
   ```

## Configurable Inputs
- `kubeconfig_path`, `kubernetes_context`
- `namespace` (default `kyverno`)
- `chart_version` (Helm chart pin, default `3.7.1`)
- `replica_count` plus per-controller enablement/resources
- `enable_metrics` to expose metrics/ServiceMonitor
- `helm_values_overrides` to merge arbitrary values
- `enable_example_policy` to deploy the sample `ClusterPolicy`
- TLS: add `skip_tls_verify = true` in tfvars or supply `cluster_ca_certificate` in providers if your API uses self-signed certs.

## Outputs
- `kyverno_release_name`
- `kyverno_namespace`
- `kyverno_chart_version`

## Lifecycle (upgrade / rollback / remove)
- Upgrade: bump provider pins in `versions.tf` and env files, bump `chart_version`, then `terraform init -upgrade` and `terraform apply` (test in `dev` first).
- Rollback: set `chart_version` back to previous value and `terraform apply`.
- Remove: run `terraform destroy`; backend state stays in `kube-system` so it’s safe to recreate later.

## Notes
- Namespace is created automatically by the Helm release.
- Adjust `metricsServiceMonitor.additionalLabels` in `modules/kyverno/main.tf` to match your Prometheus Operator selector.
- Use `helm_values_overrides` for per-controller image overrides (e.g., kubectl image for cleanup), resources, or extra values.
