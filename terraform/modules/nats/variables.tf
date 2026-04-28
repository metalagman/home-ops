variable "namespace" {
  description = "Namespace for NATS."
  type        = string
  default     = "nats"
}

variable "release_name" {
  description = "Helm release name for NATS."
  type        = string
  default     = "nats"
}

variable "chart_version" {
  description = "Version of the NATS Helm chart."
  type        = string
  default     = "1.1.11"
}

variable "jetstream_storage_class_name" {
  description = "StorageClass used by the JetStream PVC."
  type        = string
  default     = "openebs-hdd-lvm"
}

variable "jetstream_storage_size" {
  description = "Persistent volume size for JetStream storage."
  type        = string
  default     = "10Gi"
}
