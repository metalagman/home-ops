resource "kubectl_manifest" "clusterissuer_istio_letsencrypt_production" {
  depends_on = [
    helm_release.istio_ingressgateway
  ]
  yaml_body = <<-YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: istio-letsencrypt-production
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.cert_manager_contact_email}
    privateKeySecretRef:
      name: letsencrypt-issuer-account-key-prod
    solvers:
      - http01:
          gatewayHTTPRoute:
            parentRefs:
              - name: istio-ingressgateway
                namespace: ${kubernetes_namespace_v1.istio_ingress.metadata[0].name}
                kind: Gateway
YAML
}

# not in use, use production instead
resource "kubectl_manifest" "clusterissuer_istio_letsencrypt_staging" {
  depends_on = [
    helm_release.istio_ingressgateway
  ]
  yaml_body = <<-YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: istio-letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: ${var.cert_manager_contact_email}
    privateKeySecretRef:
      name: letsencrypt-issuer-account-key-staging
    solvers:
      - http01:
          gatewayHTTPRoute:
            parentRefs:
              - name: istio-ingressgateway
                namespace: ${kubernetes_namespace_v1.istio_ingress.metadata[0].name}
                kind: Gateway
YAML
}
