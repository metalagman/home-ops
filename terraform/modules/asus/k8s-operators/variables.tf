variable "clickhouse_operator_chart_version" {
  description = "Helm chart version for ClickHouse Operator."
  type        = string
  default     = "0.0.3"
}

variable "clickhouse_operator_namespace" {
  description = "Namespace for ClickHouse Operator."
  type        = string
  default     = "clickhouse-operator-system"
}

variable "nginx_gateway_fabric_namespace" {
  description = "Namespace for NGINX Gateway Fabric."
  type        = string
  default     = "nginx-gateway"
}

variable "nginx_gateway_fabric_helm_release_name" {
  description = "Helm release name for NGINX Gateway Fabric."
  type        = string
  default     = "ngf"
}

variable "nginx_gateway_fabric_chart_version" {
  description = "Helm chart version for NGINX Gateway Fabric."
  type        = string
  default     = "2.4.2"
}

variable "nginx_gateway_fabric_crd_version" {
  description = "CRD tag version for NGINX Gateway Fabric."
  type        = string
  default     = "v2.4.2"
}

variable "nginx_gateway_fabric_chart_set" {
  description = "Additional set values for the NGINX Gateway Fabric Helm chart."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "postgres_operator_enabled" {
  description = "Whether to install the Zalando Postgres Operator."
  type        = bool
  default     = true
}

variable "postgres_operator_namespace" {
  description = "Namespace for the Zalando Postgres Operator."
  type        = string
  default     = "postgres-operator"
}

variable "postgres_operator_chart_version" {
  description = "Helm chart version for the Zalando Postgres Operator."
  type        = string
  default     = "1.11.0"
}

variable "postgres_operator_values" {
  description = "Additional values for the Zalando Postgres Operator Helm chart."
  type        = list(string)
  default     = []
}

variable "postgres_operator_ui_enabled" {
  description = "Whether to install the Zalando Postgres Operator UI."
  type        = bool
  default     = true
}

variable "postgres_operator_ui_chart_version" {
  description = "Helm chart version for the Zalando Postgres Operator UI."
  type        = string
  default     = "1.11.0"
}

variable "postgres_operator_ui_values" {
  description = "Additional values for the Zalando Postgres Operator UI Helm chart."
  type        = list(string)
  default     = []
}
