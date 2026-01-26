locals {
  kubeconfig_path = get_env("KUBECONFIG")
  kube_context    = get_env("KUBECONTEXT")
}

# Generate an Kubernetes provider block
generate "provider_kubernetes" {
  path      = "provider_kubernetes.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
  config_path    = "${local.kubeconfig_path}"
  config_context = "${local.kube_context}"
}

provider "helm" {
  kubernetes = {
    config_path    = "${local.kubeconfig_path}"
    config_context = "${local.kube_context}"
  }
}
EOF
}
