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

variable "chart_version" {
  description = "Version of the NGINX Gateway Fabric chart"
  type        = string
  default     = "2.3.0"
}

variable "chart_values" {
  description = "Additional values to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "chart_set" {
  description = "Additional set values to pass to the Helm chart"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
