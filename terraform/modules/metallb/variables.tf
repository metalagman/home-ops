variable "ip_address_pool_name" {
  description = "Name of the MetalLB IPAddressPool."
  type        = string
  default     = "default"
}

variable "ip_address_pool_addresses" {
  description = "Address ranges MetalLB can allocate from (CIDR or start-end range)."
  type        = list(string)
}

variable "ip_address_pool_auto_assign" {
  description = "Whether MetalLB should auto-assign IPs from this pool."
  type        = bool
  default     = true
}

variable "l2_advertisement_name" {
  description = "Name of the MetalLB L2Advertisement."
  type        = string
  default     = "default"
}

variable "l2_interfaces" {
  description = "Network interfaces on which MetalLB should send L2 announcements."
  type        = list(string)
  default     = []
}

variable "load_balancer_class" {
  description = "loadBalancerClass value configured for MetalLB controller/speaker."
  type        = string
  default     = "metallb.io/metallb"
}
