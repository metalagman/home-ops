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

resource "kubernetes_namespace_v1" "registry" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "registry" {
  name             = var.release_name
  repository       = "https://twuni.github.io/docker-registry.helm"
  chart            = "docker-registry"
  version          = var.chart_version
  namespace        = kubernetes_namespace_v1.registry.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  wait             = true
  atomic           = true
  timeout          = 600
  max_history      = 3

  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    },
    {
      name  = "service.port"
      value = "5000"
    },
    {
      name  = "persistence.enabled"
      value = "true"
    },
    {
      name  = "persistence.storageClass"
      value = var.storage_class_name
    },
    {
      name  = "persistence.size"
      value = var.storage_size
    },
    {
      name  = "persistence.deleteEnabled"
      value = "true"
    },
    {
      name  = "storage"
      value = "filesystem"
    },
    {
      name  = "replicaCount"
      value = "1"
    },
    {
      name  = "ingress.enabled"
      value = "false"
    },
    {
      name  = "metrics.enabled"
      value = "false"
    },
    {
      name  = "garbageCollect.enabled"
      value = "true"
    },
    {
      name  = "garbageCollect.deleteUntagged"
      value = "true"
    },
    {
      name  = "garbageCollect.schedule"
      value = "0 3 * * *"
    },
  ]
}

resource "kubernetes_service_v1" "registry_lb" {
  metadata {
    name      = "${var.release_name}-lb"
    namespace = kubernetes_namespace_v1.registry.metadata[0].name
  }

  spec {
    selector = {
      app     = "docker-registry"
      release = var.release_name
    }

    port {
      name        = "http"
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type                = "LoadBalancer"
    load_balancer_class = var.load_balancer_class
    load_balancer_ip    = var.registry_load_balancer_ip
  }

  depends_on = [helm_release.registry]
}
