variable "clickhouse_namespace" {
  description = "Namespace for ClickHouse."
  type        = string
  default     = "clickhouse"
}

variable "clickhouse_cluster_name" {
  description = "Name of the ClickHouseCluster custom resource."
  type        = string
  default     = "practicum-clickhouse"
}

variable "keeper_cluster_name" {
  description = "Name of the KeeperCluster custom resource."
  type        = string
  default     = "practicum-clickhouse-keeper"
}

variable "clickhouse_replicas" {
  description = "Number of ClickHouse replicas."
  type        = number
  default     = 1
}

variable "clickhouse_shards" {
  description = "Number of ClickHouse shards."
  type        = number
  default     = 1
}

variable "keeper_replicas" {
  description = "Number of Keeper replicas."
  type        = number
  default     = 1
}

variable "clickhouse_storage_class_name" {
  description = "StorageClass name used by ClickHouse and Keeper PVCs."
  type        = string
  default     = "openebs-hdd-lvm"
}

variable "clickhouse_storage_size" {
  description = "Persistent volume size for ClickHouse data."
  type        = string
  default     = "100Gi"
}

variable "clickhouse_s3_endpoint" {
  description = "S3 endpoint URL (including bucket path) used by ClickHouse object storage disk."
  type        = string
  default     = "http://rustfs-svc.rustfs.svc.cluster.local:9000/clickhouse/"
}

variable "clickhouse_s3_cache_max_size" {
  description = "Max cache size for ClickHouse object storage cache disk."
  type        = string
  default     = "10Gi"
}

variable "clickhouse_s3_access_key_id" {
  description = "S3 access key ID used by ClickHouse for object storage."
  type        = string
  sensitive   = true
}

variable "clickhouse_s3_secret_access_key" {
  description = "S3 secret access key used by ClickHouse for object storage."
  type        = string
  sensitive   = true
}

variable "clickhouse_s3_credentials_secret_name" {
  description = "Name of the Kubernetes secret in ClickHouse namespace that stores S3 credentials."
  type        = string
  default     = "clickhouse-s3-credentials"
}

variable "keeper_storage_size" {
  description = "Persistent volume size for Keeper data."
  type        = string
  default     = "10Gi"
}

variable "clickhouse_service_name" {
  description = "Kubernetes Service name used to expose ClickHouse."
  type        = string
  default     = "practicum-clickhouse-lb"
}

variable "clickhouse_service_selector" {
  description = "Selector labels for ClickHouse pods backing the LoadBalancer service."
  type        = map(string)
  default     = {}
}

variable "clickhouse_service_annotations" {
  description = "Annotations to apply to the ClickHouse LoadBalancer service."
  type        = map(string)
  default     = {}
}

variable "clickhouse_service_load_balancer_ip" {
  description = "Optional static IP for the ClickHouse LoadBalancer service."
  type        = string
  default     = null
}

variable "clickhouse_service_load_balancer_class" {
  description = "Load balancer class for the ClickHouse service."
  type        = string
  default     = "metallb.io/metallb"
}

variable "clickhouse_service_external_traffic_policy" {
  description = "External traffic policy for the ClickHouse LoadBalancer service (Cluster or Local)."
  type        = string
  default     = "Cluster"
}

variable "clickhouse_service_native_port" {
  description = "ClickHouse native TCP service port."
  type        = number
  default     = 9000
}

variable "clickhouse_service_http_port" {
  description = "ClickHouse HTTP service port."
  type        = number
  default     = 8123
}
