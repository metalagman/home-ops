resource "kubernetes_namespace_v1" "nginx_gateway" {
  metadata {
    name = var.namespace
  }
}
