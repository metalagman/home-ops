resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.19.2"

  namespace = "cert-manager"
  depends_on = [
    kubectl_manifest.gateway_api,
  ]

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "config.apiVersion"
      value = "controller.config.cert-manager.io/v1alpha1"
    },
    {
      name  = "config.kind"
      value = "ControllerConfiguration"
    },
    {
      name  = "config.enableGatewayAPI"
      value = "true"
    },
  ]

  create_namespace = true
}
