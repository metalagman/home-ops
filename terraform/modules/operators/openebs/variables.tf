variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "openebs"
}

variable "namespace" {
  description = "Namespace in which to install OpenEBS."
  type        = string
  default     = "openebs"
}

variable "namespace_labels" {
  description = "Labels applied to the OpenEBS namespace."
  type        = map(string)
  default = {
    "pod-security.kubernetes.io/enforce" = "privileged"
  }
}

variable "chart_version" {
  description = "Pinned OpenEBS Helm chart version."
  type        = string
  default     = "4.4.0"
}

variable "values" {
  description = "Helm values documents defining the desired storage engines."
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

variable "timeout" {
  description = "Helm operation timeout in seconds."
  type        = number
  default     = 600
}

variable "max_history" {
  description = "Maximum Helm release history."
  type        = number
  default     = 0
}
