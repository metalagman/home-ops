variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "argocd"
}

variable "namespace" {
  description = "Namespace in which to install Argo CD."
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Pinned Argo CD Helm chart version."
  type        = string
  default     = "9.3.4"
}

variable "app_version" {
  description = "Pinned Argo CD application tag used for CRDs."
  type        = string
  default     = "v3.2.5"
}

variable "values" {
  description = "Helm values documents."
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
