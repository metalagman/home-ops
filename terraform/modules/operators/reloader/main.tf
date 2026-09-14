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

resource "kubernetes_namespace_v1" "reloader" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "reloader" {
  name       = var.release_name
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = var.chart_version

  namespace        = kubernetes_namespace_v1.reloader.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  atomic           = true
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history

  values = var.values
  set    = var.set
}
