variable "namespace" {
  description = "Namespace for NGINX Gateway Fabric"
  type        = string
  default     = "nginx-gateway"
}

variable "helm_release_name" {
  description = "Helm release name for NGINX Gateway Fabric"
  type        = string
  default     = "ngf"
}

variable "service_type" {
  description = "Service type for the NGINX Gateway Fabric"
  type        = string
  default     = "LoadBalancer"
}

variable "chart_version" {
  description = "Helm chart version for NGINX Gateway Fabric"
  type        = string
  default     = "2.4.0"
}
