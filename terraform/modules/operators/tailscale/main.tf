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

resource "kubernetes_secret_v1" "oauth" {
  metadata {
    name      = var.oauth_secret_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  data = {
    client_id     = var.oauth_client_id
    client_secret = var.oauth_client_secret
  }
}

resource "helm_release" "this" {
  name       = var.release_name
  repository = "https://pkgs.tailscale.com/helmcharts"
  chart      = "tailscale-operator"
  version    = var.chart_version

  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  atomic           = var.atomic
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history

  values = var.values
  set    = var.set

  depends_on = [kubernetes_secret_v1.oauth]
}
