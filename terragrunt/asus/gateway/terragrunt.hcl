terraform {
  source = "../../../terraform/modules//asus/gateway"
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

dependency "k8s-operators" {
  config_path  = "../k8s-operators"
  skip_outputs = true
}
