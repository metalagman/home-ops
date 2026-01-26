variable "cert_manager_contact_email" {
  description = "Contact email for cert-manager ACME registrations."
  type        = string
}

variable "istio_gateway_service_type" {
  description = "Service type for the Istio ingress gateway."
  type        = string
}

variable "istio_gateway_load_balancer_class" {
  description = "Load balancer class for the Istio ingress gateway service."
  type        = string
}
