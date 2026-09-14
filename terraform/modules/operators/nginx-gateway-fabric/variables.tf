variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "ngf"
}

variable "namespace" {
  description = "Namespace in which to install NGINX Gateway Fabric."
  type        = string
  default     = "nginx-gateway"
}

variable "chart_version" {
  description = "Pinned NGINX Gateway Fabric Helm chart version."
  type        = string
  default     = "2.4.2"
}

variable "crd_version" {
  description = "Pinned NGINX Gateway Fabric Git tag used for CRDs."
  type        = string
  default     = "v2.4.2"
}

variable "values" {
  description = "Helm values documents, including deployment-specific data-plane configuration."
  type        = list(string)
  default     = []
}

variable "set" {
  description = "Additional Helm set values."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "timeout" {
  description = "Helm operation timeout in seconds."
  type        = number
  default     = 600
}

variable "max_history" {
  description = "Maximum Helm release history."
  type        = number
  default     = 3
}
