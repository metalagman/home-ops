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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.namespace
  }
}

data "kubectl_kustomize_documents" "argocd_crds" {
  target = "https://github.com/argoproj/argo-cd/manifests/crds?ref=${var.app_version}"
}

resource "kubectl_manifest" "argocd_crds" {
  for_each = {
    for idx, doc in data.kubectl_kustomize_documents.argocd_crds.documents :
    tostring(idx) => doc
  }

  yaml_body = each.value

  server_side_apply = true
  force_conflicts   = true
  wait_for_rollout  = false
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  namespace        = kubernetes_namespace_v1.argocd.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  atomic           = true
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history
  skip_crds        = true

  values = var.values
  set = concat(
    [
      { name = "crds.install", value = "false" },
    ],
    var.set,
  )

  depends_on = [kubectl_manifest.argocd_crds]
}
