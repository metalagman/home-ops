module "nginx_gateway_fabric" {
  source = "github.com/metalagman/home-ops//terraform/modules/nginx-gateway-fabric?ref=master"

  namespace         = var.nginx_gateway_fabric_namespace
  helm_release_name = var.nginx_gateway_fabric_helm_release_name
  chart_version     = var.nginx_gateway_fabric_chart_version
  crd_version       = var.nginx_gateway_fabric_crd_version
  chart_values      = var.nginx_gateway_fabric_chart_values
  chart_set         = var.nginx_gateway_fabric_chart_set
}
