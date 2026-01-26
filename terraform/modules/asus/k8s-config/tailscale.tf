resource "kubernetes_namespace_v1" "tailscale" {
  metadata {
    name = "tailscale"
  }
}

resource "kubernetes_secret_v1" "operator_oauth" {
  metadata {
    name      = "operator-oauth"
    namespace = kubernetes_namespace_v1.tailscale.metadata[0].name
  }

  data = {
    client_id     = var.tailscale_oauth_client_id
    client_secret = var.tailscale_oauth_client_secret
  }
}

resource "helm_release" "tailscale_operator" {
  name             = "tailscale-operator"
  repository       = "https://pkgs.tailscale.com/helmcharts"
  chart            = "tailscale-operator"
  version          = "1.92.5"
  namespace        = kubernetes_namespace_v1.tailscale.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  timeout          = 300
}
