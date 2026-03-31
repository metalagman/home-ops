terraform {
  source = "../../../terraform/modules/k8s-operators"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "kubernetes_provider" {
  path = "${get_terragrunt_dir()}/../../_providers/kubernetes.hcl"
}

dependency "k8s-config" {
  config_path = "../k8s-config"
  skip_outputs = true
}
