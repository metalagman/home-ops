terraform {
  source = "../../../terraform/modules/asus/k8s-config"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "kubernetes_provider" {
  path = "${get_terragrunt_dir()}/../../_providers/kubernetes.hcl"
}

include "kubectl_provider" {
  path = "${get_terragrunt_dir()}/../../_providers/kubectl.hcl"
}

inputs = {
  tailscale_oauth_client_id     = get_env("TAILSCALE_OAUTH_CLIENT_ID")
  tailscale_oauth_client_secret = get_env("TAILSCALE_OAUTH_CLIENT_SECRET")
}
