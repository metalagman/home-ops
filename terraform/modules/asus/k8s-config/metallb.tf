module "metallb" {
  source = "../../metallb"

  load_balancer_class         = var.metallb_load_balancer_class
  ip_address_pool_name        = var.metallb_ip_address_pool_name
  ip_address_pool_addresses   = var.metallb_ip_address_pool_addresses
  ip_address_pool_auto_assign = var.metallb_ip_address_pool_auto_assign
  l2_advertisement_name       = var.metallb_l2_advertisement_name
  l2_interfaces               = var.metallb_l2_interfaces
}

moved {
  from = kubernetes_namespace_v1.metallb_system
  to   = module.metallb.kubernetes_namespace_v1.metallb_system
}

moved {
  from = helm_release.metallb
  to   = module.metallb.helm_release.metallb
}

moved {
  from = kubectl_manifest.metallb_ip_address_pool
  to   = module.metallb.kubectl_manifest.metallb_ip_address_pool
}

moved {
  from = kubectl_manifest.metallb_l2_advertisement
  to   = module.metallb.kubectl_manifest.metallb_l2_advertisement
}
