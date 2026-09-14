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

resource "kubernetes_namespace_v1" "postgres_operator" {
  count = var.enabled ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "postgres_operator" {
  count = var.enabled ? 1 : 0

  name       = var.release_name
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
  chart      = "postgres-operator"
  version    = var.chart_version

  namespace        = kubernetes_namespace_v1.postgres_operator[0].metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  atomic           = true
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history
  values           = var.values
}

resource "helm_release" "postgres_operator_ui" {
  count = var.enabled && var.ui_enabled ? 1 : 0

  name       = var.ui_release_name
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui"
  chart      = "postgres-operator-ui"
  version    = var.ui_chart_version

  namespace        = kubernetes_namespace_v1.postgres_operator[0].metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  atomic           = true
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history
  values           = var.ui_values

  depends_on = [helm_release.postgres_operator]
}
