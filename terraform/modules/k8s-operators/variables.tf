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
