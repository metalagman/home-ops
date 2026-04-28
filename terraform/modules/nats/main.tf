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

resource "kubernetes_namespace_v1" "nats" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "nats" {
  name             = var.release_name
  repository       = "https://nats-io.github.io/k8s/helm/charts/"
  chart            = "nats"
  version          = var.chart_version
  namespace        = kubernetes_namespace_v1.nats.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  wait             = true
  atomic           = true
  timeout          = 600
  max_history      = 3

  values = [
    <<-YAML
    config:
      cluster:
        enabled: false
      jetstream:
        enabled: true
        fileStore:
          enabled: true
          pvc:
            enabled: true
            size: ${var.jetstream_storage_size}
            storageClassName: ${var.jetstream_storage_class_name}
    YAML
  ]
}
