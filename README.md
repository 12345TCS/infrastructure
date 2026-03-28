# DigitalOcean Kubernetes Platform

This repository uses a two-layer Terraform layout:

- `envs/<env>/infra`: DigitalOcean VPC and DOKS cluster
- `envs/<env>/platform`: cert-manager, ingress-nginx for infra/admin services, Kong for application traffic, Rancher, Prometheus/Grafana monitoring, and an in-cluster PostgreSQL StatefulSet for Kong

## Canonical Layout

```text
modules/
  cert-manager/
  do-k8s-cluster/
  ingress-nginx/
  kong/
  kong-postgres/
  monitoring/
  rancher/
envs/
  dev/
    infra/
    platform/
  stage/
    infra/
    platform/
  prod/
    infra/
    platform/
```

## Workflow

Dev, stage, and prod use the same deployment model:

1. apply `envs/<env>/infra`
2. fetch kubeconfig from infra outputs
3. apply `envs/<env>/platform`

Before deploying, create and fill these files:

- copy `envs/dev/infra/terraform.tfvars.example` to `envs/dev/infra/terraform.tfvars`
- copy `envs/dev/platform/terraform.tfvars.example` to `envs/dev/platform/terraform.tfvars`

Minimum values you must replace:

- `do_token`
- `kong_postgres_password`
- `rancher_bootstrap_password`

- `kong_admin_gui_session_conf` secret
- `grafana_admin_password`
- `kong_admin_gui_session_conf` secret 
      create a token using the below command 
        [guid]::NewGuid().ToString("N") + [guid]::NewGuid().ToString("N")

Example for dev:

```powershell
cd "envs/dev/infra"
Copy-Item .\terraform.tfvars.example .\terraform.tfvars
terraform init
terraform plan -var-file="terraform.tfvars" -out="infra.tfplan"
terraform apply "infra.tfplan"

terraform output -raw kubeconfig_raw | Set-Content ..\platform\kubeconfig.yaml

cd "..\platform"
Copy-Item .\terraform.tfvars.example .\terraform.tfvars
terraform init
terraform plan -var-file="terraform.tfvars" -out="platform-base.tfplan"
terraform apply "platform-base.tfplan"

$env:KUBECONFIG = (Resolve-Path .\kubeconfig.yaml)
kubectl get svc -n ingress-nginx
```

Update `envs/dev/platform/terraform.tfvars` with the `ingress-nginx` external IP:

```hcl
rancher_hostname = "rancher.<external-ip>.sslip.io"
```

Then re-run:

```powershell
terraform plan -var-file="terraform.tfvars" -out="platform.tfplan"
terraform apply "platform.tfplan"
```

Destroy order is always the reverse:

```powershell
cd "envs/dev/platform"
terraform destroy -var-file="terraform.tfvars"

cd "..\infra"
terraform destroy -var-file="terraform.tfvars"
```

After a successful dev deployment:

- Rancher is exposed through `ingress-nginx`, not Kong
- Kong Admin API can be accessed by port-forwarding the admin service
- Kong Manager, if available in the deployed Kong build, can be accessed by port-forwarding the manager service
- Grafana can be accessed by port-forwarding the Grafana service in the `monitoring` namespace
- Kong uses an in-cluster PostgreSQL StatefulSet, not DigitalOcean Managed Databases

## Access After Apply

From `envs/dev/platform`, set kubeconfig for local access:

```powershell
$env:KUBECONFIG = (Resolve-Path .\kubeconfig.yaml)
```

### Rancher

Open in the browser:

```text
https://rancher.<external-ip>.sslip.io
```

For the current dev flow, this is the `rancher_hostname` value from `envs/dev/platform/terraform.tfvars`.

Login:

- username: `admin`
- password: `rancher_bootstrap_password` from `envs/dev/platform/terraform.tfvars`

### Kong Admin API

```powershell
kubectl -n kong port-forward svc/kong-kong-admin 8001:8001
```

Then open:

```text
http://127.0.0.1:8001
```

### Kong Manager

If exposed by the deployed Kong build:

```powershell
kubectl -n kong port-forward svc/kong-kong-manager 8002:8002
```

Then open:

```text
http://127.0.0.1:8002
```

### Grafana

```powershell
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
```

Then open:

```text
http://127.0.0.1:3000
```

Login:

- username: `admin`
- password: `grafana_admin_password` from `envs/dev/platform/terraform.tfvars`

### Prometheus

```powershell
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090
```

Then open:

```text
http://127.0.0.1:9090
```

### Alertmanager

```powershell
kubectl -n monitoring port-forward svc/kube-prometheus-stack-alertmanager 9093:9093
```

Then open:

```text
http://127.0.0.1:9093
```

### Useful Service Discovery Commands

```powershell
kubectl get svc -n kong
kubectl get svc -n monitoring
kubectl get ingress -n cattle-system
```

## Access Pattern

- Rancher is an infra/admin service and is exposed through `ingress-nginx`.
- Kong is reserved for application-related services.
- Prometheus and Grafana run in the `monitoring` namespace and are scheduled onto the `monitoring` node pool.
- For dev without a real domain, use `sslip.io`, for example:
  - `rancher.<load-balancer-ip>.sslip.io`
- For prod, use a real domain and set Rancher TLS source appropriately.

## Node Pools

DOKS does not support exact custom per-node names, but it does support multiple named node pools with labels.
This repository uses three single-node pools by default:

- `rancher` with label `workload=rancher`
- `kong` with label `workload=kong`
- `monitoring` with label `workload=monitoring`

Scheduling behavior:

- Rancher is pinned to the `rancher` pool
- Kong and Kong PostgreSQL are pinned to the `kong` pool
- Prometheus, Grafana, and related monitoring components are pinned to the `monitoring` pool
- application workloads can target the `monitoring` pool, or you can add a separate application pool later if needed

This gives you stable pool names for scaling and clearer workload isolation, even though the underlying DOKS node names are still auto-generated.

## Recommended Defaults

- `dev`: 3 pools with 1 `s-2vcpu-2gb` node each, Kong with a single-replica PostgreSQL StatefulSet
- `stage`: 3 pools with 1 `s-2vcpu-4gb` node each
- `prod`: 3 pools with 1 `s-4vcpu-8gb` node each, larger Kong/PostgreSQL resource allocations, real DNS

## Notes

- If a pool has only one node, workloads pinned to that pool are not highly available.
- The old single-layer layout has been removed.
- `terraform.tfvars`, kubeconfig files, local state, plans, and Helm caches are ignored by git.
