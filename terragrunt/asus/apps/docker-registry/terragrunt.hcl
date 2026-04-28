terraform {
  source = "../../../../terraform/modules/docker-registry"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "kubernetes_provider" {
  path = "${get_terragrunt_dir()}/../../../_providers/kubernetes.hcl"
}

dependency "k8s-config" {
  config_path  = "../../k8s-config"
  skip_outputs = true
}

inputs = {
  namespace                 = "registry"
  release_name              = "registry"
  chart_version             = "3.0.0"
  load_balancer_class       = "metallb.io/metallb"
  registry_load_balancer_ip = "192.168.31.130"
  storage_class_name        = "openebs-hdd-lvm"
  storage_size              = "100Gi"
}
