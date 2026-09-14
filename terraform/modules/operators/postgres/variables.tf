variable "enabled" {
  description = "Whether to install Postgres Operator."
  type        = bool
  default     = true
}

variable "release_name" {
  description = "Postgres Operator Helm release name."
  type        = string
  default     = "postgres-operator"
}

variable "namespace" {
  description = "Namespace in which to install Postgres Operator."
  type        = string
  default     = "postgres-operator"
}

variable "chart_version" {
  description = "Pinned Postgres Operator Helm chart version."
  type        = string
  default     = "1.11.0"
}

variable "values" {
  description = "Postgres Operator Helm values documents."
  type        = list(string)
  default     = []
}

variable "ui_enabled" {
  description = "Whether to install Postgres Operator UI."
  type        = bool
  default     = true
}

variable "ui_release_name" {
  description = "Postgres Operator UI Helm release name."
  type        = string
  default     = "postgres-operator-ui"
}

variable "ui_chart_version" {
  description = "Pinned Postgres Operator UI Helm chart version."
  type        = string
  default     = "1.11.0"
}

variable "ui_values" {
  description = "Postgres Operator UI Helm values documents."
  type        = list(string)
  default     = []
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
