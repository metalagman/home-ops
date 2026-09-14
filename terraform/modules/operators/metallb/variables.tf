variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "metallb"
}

variable "namespace" {
  description = "Namespace in which to install MetalLB."
  type        = string
  default     = "metallb-system"
}

variable "namespace_labels" {
  description = "Labels applied to the MetalLB namespace."
  type        = map(string)
  default = {
    "pod-security.kubernetes.io/enforce" = "privileged"
    "pod-security.kubernetes.io/audit"   = "privileged"
    "pod-security.kubernetes.io/warn"    = "privileged"
  }
}

variable "chart_version" {
  description = "Pinned MetalLB Helm chart version."
  type        = string
  default     = "0.15.3"
}

variable "values" {
  description = "Helm values documents."
  type        = list(string)
  default     = null
}

variable "set" {
  description = "Helm set values."
  type = list(object({
    name  = string
    value = string
  }))
  default = null
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
