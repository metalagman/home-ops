variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "clickhouse-operator"
}

variable "namespace" {
  description = "Namespace in which to install ClickHouse Operator."
  type        = string
  default     = "clickhouse-operator-system"
}

variable "chart_version" {
  description = "Pinned ClickHouse Operator Helm chart version."
  type        = string
  default     = "0.0.3"
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
  default     = 600
}

variable "max_history" {
  description = "Maximum Helm release history."
  type        = number
  default     = 3
}
