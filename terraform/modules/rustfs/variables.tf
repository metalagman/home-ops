variable "namespace" {
  description = "Namespace for RustFS."
  type        = string
  default     = "rustfs"
}

variable "release_name" {
  description = "Helm release name for RustFS."
  type        = string
  default     = "rustfs"
}

variable "chart_version" {
  description = "Helm chart version for RustFS."
  type        = string
  default     = "0.0.90"
}

variable "existing_secret_name" {
  description = "Existing Kubernetes secret used by RustFS chart for credentials."
  type        = string
  default     = "rustfs-generated-credentials"
}

variable "load_balancer_class" {
  description = "loadBalancerClass value for the RustFS LoadBalancer service."
  type        = string
  default     = "metallb.io/metallb"
}

variable "storage_class_name" {
  description = "StorageClass name used by RustFS PVCs."
  type        = string
  default     = "openebs-hdd-lvm"
}
