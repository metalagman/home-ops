terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

locals {
  manifest_url = "https://github.com/kubernetes-sigs/gateway-api/releases/download/${var.release_version}/${var.channel}-install.yaml"
}

data "http" "manifest" {
  url = local.manifest_url
}

data "kubectl_file_documents" "manifest" {
  content = data.http.manifest.response_body
}

resource "kubectl_manifest" "this" {
  for_each = data.kubectl_file_documents.manifest.manifests

  yaml_body = each.value

  server_side_apply = true
  force_conflicts   = var.force_conflicts
}
