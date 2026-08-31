resource "kubernetes_namespace_v1" "reloader" {
  metadata {
    name = var.reloader_namespace
  }
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = var.reloader_chart_version

  namespace        = kubernetes_namespace_v1.reloader.metadata[0].name
  create_namespace = false

  values = [<<-YAML
    reloader:
      ignoreJobs: true
      ignoreCronJobs: true
      reloadStrategy: annotations
      watchGlobally: true
  YAML
  ]

  atomic          = true
  wait            = true
  cleanup_on_fail = true
  timeout         = 300
  max_history     = 3

  depends_on = [kubernetes_namespace_v1.reloader]
}
