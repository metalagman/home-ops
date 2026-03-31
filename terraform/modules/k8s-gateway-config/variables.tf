variable "gateway_class_name" {
  description = "The name of the GatewayClass to use for the Gateway."
  type        = string
  default     = "nginx"
}

variable "gateway_namespace" {
  description = "The namespace where the Gateway will be created."
  type        = string
  default     = "gateway"
}

variable "gateway_name" {
  description = "The name of the Gateway resource."
  type        = string
  default     = "edge"
}

variable "gateway_https_hosts" {
  description = "A list of HTTPS hosts to configure on the Gateway, including their names, hostnames, and namespaces for route selection."
  type = list(object({
    name      = string
    hostname  = string
    namespace = string
  }))
  default = []
}

variable "gateway_service_annotations" {
  description = "Annotations to apply to the Gateway infrastructure Service."
  type        = map(string)
  default     = {}
}

variable "acme_contact_email" {
  description = "The email address for ACME registration and notifications (e.g., Let's Encrypt)."
  type        = string
  default     = "team@fastronome.com"
}
