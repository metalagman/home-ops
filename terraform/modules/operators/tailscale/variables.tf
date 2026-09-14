variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "tailscale-operator"
}

variable "namespace" {
  description = "Namespace in which to install the Tailscale Operator."
  type        = string
  default     = "tailscale"
}

variable "namespace_labels" {
  description = "Labels applied to the operator namespace."
  type        = map(string)
  default     = {}
}

variable "oauth_secret_name" {
  description = "Name of the Kubernetes Secret consumed by the operator chart."
  type        = string
  default     = "operator-oauth"
}

variable "oauth_client_id" {
  description = "Tailscale OAuth client ID."
  type        = string
  sensitive   = true
}

variable "oauth_client_secret" {
  description = "Tailscale OAuth client secret."
  type        = string
  sensitive   = true
}

variable "chart_version" {
  description = "Pinned Tailscale Operator Helm chart version."
  type        = string
  default     = "1.94.2"
}

variable "values" {
  description = "Additional Helm values documents."
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
  default     = 300
}

variable "max_history" {
  description = "Maximum Helm release history."
  type        = number
  default     = 3
}
