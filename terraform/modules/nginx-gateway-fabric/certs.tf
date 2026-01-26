resource "kubectl_manifest" "selfsigned_issuer" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: selfsigned-issuer
      namespace: ${var.namespace}
    spec:
      selfSigned: {}
  YAML

  depends_on = [kubernetes_namespace_v1.nginx_gateway]
}

resource "kubectl_manifest" "nginx_gateway_ca" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: nginx-gateway-ca
      namespace: ${var.namespace}
    spec:
      isCA: true
      commonName: nginx-gateway
      secretName: nginx-gateway-ca
      privateKey:
        algorithm: RSA
        size: 2048
      issuerRef:
        name: selfsigned-issuer
        kind: Issuer
        group: cert-manager.io
  YAML

  depends_on = [
    kubernetes_namespace_v1.nginx_gateway,
    kubectl_manifest.selfsigned_issuer
  ]
}

resource "kubectl_manifest" "nginx_gateway_issuer" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: nginx-gateway-issuer
      namespace: ${var.namespace}
    spec:
      ca:
        secretName: nginx-gateway-ca
  YAML

  depends_on = [
    kubernetes_namespace_v1.nginx_gateway,
    kubectl_manifest.nginx_gateway_ca
  ]
}

resource "kubectl_manifest" "nginx_gateway_server_cert" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: nginx-gateway
      namespace: ${var.namespace}
    spec:
      secretName: server-tls
      usages:
      - digital signature
      - key encipherment
      dnsNames:
      - ${var.helm_release_name}-nginx-gateway-fabric.${var.namespace}.svc
      issuerRef:
        name: nginx-gateway-issuer
  YAML

  depends_on = [
    kubernetes_namespace_v1.nginx_gateway,
    kubectl_manifest.nginx_gateway_issuer
  ]
}

resource "kubectl_manifest" "nginx_agent_client_cert" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: nginx
      namespace: ${var.namespace}
    spec:
      secretName: agent-tls
      usages:
      - "digital signature"
      - "key encipherment"
      dnsNames:
      - "*.cluster.local"
      issuerRef:
        name: nginx-gateway-issuer
  YAML

  depends_on = [
    kubernetes_namespace_v1.nginx_gateway,
    kubectl_manifest.nginx_gateway_issuer
  ]
}
