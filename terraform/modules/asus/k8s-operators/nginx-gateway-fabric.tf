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
