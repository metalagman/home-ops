terraform {
  source = "../../../../terraform/modules/clickhouse"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "kubernetes_provider" {
  path = "${get_terragrunt_dir()}/../../../_providers/kubernetes.hcl"
}

include "kubectl_provider" {
  path = "${get_terragrunt_dir()}/../../../_providers/kubectl.hcl"
}

dependency "k8s-config" {
  config_path  = "../../k8s-config"
  skip_outputs = true
}

dependency "k8s-operators" {
  config_path  = "../../k8s-operators"
  skip_outputs = true
}

dependency "rustfs" {
  config_path = "../rustfs"
}

inputs = {
  clickhouse_s3_access_key_id     = dependency.rustfs.outputs.access_key_id
  clickhouse_s3_secret_access_key = dependency.rustfs.outputs.secret_access_key
}
