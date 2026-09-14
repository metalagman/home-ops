variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "cert-manager"
}

variable "namespace" {
  description = "Namespace in which to install cert-manager."
  type        = string
  default     = "cert-manager"
}

variable "chart_version" {
  description = "Pinned cert-manager Helm chart version."
  type        = string
  default     = "v1.19.2"
}

variable "install_crds" {
  description = "Whether the Helm chart installs cert-manager CRDs."
  type        = bool
  default     = true
}

variable "enable_gateway_api" {
  description = "Whether cert-manager enables Gateway API integration."
  type        = bool
  default     = true
}

variable "values" {
  description = "Additional Helm values documents."
  type        = list(string)
  default     = null
}

variable "set" {
  description = "Additional Helm set values."
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}

variable "cleanup_on_fail" {
  description = "Whether Helm removes newly created resources after a failed operation."
  type        = bool
  default     = false
}

variable "upgrade_install" {
  description = "Whether Helm installs the release when an upgrade finds no existing release."
  type        = bool
  default     = false
}

variable "atomic" {
  description = "Whether failed Helm operations are rolled back atomically."
  type        = bool
  default     = false
}

variable "timeout" {
  description = "Helm operation timeout in seconds."
  type        = number
  default     = 300
}

variable "max_history" {
  description = "Maximum Helm release history."
  type        = number
  default     = 0
}
