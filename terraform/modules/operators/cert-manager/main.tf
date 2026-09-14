terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
  }
}

resource "helm_release" "this" {
  name       = var.release_name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true
  cleanup_on_fail  = var.cleanup_on_fail
  upgrade_install  = var.upgrade_install
  atomic           = var.atomic
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history

  values = var.values
  set = concat(
    [
      {
        name  = "installCRDs"
        value = tostring(var.install_crds)
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
        value = tostring(var.enable_gateway_api)
      },
    ],
    coalesce(var.set, []),
  )
}
