locals {
  kubeconfig_path = get_env("KUBECONFIG")
  kube_context    = get_env("KUBECONTEXT")
}

# Generate an kubectl provider block
generate "provider_kubectl" {
  path      = "provider_kubectl.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubectl" {
  config_path    = "${local.kubeconfig_path}"
  config_context = "${local.kube_context}"
}
EOF
}
