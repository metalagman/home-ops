locals {
  nats_fullname = strcontains(var.release_name, "nats") ? var.release_name : "${var.release_name}-nats"
  service_name  = local.nats_fullname
  service_host  = "${local.service_name}.${kubernetes_namespace_v1.nats.metadata[0].name}.svc.cluster.local"
}

output "namespace" {
  description = "Namespace where NATS is deployed."
  value       = kubernetes_namespace_v1.nats.metadata[0].name
}

output "release_name" {
  description = "Helm release name for NATS."
  value       = helm_release.nats.name
}

output "service_host" {
  description = "In-cluster DNS host for the NATS service."
  value       = local.service_host
}

output "nats_url" {
  description = "In-cluster NATS client URL."
  value       = "nats://${local.service_host}:4222"
}
