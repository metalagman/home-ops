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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

data "kubectl_kustomize_documents" "argocd_crds" {
  target = "https://github.com/argoproj/argo-cd/manifests/crds?ref=${var.argocd_app_version}"
}

resource "kubectl_manifest" "argocd_crds" {
  for_each = {
    for idx, doc in data.kubectl_kustomize_documents.argocd_crds.documents :
    tostring(idx) => doc
  }

  yaml_body = each.value

  server_side_apply = true
  force_conflicts   = true

  wait_for_rollout = false
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  namespace        = kubernetes_namespace_v1.argocd.metadata[0].name
  create_namespace = false

  set = [
    {
      name  = "crds.install"
      value = "false"
    },
    {
      name  = "redis-ha.enabled"
      value = "false"
    },
    {
      name  = "controller.replicas"
      value = "1"
    },
    {
      name  = "server.replicas"
      value = "1"
    },
    {
      name  = "repoServer.replicas"
      value = "1"
    },
    {
      name  = "applicationSet.replicas"
      value = "1"
    }
  ]

  skip_crds = true

  atomic          = true
  wait            = true
  cleanup_on_fail = true
  timeout         = 600
  max_history     = 3

  depends_on = [kubernetes_namespace_v1.argocd, kubectl_manifest.argocd_crds]
}
