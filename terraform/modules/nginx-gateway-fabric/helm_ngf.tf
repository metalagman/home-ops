resource "helm_release" "nginx_gateway_fabric" {
  name       = var.helm_release_name
  repository = "oci://ghcr.io/nginx/charts"
  chart      = "nginx-gateway-fabric"
  namespace  = var.namespace

  set = [
    {
      name  = "nginx.service.type"
      value = var.service_type
    }
  ]

  # The issue description uses --create-namespace, but we already have a kubernetes_namespace_v1 resource.
  # So we don't need create_namespace = true here, but we must depend on it.

  depends_on = [
    kubernetes_namespace_v1.nginx_gateway,
    kubectl_manifest.nginx_gateway_server_cert,
    kubectl_manifest.nginx_agent_client_cert
  ]
}
