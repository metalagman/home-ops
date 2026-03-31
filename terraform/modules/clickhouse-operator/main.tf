terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
  }
}

resource "kubernetes_namespace_v1" "clickhouse_operator" {
  metadata {
    name = var.clickhouse_operator_namespace
  }
}

resource "helm_release" "clickhouse_operator" {
  name       = "clickhouse-operator"
  repository = "oci://ghcr.io/clickhouse"
  chart      = "clickhouse-operator-helm"
  version    = var.clickhouse_operator_chart_version

  namespace        = kubernetes_namespace_v1.clickhouse_operator.metadata[0].name
  create_namespace = false

  atomic          = true
  wait            = true
  cleanup_on_fail = true
  timeout         = 600
  max_history     = 3

  depends_on = [kubernetes_namespace_v1.clickhouse_operator]
}
