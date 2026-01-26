locals {
  token = get_env("YC_TOKEN")
  cloud_id = get_env("YC_CLOUD_ID")
  folder_id = get_env("YC_FOLDER_ID")
  zone = get_env("YC_ZONE")
}

# Generate an Yandex Cloud provider block
generate "provider_yc" {
  path      = "provider_yc.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "yandex" {
  token     = "${local.token}"
  cloud_id  = "${local.cloud_id}"
  folder_id = "${local.folder_id}"
  zone = "${local.zone}"
}
EOF
}
