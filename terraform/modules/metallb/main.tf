terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

resource "kubernetes_namespace_v1" "metallb_system" {
  metadata {
    name = "metallb-system"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }
}

resource "helm_release" "metallb" {
  name             = "metallb"
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  version          = "0.15.3"
  namespace        = kubernetes_namespace_v1.metallb_system.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  wait             = true
  atomic           = true
  timeout          = 300

  set = [
    {
      name  = "loadBalancerClass"
      value = var.load_balancer_class
    },
    {
      name  = "speaker.ignoreExcludeLB"
      value = "true"
    },
    {
      name  = "speaker.frr.enabled"
      value = "false"
    },
    {
      name  = "frrk8s.enabled"
      value = "false"
    },
    {
      name  = "prometheus.prometheusRule.bgpSessionDown.enabled"
      value = "false"
    },
  ]
}

resource "kubectl_manifest" "metallb_ip_address_pool" {
  depends_on = [helm_release.metallb]

  yaml_body = <<-YAML
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: ${var.ip_address_pool_name}
  namespace: ${kubernetes_namespace_v1.metallb_system.metadata[0].name}
spec:
  addresses:
%{for address in var.ip_address_pool_addresses~}
    - ${address}
%{endfor~}
  autoAssign: ${var.ip_address_pool_auto_assign}
YAML

  server_side_apply = true
}

resource "kubectl_manifest" "metallb_l2_advertisement" {
  depends_on = [kubectl_manifest.metallb_ip_address_pool]

  yaml_body = <<-YAML
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: ${var.l2_advertisement_name}
  namespace: ${kubernetes_namespace_v1.metallb_system.metadata[0].name}
%{if length(var.l2_interfaces) > 0~}
spec:
  interfaces:
%{for iface in var.l2_interfaces~}
    - ${iface}
%{endfor~}
%{endif~}
YAML

  server_side_apply = true
  force_conflicts   = true
}
