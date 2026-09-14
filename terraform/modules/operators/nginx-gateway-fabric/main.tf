terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

resource "kubernetes_namespace_v1" "nginx_gateway" {
  metadata {
    name = var.namespace
  }
}

data "kubectl_kustomize_documents" "nginx_gateway_fabric_crds" {
  target = "https://github.com/nginx/nginx-gateway-fabric/config/crd?ref=${var.crd_version}"
}

resource "kubectl_manifest" "nginx_gateway_fabric_crds" {
  for_each = {
    for idx, doc in data.kubectl_kustomize_documents.nginx_gateway_fabric_crds.documents :
    tostring(idx) => doc
  }

  yaml_body = each.value

  server_side_apply = true
  force_conflicts   = true
  wait_for_rollout  = false
}

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

  depends_on = [kubectl_manifest.selfsigned_issuer]
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

  depends_on = [kubectl_manifest.nginx_gateway_ca]
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
        - ${var.release_name}-nginx-gateway-fabric.${var.namespace}.svc
      issuerRef:
        name: nginx-gateway-issuer
  YAML

  depends_on = [kubectl_manifest.nginx_gateway_issuer]
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
        - digital signature
        - key encipherment
      dnsNames:
        - "*.cluster.local"
      issuerRef:
        name: nginx-gateway-issuer
  YAML

  depends_on = [kubectl_manifest.nginx_gateway_issuer]
}

resource "helm_release" "nginx_gateway_fabric" {
  name       = var.release_name
  repository = "oci://ghcr.io/nginx/charts"
  chart      = "nginx-gateway-fabric"
  version    = var.chart_version

  namespace        = kubernetes_namespace_v1.nginx_gateway.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  atomic           = true
  wait             = true
  timeout          = var.timeout
  max_history      = var.max_history

  values = var.values
  set    = var.set

  depends_on = [
    kubectl_manifest.nginx_gateway_fabric_crds,
    kubectl_manifest.nginx_gateway_server_cert,
    kubectl_manifest.nginx_agent_client_cert,
  ]
}
