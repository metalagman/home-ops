resource "kubernetes_namespace_v1" "postgres_operator" {
  count = var.postgres_operator_enabled ? 1 : 0

  metadata {
    name = var.postgres_operator_namespace
  }
}

resource "helm_release" "postgres_operator" {
  count = var.postgres_operator_enabled ? 1 : 0

  name       = "postgres-operator"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
  chart      = "postgres-operator"
  version    = var.postgres_operator_chart_version

  namespace        = kubernetes_namespace_v1.postgres_operator[0].metadata[0].name
  create_namespace = false

  values = var.postgres_operator_values

  atomic          = true
  wait            = true
  cleanup_on_fail = true
  timeout         = 600
  max_history     = 3

  depends_on = [kubernetes_namespace_v1.postgres_operator]
}

resource "helm_release" "postgres_operator_ui" {
  count = var.postgres_operator_enabled && var.postgres_operator_ui_enabled ? 1 : 0

  name       = "postgres-operator-ui"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui"
  chart      = "postgres-operator-ui"
  version    = var.postgres_operator_ui_chart_version

  namespace        = kubernetes_namespace_v1.postgres_operator[0].metadata[0].name
  create_namespace = false

  values = var.postgres_operator_ui_values

  atomic          = true
  wait            = true
  cleanup_on_fail = true
  timeout         = 600
  max_history     = 3

  depends_on = [helm_release.postgres_operator]
}
