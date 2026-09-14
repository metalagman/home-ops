terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
}

resource "kubernetes_namespace_v1" "clickhouse_operator" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "clickhouse_operator" {
  name       = var.release_name
  repository = "oci://ghcr.io/clickhouse"
  chart      = "clickhouse-operator-helm"
  version    = var.chart_version

  namespace        = kubernetes_namespace_v1.clickhouse_operator.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  atomic           = true
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history

  values = var.values
  set    = var.set
}
