module "nginx_gateway_fabric" {
  source = "github.com/metalagman/home-ops//terraform/modules/nginx-gateway-fabric?ref=master"

  namespace         = var.nginx_gateway_fabric_namespace
  helm_release_name = var.nginx_gateway_fabric_helm_release_name
  chart_version     = var.nginx_gateway_fabric_chart_version
  crd_version       = var.nginx_gateway_fabric_crd_version
  chart_set         = var.nginx_gateway_fabric_chart_set

  chart_values = [
    <<-EOF
    nginx:
      patches:
        - type: StrategicMerge
          value:
            metadata:
              annotations:
                secret.reloader.stakater.com/auto: "true"
      config:
        rewriteClientIP:
          mode: XForwardedFor
          setIPRecursively: true
          trustedAddresses:
            - type: CIDR
              value: 10.0.0.0/8
            - type: CIDR
              value: 100.64.0.0/10
      service:
        type: ClusterIP
    nginxGateway:
      snippetsFilters:
        enable: true
    EOF
  ]
}

resource "kubernetes_annotations" "nginx_gateway_fabric_tls_reloader" {
  api_version = "apps/v1"
  kind        = "Deployment"

  metadata {
    name      = "${var.nginx_gateway_fabric_helm_release_name}-nginx-gateway-fabric"
    namespace = var.nginx_gateway_fabric_namespace
  }

  annotations = {
    "secret.reloader.stakater.com/auto" = "true"
  }

  depends_on = [
    helm_release.reloader,
    module.nginx_gateway_fabric,
  ]
}
