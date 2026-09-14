variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "reloader"
}

variable "namespace" {
  description = "Namespace in which to install Reloader."
  type        = string
  default     = "reloader"
}

variable "chart_version" {
  description = "Pinned Reloader Helm chart version."
  type        = string
  default     = "2.2.14"
}

variable "values" {
  description = "Helm values documents."
  type        = list(string)
  default     = []
}

variable "set" {
  description = "Helm set values."
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
