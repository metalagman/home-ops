resource "kubernetes_namespace_v1" "gateway" {
  metadata {
    name = var.gateway_namespace
  }
}

resource "kubectl_manifest" "gateway" {
  depends_on = [
    kubernetes_namespace_v1.gateway,
  ]
  yaml_body = <<-EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: ${var.gateway_name}
  namespace: ${kubernetes_namespace_v1.gateway.metadata[0].name}
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-production-gateway
spec:
  infrastructure:
    annotations:
%{for k, v in var.gateway_service_annotations~}
      ${k}: "${v}"
%{endfor~}
  gatewayClassName: ${var.gateway_class_name}
  listeners:
    - name: http
      port: 80
      protocol: HTTP
      allowedRoutes:
        namespaces:
          from: All
%{for host in var.gateway_https_hosts~}
    - name: ${host.name}-https
      hostname: "${host.hostname}"
      port: 443
      protocol: HTTPS
      tls:
        mode: Terminate
        certificateRefs:
          - name: ${host.name}-tls
      allowedRoutes:
        namespaces:
          from: Selector
          selector:
            matchLabels:
              kubernetes.io/metadata.name: "${host.namespace}"
%{endfor~}
EOF

  server_side_apply = true
}
