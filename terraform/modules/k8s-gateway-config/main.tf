terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      # pick a version you already use; examples online often reference ~1.14.x
      version = ">= 1.19.0"
    }
  }
}
