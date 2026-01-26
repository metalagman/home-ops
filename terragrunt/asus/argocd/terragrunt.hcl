terraform {
  source = "../../../terraform/modules/argocd"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "kubernetes_provider" {
  path = "${get_terragrunt_dir()}/../../_providers/kubernetes.hcl"
}

include "kubectl_provider" {
  path = "${get_terragrunt_dir()}/../../_providers/kubectl.hcl"
}
