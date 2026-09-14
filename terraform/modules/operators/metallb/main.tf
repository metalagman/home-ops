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

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name   = var.namespace
    labels = var.namespace_labels
  }
}

resource "helm_release" "this" {
  name       = var.release_name
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = var.chart_version

  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  atomic           = true
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history

  values = var.values
  set    = var.set
}
