resource "kubectl_manifest" "cluster_issuer_letsencrypt_production_gateway" {
  depends_on = [
    kubectl_manifest.gateway,
  ]
  yaml_body = <<-YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production-gateway
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.acme_contact_email}
    privateKeySecretRef:
      name: letsencrypt-issuer-account-key-prod
    solvers:
      - http01:
          gatewayHTTPRoute:
            parentRefs:
              - name: ${var.gateway_name}
                namespace: ${var.gateway_namespace}
                kind: Gateway
YAML
}

resource "kubectl_manifest" "cluster_issuer_letsencrypt_staging_gateway" {
  depends_on = [
    kubectl_manifest.gateway,
  ]
  yaml_body = <<-YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging-gateway
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: ${var.acme_contact_email}
    privateKeySecretRef:
      name: letsencrypt-issuer-account-key-staging
    solvers:
      - http01:
          gatewayHTTPRoute:
            parentRefs:
              - name: ${var.gateway_name}
                namespace: ${var.gateway_namespace}
                kind: Gateway
YAML
}
