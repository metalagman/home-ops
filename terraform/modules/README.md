# Terraform modules

This repository publishes site-neutral Kubernetes capability modules. It does not own a live cluster, provider credentials, backend configuration, Gateway instances, application workloads, or environment-specific values.

## APIs

| Module | Responsibility |
|---|---|
| `apis/gateway-api` | Install a pinned Gateway API CRD channel |

## Operators

| Module | Responsibility |
|---|---|
| `operators/argocd` | Argo CD CRDs and controller installation |
| `operators/cert-manager` | cert-manager installation and Gateway API feature switch |
| `operators/clickhouse` | ClickHouse Operator installation |
| `operators/metallb` | MetalLB controller and speaker installation |
| `operators/nginx-gateway-fabric` | NGINX Gateway Fabric CRDs, certificates, and controller |
| `operators/openebs` | OpenEBS installation with caller-owned engine values |
| `operators/postgres` | Zalando Postgres Operator and optional UI |
| `operators/reloader` | Stakater Reloader installation |
| `operators/tailscale` | Tailscale Operator and its credential Secret interface |

Concrete cluster composition belongs in the consuming private repository. Pin module sources to an immutable commit SHA or release tag.

Run `task modules:verify` from the repository root to check formatting and validate every published module without configuring a backend.
