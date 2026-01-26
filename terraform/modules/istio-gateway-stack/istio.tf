resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace_v1" "istio_ingress" {
  metadata {
    name = "istio-ingress"
  }
}

resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = kubernetes_namespace_v1.istio_system.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  wait             = true
  atomic = true
  timeout          = 600

  set = [
    {
      name  = "defaultRevision"
      value = "default"
    }
  ]
}

resource "helm_release" "istiod" {
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = kubernetes_namespace_v1.istio_system.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  wait             = true
  timeout          = 600

  set = [
    {
      name  = "autoscaleEnabled"
      value = "false"
    },
  ]

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  namespace  = kubernetes_namespace_v1.istio_ingress.metadata[0].name
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  wait             = true
  timeout          = 600

  # Typical default label used by Istio gateway chart (pods get istio=ingressgateway)
  set = [
    {
      name  = "service.type"
      value = var.istio_gateway_service_type
    },
    {
      name  = "service.loadBalancerClass"
      value = var.istio_gateway_load_balancer_class
    },

    # Labels for predictable Istio Gateway selector later:
    # selector:
    #   istio: ingressgateway
    {
      name  = "labels.istio"
      value = "ingressgateway"
    },
    {
      name  = "labels.istio\\.io/dataplane-mode"
      value = "none"
    },
    {
      name  = "autoscaling.enabled"
      value = "false"
    },
  ]

  depends_on = [helm_release.istiod]
}
