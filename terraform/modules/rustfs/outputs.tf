output "access_key_id" {
  description = "RustFS access key ID for S3-compatible clients."
  value       = kubernetes_secret_v1.rustfs_credentials.data["RUSTFS_ACCESS_KEY"]
  sensitive   = true
}

output "secret_access_key" {
  description = "RustFS secret access key for S3-compatible clients."
  value       = kubernetes_secret_v1.rustfs_credentials.data["RUSTFS_SECRET_KEY"]
  sensitive   = true
}
