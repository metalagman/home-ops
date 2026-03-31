terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

module "k8s_gateway_config" {
  source = "../../k8s-gateway-config"

  gateway_service_annotations = {
    "home-ops.fastronome.com/exposure" = "ingress"
  }
}

resource "kubectl_manifest" "tailscale_ingress" {
  depends_on = [module.k8s_gateway_config]
  yaml_body  = <<-EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: edge
  namespace: gateway
  annotations:
    tailscale.com/funnel: "true"
spec:
  ingressClassName: tailscale
  defaultBackend:
    service:
      name: edge-nginx
      port:
        number: 80
  tls:
    - hosts:
        - edge
EOF

  server_side_apply = true
}
