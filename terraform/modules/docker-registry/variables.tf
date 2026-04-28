variable "namespace" {
  description = "Namespace for the Docker registry."
  type        = string
  default     = "registry"
}

variable "release_name" {
  description = "Helm release name for the Docker registry."
  type        = string
  default     = "registry"
}

variable "chart_version" {
  description = "Version of the docker-registry Helm chart."
  type        = string
  default     = "3.0.0"
}

variable "registry_load_balancer_ip" {
  description = "Static MetalLB IP assigned to the registry service."
  type        = string
}

variable "load_balancer_class" {
  description = "loadBalancerClass value for the registry service."
  type        = string
  default     = "metallb.io/metallb"
}

variable "storage_class_name" {
  description = "StorageClass used by the registry PVC."
  type        = string
  default     = "openebs-hdd-lvm"
}

variable "storage_size" {
  description = "Persistent volume size for the registry."
  type        = string
  default     = "100Gi"
}
