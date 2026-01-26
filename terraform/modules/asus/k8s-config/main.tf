terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      # pick a version you already use; examples online often reference ~1.14.x
      version = ">= 1.19.0"
    }
  }
}
