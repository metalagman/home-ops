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
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

resource "kubernetes_namespace_v1" "rustfs" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "rustfs_secret_key" {
  length  = 40
  special = false
}

resource "kubernetes_secret_v1" "rustfs_credentials" {
  metadata {
    name      = var.existing_secret_name
    namespace = kubernetes_namespace_v1.rustfs.metadata[0].name
  }

  data = {
    RUSTFS_ACCESS_KEY = "rustfsadmin"
    RUSTFS_SECRET_KEY = random_password.rustfs_secret_key.result
  }

  type = "Opaque"
}

resource "helm_release" "rustfs" {
  name             = var.release_name
  repository       = "https://charts.rustfs.com"
  chart            = "rustfs"
  version          = var.chart_version
  namespace        = kubernetes_namespace_v1.rustfs.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  wait             = true
  atomic           = true
  timeout          = 600
  max_history      = 3

  set = [
    {
      name  = "secret.existingSecret"
      value = kubernetes_secret_v1.rustfs_credentials.metadata[0].name
    },
    {
      name  = "mode.standalone.enabled"
      value = "true"
    },
    {
      name  = "mode.distributed.enabled"
      value = "false"
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
      name  = "gatewayApi.enabled"
      value = "false"
    },
    {
      name  = "service.type"
      value = "ClusterIP"
    },
    {
      name  = "storageclass.name"
      value = var.storage_class_name
    },
  ]

  depends_on = [kubernetes_secret_v1.rustfs_credentials]
}

resource "kubernetes_service_v1" "rustfs_lb" {
  metadata {
    name      = "${var.release_name}-lb"
    namespace = kubernetes_namespace_v1.rustfs.metadata[0].name
  }

  spec {
    selector = {
      "app.kubernetes.io/name"     = "rustfs"
      "app.kubernetes.io/instance" = var.release_name
    }

    port {
      name        = "endpoint"
      port        = 9000
      target_port = 9000
    }

    port {
      name        = "console"
      port        = 9001
      target_port = 9001
    }

    type                = "LoadBalancer"
    load_balancer_class = var.load_balancer_class
  }

  depends_on = [helm_release.rustfs]
}
