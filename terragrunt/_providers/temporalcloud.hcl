locals {
  temporal_cloud_api_key = get_env("TEMPORAL_CLOUD_API_KEY")
}

# Generate an Temporal Cloud provider block
generate "provider_temporal_cloud" {
  path      = "provider_temporal_cloud.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "temporalcloud" {
  api_key = "${local.temporal_cloud_api_key}"
}
EOF
}
